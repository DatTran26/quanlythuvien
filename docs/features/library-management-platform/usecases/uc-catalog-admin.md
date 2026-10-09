---
type: usecase
feature: library-management-platform
status: draft
updated: 2026-10-05
links:
  - docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md
  - docs/features/library-management-platform/srs/library-management-platform-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
  - docs/_product/decision-register.md
---

# Use Case: Quản trị danh mục và bản sao (uc-catalog-admin)

> Scope: library-management-platform · Level: sea
> Screens: `catalog-search`, `bibliographic-detail`, `bibliographic-form`, `copy-inventory`, `copy-form` · Release: R0 (FR-LMP-001, FR-LMP-002), R1A (FR-LMP-003)
> **Lưu ý nhãn:** Copy state machine (COPY-T00 ∅→AVAILABLE) và thuộc tính `is_loanable` là **PROPOSAL** — DEC-D3-01, DEC-D3-09 chờ domain approver.

## Primary Actor

Thủ thư / Quản trị viên (actor đã xác thực qua `uc-access-control`).

> **Nhãn:** nguồn chỉ cấp quyền CRUD đầu sách/bản sao/danh mục cho `Thủ thư` nguồn = **Quản trị viên** theo mapping spec §2 (ma trận quyền nguồn §2 — FACT). Mở rộng cho Thủ thư quầy thao tác catalog là **PROPOSAL (lệch ma trận quyền nguồn §2)** — lý do: giảm nút thắt vận hành khi kho nhỏ; chờ domain approver chốt.

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Tra cứu được đầu sách và số bản sao khả dụng chính xác (FR-LMP-003) |
| Thủ thư trưởng | Dữ liệu kho tin cậy, truy vết được; mọi thay đổi catalog có audit (FR-LMP-020) |
| Thủ thư (vận hành quầy) | Mã QR/barcode duy nhất, quét định vị đúng một bản sao (BR-LMP-011) |

## Trigger

Thủ thư/Quản trị viên cần tạo, tra cứu, cập nhật đầu sách (BibliographicRecord) hoặc đăng ký/điều chỉnh bản sao vật lý (Copy).

## Preconditions

- Actor đã xác thực và có quyền quản trị catalog (include `uc-access-control`; Người đọc chỉ có quyền tra cứu FR-LMP-003). Quyền CRUD catalog theo nguồn chỉ thuộc Quản trị viên; Thủ thư quầy được phép theo PROPOSAL ở Primary Actor.
- `PolicyConfig`/dữ liệu nền (thể loại, vị trí) đã được cấu hình — nếu có (PROPOSAL).
- Copy được đăng ký phải gắn với một BibliographicRecord hợp lệ.

## Guarantees

- **Minimal Guarantee:** Dữ liệu nhập không hợp lệ không được commit; bản ghi lỗi giữ nguyên dữ liệu nhập để sửa; không có action nào vượt quyền được thực thi (audit denial).
- **Success Guarantee:** BibliographicRecord/Copy được lưu nhất quán, mã định danh/QR duy nhất; Copy khởi tạo ở `AVAILABLE` (COPY-T00 — PROPOSAL); audit ghi cùng transaction (BR-LMP-013); số khả dụng tra cứu được là giá trị tính toán từ trạng thái (CP-AVL-01).

## Main Success Scenario

1. Actor mở `catalog-search`, tìm đầu sách theo tiêu đề/tác giả/ISBN (hiệu năng mục tiêu ≤2s @50.000 bản sao — NFR-LMP-002, ngưỡng PROPOSAL).
2. Actor mở `bibliographic-form`, tạo mới hoặc cập nhật BibliographicRecord: tiêu đề, tác giả, thể loại, nhà xuất bản, năm, ISBN, mô tả khi có (FR-LMP-001).
3. Hệ thống validate trường bắt buộc/định dạng và kiểm tra unique business key; lưu bản ghi + audit trong cùng transaction.
4. Từ `bibliographic-detail`/`copy-inventory`, actor mở `copy-form` đăng ký Copy: mã barcode/QR duy nhất, vị trí, tình trạng ban đầu, cờ `is_loanable` (PROPOSAL — DEC-D3-09: thuộc tính trên Title mặc định, override được trên Copy) (FR-LMP-002).
5. Hệ thống tạo Copy với trạng thái khởi tạo `AVAILABLE` (COPY-T00 — PROPOSAL DEC-D3-01) + audit; số khả dụng được tính lại.
6. Actor/Người đọc tra cứu khả dụng trên `bibliographic-detail`: hiển thị số bản sao theo nhóm — khả dụng (`AVAILABLE` + `is_loanable`), đang giữ (`ON_HOLD`), đang mượn (`ON_LOAN`), không khả dụng (`PENDING_REVIEW`/`IN_REPAIR`/`LOST`/`DISPOSED`) (FR-LMP-003, CP-AVL-01/04).

## Extensions

**3a. Thiếu trường bắt buộc hoặc sai định dạng (ISBN, năm, thể loại không hợp lệ):**
- 3a1. Hệ thống từ chối, hiển thị inline error trên `bibliographic-form` (E-LMP-001), giữ nguyên dữ liệu đã nhập.
- 3a2. Recovery: actor sửa và submit lại; không có partial write.

