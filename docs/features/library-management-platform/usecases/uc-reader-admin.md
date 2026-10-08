---
type: usecase
feature: library-management-platform
status: draft
updated: 2026-10-05
links:
  - docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md
  - docs/features/library-management-platform/srs/library-management-platform-spec.md
  - docs/features/library-management-platform/domain/lifecycle-inventory.md
  - docs/_product/decision-register.md
---

# Use Case: Quản trị hồ sơ người đọc (uc-reader-admin)

> Scope: library-management-platform · Level: sea
> Screens: `reader-list`, `reader-form`, `reader-detail` · Release: R0 (FR-LMP-004), R1B (FR-LMP-005 khóa/mở)
> **Lưu ý Open:** cách hồ sơ người đọc liên kết tài khoản đăng nhập phụ thuộc mô hình identity — **OQ-LMP-007**; policy retention/deletion PII — OQ-LMP-006 (non-waivable trước GATE-GNG).

## Primary Actor

Thủ thư / Quản trị viên. Hành động khóa/mở khóa tạm người đọc được phép cho **cả hai** vai trò — FACT theo ma trận quyền nguồn §2 ("Cập nhật thông tin người đọc, khóa tạm" ✓ cả `Nhân viên` và `Thủ thư` nguồn, tương ứng Thủ thư và Quản trị viên theo mapping spec §2; FR-S10/FR-LMP-005). Tạo/xóa tài khoản người đọc (CRUD) chỉ thuộc Quản trị viên — FACT theo ma trận nguồn ("CRUD tài khoản người đọc" chỉ `Thủ thư` nguồn).

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Hồ sơ chính xác; PII chỉ ai có quyền mới xem/sửa (NFR-LMP-005); trạng thái khóa có lý do rõ ràng |
| Bảo mật/pháp chế | Ma trận quyền field PII (BR-LMP-015); audit mọi thay đổi hồ sơ và khóa/mở |
| Thủ thư (vận hành quầy) | Tra cứu nhanh hồ sơ + tình trạng mượn/công nợ khi phục vụ tại quầy |

## Trigger

Thủ thư/Quản trị viên cần đăng ký, tra cứu, cập nhật hồ sơ người đọc; hoặc Thủ thư/Quản trị viên cần tạm ngưng/khôi phục quyền mượn của một người đọc.

## Preconditions

- Actor đã xác thực và có quyền tương ứng (include `uc-access-control`): xem/sửa thông tin và khóa/mở khóa tạm theo vai trò Thủ thư/Quản trị viên (FACT — ma trận nguồn); tạo/xóa tài khoản người đọc yêu cầu vai trò Quản trị viên (FACT — ma trận nguồn).
- Nếu hồ sơ gắn tài khoản đăng nhập: mô hình identity đã khả dụng theo quyết định OQ-LMP-007 (hiện Open — PROPOSAL: tài khoản local, kích hoạt khi phát hành thẻ QR).

## Guarantees

- **Minimal Guarantee:** Không ghi hồ sơ thiếu/trùng định danh; khóa/mở không có lý do bị từ chối; PII không lộ ra ngoài quyền; mọi denial có audit.
- **Success Guarantee:** Hồ sơ Reader lưu nhất quán với trạng thái, liên hệ tối thiểu và hạn thẻ; khóa/mở có lý do bắt buộc + audit cùng transaction (FR-LMP-005); trạng thái khóa có hiệu lực ngay với rule đủ điều kiện mượn (BR-LMP-003).

## Main Success Scenario

1. Actor mở `reader-list`, tìm/lọc người đọc; PII hiển thị theo quyền field × purpose (BR-LMP-015, NFR-LMP-005 — mask chi tiết xem `uc-access-control`, E-LMP-016).
2. Actor mở `reader-form`, tạo hoặc cập nhật hồ sơ: định danh/mã độc giả + thẻ QR, thông tin liên hệ tối thiểu, trạng thái tài khoản, hạn thẻ nếu có (FR-LMP-004); liên kết tài khoản đăng nhập theo mô hình identity (Open — OQ-LMP-007).
3. Hệ thống validate trường bắt buộc/định dạng, kiểm tra unique business key (mã độc giả, QR thẻ); lưu + audit trong cùng transaction.
4. Actor mở `reader-detail`: xem hồ sơ + các Loan đang mở/lịch sử mượn (R), Reservation đang chờ (R), công nợ Fine/FinancialEvent (R) — theo CRUD matrix của UC này.
5. (R1B) Thủ thư/Quản trị viên chọn khóa/mở người đọc → nhập lý do bắt buộc → hệ thống đổi trạng thái `active↔blocked` + audit cùng transaction (FR-LMP-005); từ thời điểm đó BR-LMP-003 chặn mượn/gia hạn cho reader này.

## Extensions

**3a. Thiếu trường bắt buộc hoặc sai định dạng (liên hệ, hạn thẻ):**
- 3a1. Hệ thống từ chối, inline error trên `reader-form` (E-LMP-001), giữ dữ liệu đã nhập.
- 3a2. Recovery: sửa và submit lại; không có partial write.

**3b. Trùng mã độc giả/QR thẻ, hoặc mã tra cứu không tồn tại:**
- 3b1. Hệ thống báo duplicate/not found (E-LMP-003): cho nhập lại mã khác hoặc mở hồ sơ hiện có sở hữu mã đó.
- 3b2. Recovery: không tạo hồ sơ thứ hai trùng định danh.

