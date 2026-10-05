Title:
Managed terminal exits active AI CLI sessions and leaks raw ANSI key sequences

Body:
**Location:** 1DevTool > Project workspace > Managed Terminal / Agent Terminal > PTY session lifecycle and Autopilot

**Mô tả:**

Trong 1DevTool, terminal agent có thể tự thoát về PowerShell khi AI CLI vẫn đang xử lý tác vụ. Sự cố đã xảy ra với cả `Devin CLI` và `Cursor CLI`, vì vậy dấu hiệu hiện tại cho thấy vấn đề nằm ở lớp terminal/PTY hoặc quản lý vòng đời phiên dùng chung của 1DevTool, không phải riêng một AI CLI.

Môi trường ghi nhận:

- 1DevTool `1.76.8` (`ProductVersion 1.76.8.0`), updater xác nhận đây là phiên bản mới nhất tại thời điểm kiểm tra.
- Windows 11 Pro 64-bit, version `10.0.22631`, build `22631`.
- Devin CLI `3000.11.3` (`9c803229faa4`).
- Cursor CLI `2026.10.01-e373342`.
- Terminal Devin được khởi chạy bằng `devin --permission-mode dangerous`.
- Dự án tái hiện chính: `D:\Flutter\trantandat0468_apirest`.

Các bước tái hiện:

1 - Mở một project trong 1DevTool.
2 - Tạo terminal agent bằng Devin CLI hoặc Cursor CLI.
3 - Gửi một tác vụ có chỉnh sửa/ghi file và chờ CLI thực thi.
4 - Trong lúc giao diện vẫn hiển thị trạng thái đang làm việc, ví dụ `Writing .\docs\API_USAGE_GUIDE.md · 35s`, terminal tự quay về prompt PowerShell.
5 - Nhấn phím mũi tên lên sau khi CLI thoát; terminal hiển thị chuỗi thô như `^[[A` thay vì xử lý phím lịch sử lệnh.

Kết quả thực tế:

- AI CLI bị kết thúc giữa lượt xử lý mà không hiển thị lỗi crash tại terminal.
- Terminal quay về prompt `D:\Flutter\trantandat0468_apirest>`.
- Các phím điều hướng có thể bị in thành escape sequence, ví dụ phím Up trở thành `^[[A` (`ESC [ A`).
- Cấu hình 1DevTool sau sự cố lưu terminal Devin với `isActive: false`.
- Ứng dụng 1DevTool chính vẫn tiếp tục chạy; chỉ tiến trình CLI/PTY trong terminal bị đóng.

Kết quả mong đợi: terminal phải giữ nguyên phiên AI CLI cho đến khi CLI tự kết thúc hoặc người dùng chủ động đóng/cancel. Nếu child process kết thúc bất thường, 1DevTool cần hiển thị nguyên nhân, exit code và nguồn phát sinh thao tác đóng. Terminal cũng phải khôi phục đầy đủ input mode trước khi trả quyền điều khiển về shell, để phím mũi tên không bị hiển thị thành ANSI bytes.

Bằng chứng timeline từ log Devin, thời gian log là UTC (`02:02:56Z` tương ứng `09:02:56` UTC+7):

- `02:02:56.249727Z`: ACP nhận `session/prompt`; lượt xử lý mới bắt đầu.
- `02:03:05.097059Z` và `02:03:20.104592Z`: tiến trình vẫn hoạt động và tiếp tục discovery skills.
- `02:03:32.688991Z`: log ghi `Dispatched SessionEnd for session thread-stock`.
- `02:03:32.689127Z`: `await_turn_completion` đóng sau `36.4s`, trùng với trạng thái đang làm việc trong ảnh.
- `02:03:32.692042Z`: ACP server đóng sạch với `close time.busy=12.3s time.idle=1351s`.
- Không có `panic`, application crash hoặc Windows Application Error trong khoảng thời gian xảy ra sự cố.

Bằng chứng từ log orchestration của 1DevTool cho thấy bộ theo dõi trạng thái không nhất quán trước khi phiên đóng:

- `01:55:20.171Z`: Autopilot đánh dấu terminal Devin là `marked-finished` vì checker cho rằng composer đang idle.
- `01:56:28.410Z`: checker Codex unavailable với `exit 1`.
- `01:56:30.227Z`: checker Gemini unavailable với `exit 55`, sau đó log ghi `went quiet mid-task and Autopilot could not tell why`.
- `01:58:30.196Z`: cùng terminal lại được đánh dấu `marked-finished`.
- Với Cursor CLI, `03:21:50.073Z` ghi `no checker produced a verdict`, sau đó `Cursor CLI went quiet mid-task and Autopilot could not tell why`.

Các warning `remote config 404`, MCP `401 Unauthorized`, hoặc MCP local connection refused xuất hiện trong log nhưng không trùng trực tiếp với thời điểm đóng phiên và CLI vẫn tiếp tục hoạt động sau các warning này. Vì vậy chúng không được xem là nguyên nhân trực tiếp của việc terminal thoát.

Phân tích hiện tại: parent terminal/PTY hoặc client quản lý session đã đóng kênh stdio/ACP khi lượt xử lý vẫn đang chạy. Devin nhận `SessionEnd` và thoát sạch, thay vì crash. Việc Cursor CLI gặp cùng triệu chứng củng cố giả thuyết lỗi nằm ở lifecycle dùng chung của terminal 1DevTool. Chuỗi `^[[A` là hậu quả thứ cấp: sau khi TUI bị đóng, input mode hoặc routing của PTY chưa được khôi phục đúng trước khi PowerShell nhận bàn phím.

Đề nghị bổ sung diagnostic ở lớp terminal lifecycle:

- Ghi `terminalId`, PID, child PID, exit code, signal và lý do đóng cho mọi sự kiện PTY exit/dispose.
- Ghi nguồn gọi hành động đóng: user action, tab disposal, project switch, Autopilot, renderer reload, EOF/stdin close hoặc process crash.
- Không dispose terminal dựa trên kết quả `marked-finished`; trạng thái task hoàn tất không đồng nghĩa với việc được phép đóng CLI process.
- Reset terminal mode và flush/reroute input khi TUI kết thúc trước khi trả quyền điều khiển về PowerShell.
- Khi checker không đưa ra verdict hoặc báo `went quiet mid-task`, giữ terminal sống và chỉ cảnh báo người dùng.

Mức độ đề xuất: `Major`. Tần suất ghi nhận: `Often` vì cùng biểu hiện xuất hiện trên ít nhất hai CLI khác nhau. Sự cố có thể làm mất lượt agent đang chạy và khiến người dùng không biết tác vụ đã hoàn tất hay bị dừng giữa chừng.

**Attachment:**

- Ảnh `codex-clipboard-EGMZX2.png` cho thấy Devin vẫn hiển thị `Writing .\docs\API_USAGE_GUIDE.md · 35s`, ngay bên dưới terminal đã quay về PowerShell và xuất hiện `^[[A`.
- Log 1DevTool nguồn: `C:\Users\ACER\AppData\Roaming\1devtool\logs\orchestration.log`, các dòng `1317-1322` và `1335-1336`.
- Log Devin nguồn: `C:\Users\ACER\AppData\Roaming\devin\cli\logs\devin_20261005-084049_32232.log`, các dòng `442-454`.
- Cấu hình terminal nguồn: `C:\Users\ACER\AppData\Roaming\1devtool\1devtool.json`, terminal id `01fd6887-1257-461b-bf8f-a71f5fddc502`.