**3b. Trùng unique business key (ISBN/định danh đầu sách theo cấu hình):**
- 3b1. Hệ thống báo duplicate (E-LMP-003): cho phép nhập lại mã khác hoặc mở bản ghi hiện có để xem/cập nhật.
- 3b2. Recovery: không tạo bản ghi thứ hai; nếu là cập nhật thì merge qua luồng edit bản ghi gốc.

**4a. Actor thiếu quyền quản trị catalog (ví dụ Người đọc tự phục vụ gọi `bibliographic-form`, Thủ thư thiếu quyền action):**
- 4a1. Hệ thống từ chối bằng access denied screen/banner (E-LMP-002) và ghi audit denial.
- 4a2. Recovery: quay về `catalog-search`/`bibliographic-detail` ở chế độ chỉ đọc mà actor có quyền.

**5a. Mã Copy/QR trùng, trỏ Title không tồn tại, hoặc mã không đọc được:**
- 5a1. Hệ thống báo not found/duplicate (E-LMP-003) trên `copy-form`; QR phải duy nhất và trỏ đúng một bản sao (baseline §7.1 validation).
- 5a2. Recovery: nhập/sinh mã mới, hoặc mở Copy hiện có sở hữu mã đó; không ghi bản sao trùng locator.

**5b. Action không hợp lệ từ trạng thái hiện tại của Copy:**
- 5b1. Ví dụ: đổi trạng thái Copy thủ công (transitions chỉ đi qua use case nghiệp vụ — quyền sở hữu trạng thái §1.1 lifecycle-inventory), thao tác trên Copy `DISPOSED` (terminal — invalid transitions §2.5), xóa Copy đang `ON_LOAN`/`ON_HOLD`, hoặc xóa đầu sách còn Copy/Loan/Reservation liên quan (PROPOSAL — ràng buộc toàn vẹn).
- 5b2. Hệ thống disable action + giải thích lý do (E-LMP-015). Recovery: reload trạng thái, chỉ hiển thị action hợp lệ; nếu cần đổi trạng thái thì đi qua UC nghiệp vụ tương ứng (`uc-return-renewal`, `uc-damage-lost-found`).

**5c. Xóa/vô hiệu entity đã có lịch sử (FACT — nguồn BR-12):**
- 5c1. BibliographicRecord/Copy/danh mục đã có lịch sử nghiệp vụ (Loan, Reservation, DamageReport liên quan) **không được xóa cứng** — chỉ được **vô hiệu hóa** (deactivate): FACT theo BR-12 nguồn ("xóa mềm: ... đã có lịch sử chỉ được vô hiệu hóa"), sẽ hạ nguồn thành BR-LMP-017 trong spec.
- 5c2. Cơ chế: actor chọn "Vô hiệu hóa" thay vì "Xóa" → hệ thống đặt cờ `is_active=false`/trạng thái không khả dụng + audit, bản ghi giữ nguyên cho truy vết; entity vô hiệu không xuất hiện trong tra cứu/selection mới nhưng lịch sử cũ vẫn đọc được. Xóa cứng chỉ cho phép khi bản ghi chưa phát sinh lịch sử; nếu không → disable + giải thích (E-LMP-015).

**5d. Bản ghi bị actor khác sửa sau khi load (concurrent edit):**
- 5d1. Actor mở form edit trên phiên bản v(N), trong lúc đó actor khác đã commit v(N+1) → submit nhận conflict (CAS trên version, BR-13/E-LMP-005): hiển thị trạng thái/diff mới nhất, **không ghi đè im lặng** thay đổi của người khác.
- 5d2. Recovery: actor xem diff giữa bản nhập dở và v(N+1), chọn nhập lại trên trạng thái mới hoặc hủy; hệ thống không merge tự động (PROPOSAL — cơ chế hiển thị diff).

## Related Requirements

- FR: FR-LMP-001 (danh mục), FR-LMP-002 (bản sao), FR-LMP-003 (tra cứu khả dụng); audit FR-LMP-020.
- NFR: NFR-LMP-002 (performance tra cứu), NFR-LMP-006 (audit fail-closed).
- BR: BR-LMP-013 (audit cùng transaction), BR-LMP-011 (QR là locator); nguyên tắc "khả dụng = tính toán" (CP-AVL-01, gốc BR-11).
- Errors covered: E-LMP-001, E-LMP-002, E-LMP-003, E-LMP-005, E-LMP-015.
- Decisions liên quan: DEC-D3-01 (Copy state machine — PROPOSAL), DEC-D3-09 (`is_loanable`), OQ-LMP-004 (sơ đồ gốc mất).
- UC liên quan: `uc-access-control` (include), `uc-checkout`/`uc-return-renewal` (consume trạng thái Copy), `uc-admin-import` (nguồn tạo hàng loạt).
- **Nhãn tổng:** FACT = CRUD catalog chỉ Quản trị viên theo ma trận nguồn §2 (theo mapping spec §2), BR-11 "khả dụng = tính từ trạng thái", BR-12 xóa mềm/vô hiệu hóa entity có lịch sử (ext 5c → BR-LMP-017), BR-13 khóa lạc quan/concurrency (ext 5d), QR locator. PROPOSAL = mở rộng quyền catalog cho Thủ thư quầy (Primary Actor — lệch ma trận nguồn), Copy state machine (DEC-D3-01), `is_loanable` (DEC-D3-09), cơ chế hiển thị diff khi concurrent edit. Open = giá trị policy/tham số cấu hình (OQ-LMP-010/OQ-04).

<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền ai4ba.com</sub>