**5a. Actor ngoài vai trò Thủ thư/Quản trị viên gọi khóa/mở, hoặc thiếu quyền action trên hồ sơ:**
- 5a1. Hệ thống từ chối bằng access denied screen/banner (E-LMP-002) + audit denial. Lưu ý: quyền khóa/mở thuộc cả Thủ thư và Quản trị viên (FACT — ma trận nguồn §2); chỉ action tạo/xóa tài khoản mới siết về Quản trị viên.
- 5a2. Recovery: quay về `reader-list`/`reader-detail` với các action actor có quyền; escalate cho Quản trị viên nếu nghiệp vụ cần action ngoài quyền actor.

**5b. Khóa/mở ở trạng thái không hợp lệ (khóa tài khoản đã `blocked`, mở tài khoản đang `active`, hoặc thiếu lý do bắt buộc):**
- 5b1. Hệ thống disable/từ chối action kèm giải thích (E-LMP-015); thiếu lý do xử lý như validation E-LMP-001.
- 5b2. Recovery: reload trạng thái mới nhất và chỉ hiển thị action hợp lệ; nhập lý do rồi submit lại.

**5c. Reader đang có Loan mở / Reservation đang chờ khi bị khóa:**
- 5c1. Khóa tài khoản **không** đóng hay hủy các nghĩa vụ hiện có: Loan vẫn chạy tới trả/mất, Reservation/Fine giữ nguyên (PROPOSAL — khớp quyền sở hữu trạng thái; block chỉ chặn giao dịch mới qua BR-LMP-003).
- 5c2. Recovery: hệ thống hiển thị cảnh báo nghĩa vụ đang mở trước khi xác nhận khóa; actor xác nhận hoặc hủy.

**5d. Xóa/vô hiệu hóa tài khoản người đọc (FACT — nguồn BR-12, FR-L05):**
- 5d1. Quản trị viên chọn xóa/vô hiệu một tài khoản đã có lịch sử (Loan/Reservation/Fine/DamageReport liên quan) → hệ thống **không xóa cứng**: chỉ **vô hiệu hóa** (deactivate/soft-delete) — FACT theo BR-12 nguồn ("người đọc, nhân viên, đầu sách, bản sao đã có lịch sử chỉ được vô hiệu hóa"), sẽ hạ nguồn thành BR-LMP-017 trong spec; FR-L05 nguồn: "xóa mềm; chặn xóa khi còn phiếu mở hoặc nợ phạt".
- 5d2. Cơ chế: đặt trạng thái `deleted`/vô hiệu + audit; tài khoản vô hiệu không đăng nhập/mượn được nhưng hồ sơ và lịch sử vẫn đọc được cho truy vết. Chặn khi còn Loan mở hoặc nợ phạt chưa thanh toán → hiển thị nghĩa vụ tồn đọng (E-LMP-015); xóa cứng chỉ cho hồ sơ chưa phát sinh lịch sử.

**5e. Hồ sơ bị actor khác sửa sau khi load (concurrent edit):**
- 5e1. Actor mở `reader-form` trên phiên bản v(N); actor khác đã commit v(N+1) → submit nhận conflict (CAS trên version, BR-13/E-LMP-005): hiển thị trạng thái/diff mới nhất, **không ghi đè im lặng** — đặc biệt quan trọng với thao tác khóa/mở và đổi trạng thái (nhân đôi khóa/mở ghi audit sai ngữ nghĩa).
- 5e2. Recovery: actor xem diff giữa bản nhập dở và v(N+1), chọn nhập lại trên trạng thái mới hoặc hủy; hệ thống không merge tự động (PROPOSAL — cơ chế hiển thị diff).

## Related Requirements

- FR: FR-LMP-004 (quản lý người đọc), FR-LMP-005 (khóa/mở — P1/R1B); audit FR-LMP-020; liên quan FR-LMP-024 (cổng tự phục vụ — R2, phụ thuộc identity).
- NFR: NFR-LMP-004/005 (quyền field PII, retention — OQ-LMP-006), NFR-LMP-006 (audit fail-closed).
- BR: BR-LMP-003 (eligibility — block có hiệu lực ở checkout/renewal), BR-LMP-013, BR-LMP-015.
- Errors covered: E-LMP-001, E-LMP-002, E-LMP-003, E-LMP-005, E-LMP-015.
- Open: **OQ-LMP-007** (identity model liên kết hồ sơ), OQ-LMP-006 (retention/deletion PII).
- UC liên quan: `uc-access-control` (include + masking E-LMP-016), `uc-checkout`/`uc-return-renewal` (đọc trạng thái eligibility), `uc-admin-import` (tạo hàng loạt).
- **Nhãn tổng:** FACT = quyền khóa/mở khóa tạm thuộc cả Thủ thư và Quản trị viên (ma trận nguồn §2 — theo mapping spec §2), CRUD tài khoản người đọc chỉ Quản trị viên, BR-12 xóa mềm/vô hiệu hóa + chặn xóa khi còn nghĩa vụ (ext 5d → BR-LMP-017), BR-13 concurrency (ext 5e), lý do bắt buộc khi khóa/mở + audit. PROPOSAL = liên kết hồ sơ–tài khoản theo identity model, cảnh báo nghĩa vụ mở trước khi khóa (ext 5c), cơ chế hiển thị diff khi concurrent edit. Open = OQ-LMP-007 (identity), OQ-LMP-006 (retention/deletion PII — non-waivable trước GATE-GNG).

<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền ai4ba.com</sub>
