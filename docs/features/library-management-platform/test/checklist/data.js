window.FEATURE = "library-management-platform";
window.UPDATED = "2026-10-08";
window.CHECKLISTS_DATA = [
  {
    "scope": "feature",
    "target": "",
    "file": "checklist-feature.md",
    "items": [
      {
        "chk": "CHK-LMP-001",
        "ref": [
          "FR-LMP-006",
          "BR-LMP-015"
        ],
        "category": "Xác thực và phiên làm việc",
        "subcategory": "Vào đúng phạm vi vai trò",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra người dùng hợp lệ xác thực thành công thì chỉ mở không gian làm việc đúng vai trò đã cấp"
      },
      {
        "chk": "CHK-LMP-002",
        "ref": [
          "FR-LMP-006",
          "E-LMP-002"
        ],
        "category": "Xác thực và phiên làm việc",
        "subcategory": "Vào đúng phạm vi vai trò",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra người dùng không có quyền thì bị từ chối và không thấy dữ liệu ngoài quyền"
      },
      {
        "chk": "CHK-LMP-003",
        "ref": [
          "FR-LMP-006",
          "E-LMP-002"
        ],
        "category": "Xác thực và phiên làm việc",
        "subcategory": "Vào đúng phạm vi vai trò",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra lần truy cập bị từ chối được ghi nhận"
      },
      {
        "chk": "CHK-LMP-004",
        "ref": [
          "FR-LMP-006",
          "E-LMP-016",
          "BR-LMP-015"
        ],
        "category": "Xác thực và phiên làm việc",
        "subcategory": "Vào đúng phạm vi vai trò",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra trường nhạy cảm bị che với người không có quyền trường đó"
      },
      {
        "chk": "CHK-LMP-005",
        "ref": [
          "FR-LMP-007",
          "E-LMP-017"
        ],
        "category": "Xác thực và phiên làm việc",
        "subcategory": "Phiên hết hạn và xác thực lại",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra phiên hết hạn thì dữ liệu đã ghi vẫn còn"
      },
      {
        "chk": "CHK-LMP-006",
        "ref": [
          "FR-LMP-007",
          "E-LMP-017"
        ],
        "category": "Xác thực và phiên làm việc",
        "subcategory": "Phiên hết hạn và xác thực lại",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra hành động đang dở không được ghi khi phiên hết hạn"
      },
      {
        "chk": "CHK-LMP-007",
        "ref": [
          "FR-LMP-007",
          "E-LMP-017"
        ],
        "category": "Xác thực và phiên làm việc",
        "subcategory": "Phiên hết hạn và xác thực lại",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra tác vụ nhạy cảm không chạy khi người dùng chưa xác thực lại"
      },
      {
        "chk": "CHK-LMP-008",
        "ref": [
          "FR-LMP-001"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Hồ sơ thư mục",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra Quản trị viên lưu hồ sơ thư mục hợp lệ thì mở lại đúng thuộc tính đã lưu"
      },
      {
        "chk": "CHK-LMP-009",
        "ref": [
          "FR-LMP-001",
          "E-LMP-001"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Hồ sơ thư mục",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra hồ sơ thư mục thiếu dữ liệu bắt buộc không được ghi"
      },
      {
        "chk": "CHK-LMP-010",
        "ref": [
          "FR-LMP-001",
          "E-LMP-001"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Hồ sơ thư mục",
        "priority": 2,
        "auto": "Yes",
        "text": "Kiểm tra form hồ sơ thư mục giữ dữ liệu đã nhập sau lỗi validation"
      },
      {
        "chk": "CHK-LMP-011",
        "ref": [
          "FR-LMP-001",
          "E-LMP-003"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Hồ sơ thư mục",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra khóa nghiệp vụ đã tồn tại không tạo hồ sơ thư mục thứ hai"
      },
      {
        "chk": "CHK-LMP-012",
        "ref": [
          "FR-LMP-001",
          "BR-LMP-017",
          "E-LMP-015"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Hồ sơ thư mục",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra hồ sơ thư mục đã có lịch sử không bị xóa cứng"
      },
      {
        "chk": "CHK-LMP-013",
        "ref": [
          "FR-LMP-001",
          "E-LMP-002"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Hồ sơ thư mục",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra người không có quyền catalog không ghi được hồ sơ thư mục"
      },
      {
        "chk": "CHK-LMP-014",
        "ref": [
          "FR-LMP-002",
          "FR-LMP-026"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Bản sao và mã định vị",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra đăng ký bản sao gắn đúng một mã định vị chưa trùng"
      },
      {
        "chk": "CHK-LMP-015",
        "ref": [
          "FR-LMP-026",
          "BR-LMP-011"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Bản sao và mã định vị",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra quét mã chỉ mở đúng bản ghi"
      },
      {
        "chk": "CHK-LMP-016",
        "ref": [
          "FR-LMP-026",
          "BR-LMP-011"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Bản sao và mã định vị",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra sau khi quét mã hệ thống vẫn xét quyền người đang thao tác"
      },
      {
        "chk": "CHK-LMP-017",
        "ref": [
          "FR-LMP-002",
          "E-LMP-003"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Bản sao và mã định vị",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra mã định vị đã dùng không tạo bản sao mới"
      },
      {
        "chk": "CHK-LMP-018",
        "ref": [
          "FR-LMP-002",
          "BR-LMP-017",
          "E-LMP-015"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Bản sao và mã định vị",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra bản sao đã có lịch sử không bị xóa cứng"
      },
      {
        "chk": "CHK-LMP-019",
        "ref": [
          "FR-LMP-003"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Tra cứu khả dụng",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra số khả dụng, đang giữ, đang mượn và không khả dụng khớp trạng thái các bản sao"
      },
      {
        "chk": "CHK-LMP-020",
        "ref": [
          "FR-LMP-003",
          "E-LMP-003"
        ],
        "category": "Danh mục và bản sao",
        "subcategory": "Tra cứu khả dụng",
        "priority": 2,
        "auto": "Yes",
        "text": "Kiểm tra tra cứu không khớp không trả một đầu sách giả"
      },
      {
        "chk": "CHK-LMP-021",
        "ref": [
          "FR-LMP-004"
        ],
        "category": "Hồ sơ người đọc",
        "subcategory": "Tạo và cập nhật",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra lưu hồ sơ người đọc giữ đúng thông tin liên hệ đã nhập"
      },
      {
        "chk": "CHK-LMP-022",
        "ref": [
          "FR-LMP-004"
        ],
        "category": "Hồ sơ người đọc",
        "subcategory": "Tạo và cập nhật",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra lưu hồ sơ người đọc giữ đúng trạng thái hoạt động đã chọn"
      },
      {
        "chk": "CHK-LMP-023",
        "ref": [
          "FR-LMP-004",
          "E-LMP-001"
        ],
        "category": "Hồ sơ người đọc",
        "subcategory": "Tạo và cập nhật",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra hồ sơ người đọc thiếu dữ liệu bắt buộc không được ghi"
      },
      {
        "chk": "CHK-LMP-024",
        "ref": [
          "FR-LMP-004",
          "E-LMP-003"
        ],
        "category": "Hồ sơ người đọc",
        "subcategory": "Tạo và cập nhật",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra định danh người đọc đã tồn tại không tạo hồ sơ thứ hai"
      },
      {
        "chk": "CHK-LMP-025",
        "ref": [
          "FR-LMP-004",
          "E-LMP-016",
          "BR-LMP-015"
        ],
        "category": "Hồ sơ người đọc",
        "subcategory": "Tạo và cập nhật",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra trường dữ liệu cá nhân ngoài quyền bị che"
      },
      {
        "chk": "CHK-LMP-026",
        "ref": [
          "FR-LMP-004",
          "BR-LMP-017"
        ],
        "category": "Hồ sơ người đọc",
        "subcategory": "Tạo và cập nhật",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra hồ sơ người đọc đã có lịch sử không bị xóa cứng"
      },
      {
        "chk": "CHK-LMP-027",
        "ref": [
          "FR-LMP-021"
        ],
        "category": "Cấu hình quy định",
        "subcategory": "Hiệu lực theo thời điểm",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra giao dịch bắt đầu sau thời điểm hiệu lực dùng tham số mới"
      },
      {
        "chk": "CHK-LMP-028",
        "ref": [
          "FR-LMP-021"
        ],
        "category": "Cấu hình quy định",
        "subcategory": "Hiệu lực theo thời điểm",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra giao dịch đã ghi giữ bằng chứng quy định tại thời điểm ghi"
      },
      {
        "chk": "CHK-LMP-029",
        "ref": [
          "FR-LMP-021",
          "E-LMP-002"
        ],
        "category": "Cấu hình quy định",
        "subcategory": "Hiệu lực theo thời điểm",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra người không có quyền cấu hình không đổi được quy định đang hiệu lực"
      },
      {
        "chk": "CHK-LMP-030",
        "ref": [
          "FR-LMP-021",
          "E-LMP-001"
        ],
        "category": "Cấu hình quy định",
        "subcategory": "Hiệu lực theo thời điểm",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra tham số không hợp lệ theo quy tắc đã phê duyệt không được kích hoạt"
      },
      {
        "chk": "CHK-LMP-031",
        "ref": [
          "FR-LMP-022",
          "BR-LMP-014"
        ],
        "category": "Nhập liệu",
        "subcategory": "Dry-run",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra dry-run báo tổng dòng, dòng hợp lệ, dòng lỗi kèm lý do, dòng trùng và dòng bỏ qua"
      },
      {
        "chk": "CHK-LMP-032",
        "ref": [
          "FR-LMP-022",
          "BR-LMP-014"
        ],
        "category": "Nhập liệu",
        "subcategory": "Dry-run",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra dry-run không đổi kho chính thức"
      },
      {
        "chk": "CHK-LMP-033",
        "ref": [
          "FR-LMP-022",
          "E-LMP-014"
        ],
        "category": "Nhập liệu",
        "subcategory": "Dry-run",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra file không đọc được không ghi dữ liệu nghiệp vụ"
      },
      {
        "chk": "CHK-LMP-034",
        "ref": [
          "FR-LMP-022",
          "BR-LMP-014"
        ],
        "category": "Nhập liệu",
        "subcategory": "Commit lô",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra commit lô đã dry-run đạt thì kho nhận đúng lô đó"
      },
      {
        "chk": "CHK-LMP-035",
        "ref": [
          "FR-LMP-022",
          "FR-LMP-026"
        ],
        "category": "Nhập liệu",
        "subcategory": "Commit lô",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra commit lô cấp mã định vị không trùng"
      },
      {
        "chk": "CHK-LMP-036",
        "ref": [
          "FR-LMP-022",
          "BR-LMP-014"
        ],
        "category": "Nhập liệu",
        "subcategory": "Commit lô",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra báo cáo đối soát sau commit có số lượng, dòng lỗi và dòng bỏ qua"
      },
      {
        "chk": "CHK-LMP-037",
        "ref": [
          "FR-LMP-022",
          "BR-LMP-014",
          "E-LMP-014"
        ],
        "category": "Nhập liệu",
        "subcategory": "Commit lô",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra dry-run còn lỗi và chưa có override đã duyệt thì không ghi kho"
      },
      {
        "chk": "CHK-LMP-038",
        "ref": [
          "FR-LMP-022",
          "E-LMP-014"
        ],
        "category": "Nhập liệu",
        "subcategory": "Commit lô",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra một dòng commit lỗi làm rollback toàn bộ lô"
      },
      {
        "chk": "CHK-LMP-039",
        "ref": [
          "FR-LMP-022",
          "E-LMP-006"
        ],
        "category": "Nhập liệu",
        "subcategory": "Commit lô",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra gửi lại cùng operation_id trả kết quả lô gốc"
      },
      {
        "chk": "CHK-LMP-040",
        "ref": [
          "FR-LMP-020",
          "BR-LMP-013",
          "E-LMP-013"
        ],
        "category": "Nhập liệu",
        "subcategory": "Commit lô",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra audit không ghi được thì lô import bị rollback"
      },
      {
        "chk": "CHK-LMP-041",
        "ref": [
          "FR-LMP-020"
        ],
        "category": "Audit",
        "subcategory": "Bằng chứng hành động nhạy cảm",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra người có quyền xem được ai thực hiện hành động nhạy cảm đã commit"
      },
      {
        "chk": "CHK-LMP-042",
        "ref": [
          "FR-LMP-020"
        ],
        "category": "Audit",
        "subcategory": "Bằng chứng hành động nhạy cảm",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra bằng chứng audit của hành động đã commit có thời điểm, tài nguyên và kết quả"
      },
      {
        "chk": "CHK-LMP-043",
        "ref": [
          "FR-LMP-020",
          "BR-LMP-013",
          "E-LMP-013"
        ],
        "category": "Audit",
        "subcategory": "Bằng chứng hành động nhạy cảm",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra audit thất bại thì hành động nhạy cảm không còn kết quả đã commit"
      },
      {
        "chk": "CHK-LMP-044",
        "ref": [
          "FR-LMP-020",
          "E-LMP-002",
          "E-LMP-016"
        ],
        "category": "Audit",
        "subcategory": "Bằng chứng hành động nhạy cảm",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra người không có quyền audit bị từ chối"
      },
      {
        "chk": "CHK-LMP-045",
        "ref": [
          "FR-LMP-008",
          "BR-LMP-001"
        ],
        "category": "Mượn tại quầy",
        "subcategory": "Phiếu nhiều bản sao",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra phiếu đủ điều kiện ghi toàn bộ khoản mượn trong một giao dịch"
      },
      {
        "chk": "CHK-LMP-046",
        "ref": [
          "FR-LMP-008",
          "BR-LMP-001"
        ],
        "category": "Mượn tại quầy",
        "subcategory": "Phiếu nhiều bản sao",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra phiếu đủ điều kiện chuyển mọi bản sao trong phiếu sang đang mượn"
      },
      {
        "chk": "CHK-LMP-047",
        "ref": [
          "FR-LMP-008",
          "BR-LMP-001",
          "BR-LMP-002",
          "E-LMP-004"
        ],
        "category": "Mượn tại quầy",
        "subcategory": "Phiếu nhiều bản sao",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra một bản sao không hợp lệ thì không khoản mượn nào trong phiếu được ghi"
      },
      {
        "chk": "CHK-LMP-048",
        "ref": [
          "FR-LMP-008",
          "BR-LMP-003",
          "E-LMP-007"
        ],
        "category": "Mượn tại quầy",
        "subcategory": "Phiếu nhiều bản sao",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra người đọc không đủ điều kiện thì không tạo phiếu"
      },
      {
        "chk": "CHK-LMP-049",
        "ref": [
          "FR-LMP-008",
          "E-LMP-007"
        ],
        "category": "Mượn tại quầy",
        "subcategory": "Phiếu nhiều bản sao",
        "priority": 2,
        "auto": "Yes",
        "text": "Kiểm tra người đọc không đủ điều kiện thì màn mượn nêu lý do bị chặn"
      },
      {
        "chk": "CHK-LMP-050",
        "ref": [
          "FR-LMP-009",
          "E-LMP-006"
        ],
        "category": "Mượn tại quầy",
        "subcategory": "Phiếu nhiều bản sao",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra gửi lại cùng yêu cầu mượn không tạo phiếu thứ hai"
      },
      {
        "chk": "CHK-LMP-051",
        "ref": [
          "FR-LMP-009",
          "E-LMP-005"
        ],
        "category": "Mượn tại quầy",
        "subcategory": "Phiếu nhiều bản sao",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra phiếu thua khi tranh cùng một bản sao không ghi khoản mượn nào"
      },
      {
        "chk": "CHK-LMP-052",
        "ref": [
          "FR-LMP-008",
          "BR-LMP-013",
          "E-LMP-013"
        ],
        "category": "Mượn tại quầy",
        "subcategory": "Phiếu nhiều bản sao",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra audit thất bại thì phiếu mượn không được giữ"
      },
      {
        "chk": "CHK-LMP-053",
        "ref": [
          "FR-LMP-026",
          "BR-LMP-011"
        ],
        "category": "Mượn tại quầy",
        "subcategory": "Phiếu nhiều bản sao",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra quét mã lúc mượn vẫn phải qua kiểm tra điều kiện mượn"
      },
      {
        "chk": "CHK-LMP-054",
        "ref": [
          "FR-LMP-010"
        ],
        "category": "Trả sách",
        "subcategory": "Đóng khoản mượn",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra nhận trả đóng khoản mượn trước khi bản sao nhận trạng thái tiếp theo"
      },
      {
        "chk": "CHK-LMP-055",
        "ref": [
          "FR-LMP-010"
        ],
        "category": "Trả sách",
        "subcategory": "Đóng khoản mượn",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra người đọc không đủ điều kiện mượn mới vẫn đóng được khoản mượn khi trả"
      },
      {
        "chk": "CHK-LMP-056",
        "ref": [
          "FR-LMP-010",
          "E-LMP-015"
        ],
        "category": "Trả sách",
        "subcategory": "Đóng khoản mượn",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra trả lại bản sao của khoản đã đóng không nhân đôi kết quả"
      },
      {
        "chk": "CHK-LMP-057",
        "ref": [
          "FR-LMP-010",
          "E-LMP-005"
        ],
        "category": "Trả sách",
        "subcategory": "Đóng khoản mượn",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra yêu cầu trả đến sau không đóng phiếu thêm một lần nữa"
      },
      {
        "chk": "CHK-LMP-058",
        "ref": [
          "FR-LMP-010",
          "BR-LMP-013",
          "E-LMP-013"
        ],
        "category": "Trả sách",
        "subcategory": "Đóng khoản mượn",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra audit thất bại thì lần trả không đổi khoản mượn"
      },
      {
        "chk": "CHK-LMP-059",
        "ref": [
          "FR-LMP-014",
          "BR-LMP-007"
        ],
        "category": "Phạt và thu tiền mặt",
        "subcategory": "Ghi nhận phạt quá hạn",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra trả quá hạn ghi đúng một FinancialEvent ASSESSMENT"
      },
      {
        "chk": "CHK-LMP-060",
        "ref": [
          "FR-LMP-014",
          "BR-LMP-007"
        ],
        "category": "Phạt và thu tiền mặt",
        "subcategory": "Ghi nhận phạt quá hạn",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra sau khi ghi phạt quá hạn thì Fine ở trạng thái UNPAID"
      },
      {
        "chk": "CHK-LMP-061",
        "ref": [
          "FR-LMP-014",
          "BR-LMP-007"
        ],
        "category": "Phạt và thu tiền mặt",
        "subcategory": "Ghi nhận phạt quá hạn",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra event phạt đã ghi không bị sửa trực tiếp"
      },
      {
        "chk": "CHK-LMP-062",
        "ref": [
          "FR-LMP-014",
          "E-LMP-015"
        ],
        "category": "Phạt và thu tiền mặt",
        "subcategory": "Ghi nhận phạt quá hạn",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra trả lặp không tạo ASSESSMENT thứ hai"
      },
      {
        "chk": "CHK-LMP-063",
        "ref": [
          "FR-LMP-014",
          "BR-LMP-013",
          "E-LMP-013"
        ],
        "category": "Phạt và thu tiền mặt",
        "subcategory": "Ghi nhận phạt quá hạn",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra audit thất bại thì Fine và ASSESSMENT của lần phạt bị rollback"
      },
      {
        "chk": "CHK-LMP-064",
        "ref": [
          "FR-LMP-015",
          "BR-LMP-007",
          "BR-LMP-008"
        ],
        "category": "Phạt và thu tiền mặt",
        "subcategory": "Thu tiền mặt",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra thu tiền mặt hợp lệ ghi đúng một FinancialEvent PAYMENT"
      },
      {
        "chk": "CHK-LMP-065",
        "ref": [
          "FR-LMP-015"
        ],
        "category": "Phạt và thu tiền mặt",
        "subcategory": "Thu tiền mặt",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra Fine chuyển sang PAID khi số dư sau khoản thu bằng 0"
      },
      {
        "chk": "CHK-LMP-066",
        "ref": [
          "FR-LMP-015",
          "BR-LMP-008",
          "E-LMP-006",
          "E-LMP-010"
        ],
        "category": "Phạt và thu tiền mặt",
        "subcategory": "Thu tiền mặt",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra cùng operation_id không tạo PAYMENT thứ hai"
      },
      {
        "chk": "CHK-LMP-067",
        "ref": [
          "FR-LMP-015",
          "E-LMP-009"
        ],
        "category": "Phạt và thu tiền mặt",
        "subcategory": "Thu tiền mặt",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra ghi PAYMENT thất bại thì Fine giữ nghĩa vụ cũ"
      },
      {
        "chk": "CHK-LMP-068",
        "ref": [
          "FR-LMP-015",
          "E-LMP-005"
        ],
        "category": "Phạt và thu tiền mặt",
        "subcategory": "Thu tiền mặt",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra khoản thu đến sau không ghi số tiền vượt số dư tại lúc commit"
      },
      {
        "chk": "CHK-LMP-069",
        "ref": [
          "FR-LMP-015",
          "BR-LMP-013",
          "E-LMP-013"
        ],
        "category": "Phạt và thu tiền mặt",
        "subcategory": "Thu tiền mặt",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra audit thất bại thì PAYMENT bị rollback"
      },
      {
        "chk": "CHK-LMP-070",
        "ref": [
          "FR-LMP-015",
          "E-LMP-016"
        ],
        "category": "Phạt và thu tiền mặt",
        "subcategory": "Thu tiền mặt",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra Thủ thư quầy không ghi được event tài chính ngoài PAYMENT"
      },
      {
        "chk": "CHK-LMP-071",
        "ref": [
          "FR-LMP-017"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Báo cáo hư hỏng",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra báo cáo hư hỏng lưu mức độ, mô tả và trạng thái chờ xử lý"
      },
      {
        "chk": "CHK-LMP-072",
        "ref": [
          "FR-LMP-017",
          "BR-LMP-009"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Báo cáo hư hỏng",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra báo cáo chờ xử lý không tự đóng khi chưa có disposition"
      },
      {
        "chk": "CHK-LMP-073",
        "ref": [
          "FR-LMP-017",
          "BR-LMP-012",
          "E-LMP-011"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Báo cáo hư hỏng",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra tệp bằng chứng rủi ro không được lưu"
      },
      {
        "chk": "CHK-LMP-074",
        "ref": [
          "FR-LMP-017",
          "BR-LMP-013",
          "E-LMP-013"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Báo cáo hư hỏng",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra audit thất bại thì báo cáo hư hỏng bị rollback"
      },
      {
        "chk": "CHK-LMP-075",
        "ref": [
          "FR-LMP-017",
          "BR-LMP-009"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Báo cáo hư hỏng",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra chọn bác bỏ thì báo cáo đóng và có audit"
      },
      {
        "chk": "CHK-LMP-076",
        "ref": [
          "FR-LMP-017",
          "BR-LMP-009"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Báo cáo hư hỏng",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra chọn sửa thì báo cáo đóng và có audit"
      },
      {
        "chk": "CHK-LMP-077",
        "ref": [
          "FR-LMP-017",
          "BR-LMP-009"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Báo cáo hư hỏng",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra chọn thanh lý thì báo cáo đóng và có audit"
      },
      {
        "chk": "CHK-LMP-078",
        "ref": [
          "FR-LMP-017",
          "E-LMP-002"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Báo cáo hư hỏng",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra Thủ thư quầy không đóng được báo cáo bằng disposition"
      },
      {
        "chk": "CHK-LMP-079",
        "ref": [
          "FR-LMP-017",
          "E-LMP-015"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Báo cáo hư hỏng",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra disposition không hợp lệ với trạng thái hiện tại không đổi báo cáo"
      },
      {
        "chk": "CHK-LMP-080",
        "ref": [
          "FR-LMP-017",
          "E-LMP-005"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Báo cáo hư hỏng",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra disposition đến sau không ghi đè disposition đã commit"
      },
      {
        "chk": "CHK-LMP-081",
        "ref": [
          "FR-LMP-017",
          "BR-LMP-013",
          "E-LMP-013"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Báo cáo hư hỏng",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra audit thất bại thì disposition không được giữ"
      },
      {
        "chk": "CHK-LMP-082",
        "ref": [
          "FR-LMP-018",
          "FR-LMP-014",
          "BR-LMP-007"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Mất và tìm lại",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra ghi nhận mất tạo đúng một ASSESSMENT bồi thường"
      },
      {
        "chk": "CHK-LMP-083",
        "ref": [
          "FR-LMP-018"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Mất và tìm lại",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra ghi nhận mất đánh dấu bản sao đã mất"
      },
      {
        "chk": "CHK-LMP-084",
        "ref": [
          "FR-LMP-018",
          "E-LMP-015"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Mất và tìm lại",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra ghi nhận mất lặp không tạo ASSESSMENT thứ hai"
      },
      {
        "chk": "CHK-LMP-085",
        "ref": [
          "FR-LMP-018",
          "BR-LMP-010"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Mất và tìm lại",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra tìm lại sách không xóa nghĩa vụ bồi thường đã ghi"
      },
      {
        "chk": "CHK-LMP-086",
        "ref": [
          "FR-LMP-018",
          "BR-LMP-013",
          "E-LMP-013"
        ],
        "category": "Hư hỏng và mất sách",
        "subcategory": "Mất và tìm lại",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra audit thất bại thì ghi nhận mất bị rollback"
      },
      {
        "chk": "CHK-LMP-087",
        "ref": [
          "FR-LMP-019",
          "BR-LMP-016"
        ],
        "category": "Thông báo",
        "subcategory": "Outbox không làm mất giao dịch",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra giao dịch nghiệp vụ vẫn commit khi kênh thông báo chưa gửi xong"
      },
      {
        "chk": "CHK-LMP-088",
        "ref": [
          "FR-LMP-019",
          "BR-LMP-016"
        ],
        "category": "Thông báo",
        "subcategory": "Outbox không làm mất giao dịch",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra giao dịch đã commit có sự kiện thông báo trong outbox"
      },
      {
        "chk": "CHK-LMP-089",
        "ref": [
          "FR-LMP-019",
          "E-LMP-012",
          "E-LMP-018"
        ],
        "category": "Thông báo",
        "subcategory": "Outbox không làm mất giao dịch",
        "priority": 1,
        "auto": "Yes",
        "text": "Kiểm tra kênh gửi lỗi thì trạng thái gửi được ghi là lỗi"
      },
      {
        "chk": "CHK-LMP-090",
        "ref": [
          "FR-LMP-019",
          "BR-LMP-016",
          "E-LMP-018"
        ],
        "category": "Thông báo",
        "subcategory": "Outbox không làm mất giao dịch",
        "priority": 1,
        "auto": "No",
        "text": "Kiểm tra lỗi gửi thông báo không xóa giao dịch nghiệp vụ đã commit"
      },
      {
        "chk": "CHK-LMP-091",
        "ref": [
          "NFR-LMP-008"
        ],
        "category": "Chất lượng nền",
        "subcategory": "Trạng thái đang xử lý",
        "priority": 2,
        "auto": "Yes",
        "text": "Kiểm tra màn quầy đang xử lý giao dịch thì hiện trạng thái đang xử lý trước khi có kết quả"
      },
      {
        "chk": "CHK-LMP-092",
        "ref": [
          "NFR-LMP-008",
          "NFR-LMP-009"
        ],
        "category": "Chất lượng nền",
        "subcategory": "Bàn phím và nhãn",
        "priority": 2,
        "auto": "Yes",
        "text": "Kiểm tra điều khiển chính trên màn quầy có tên đọc được"
      },
      {
        "chk": "CHK-LMP-093",
        "ref": [
          "NFR-LMP-009"
        ],
        "category": "Chất lượng nền",
        "subcategory": "Bàn phím và nhãn",
        "priority": 2,
        "auto": "Yes",
        "text": "Kiểm tra focus trên điều khiển chính của màn quầy nhìn thấy được khi dùng bàn phím"
      },
      {
        "chk": "CHK-LMP-094",
        "ref": [
          "NFR-LMP-012"
        ],
        "category": "Chất lượng nền",
        "subcategory": "Khung Mobile 375",
        "priority": 2,
        "auto": "Yes",
        "text": "Kiểm tra khung Mobile 375 vẫn hiện hành động chính của màn quầy"
      },
      {
        "chk": "CHK-LMP-095",
        "ref": [
          "FR-LMP-008"
        ],
        "category": "Chất lượng nền",
        "subcategory": "Gián đoạn thao tác",
        "priority": 2,
        "auto": "Yes",
        "text": "Kiểm tra tải lại trang khi phiếu mượn chưa xác nhận không tạo khoản mượn"
      },
      {
        "chk": "CHK-LMP-096",
        "ref": [
          "FR-LMP-008",
          "NFR-LMP-003"
        ],
        "category": "Chất lượng nền",
        "subcategory": "Gián đoạn thao tác",
        "priority": 2,
        "auto": "No",
        "text": "Kiểm tra mất mạng lúc xác nhận phiếu mượn không để phiếu ghi một phần"
      },
      {
        "chk": "CHK-LMP-097",
        "ref": [
          "FR-LMP-006",
          "E-LMP-017"
        ],
        "category": "Chất lượng nền",
        "subcategory": "Gián đoạn thao tác",
        "priority": 2,
        "auto": "Yes",
        "text": "Kiểm tra quay lại từ màn kết quả sau khi phiên hết hạn không mở lại giao dịch dở"
      }
    ]
  }
];
