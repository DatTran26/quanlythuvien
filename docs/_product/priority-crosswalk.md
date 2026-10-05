---
type: priority-crosswalk
status: draft
updated: 2026-10-05
links:
  - docs/he_thong_quan_ly_thu_vien.md
  - docs/features/library-management-platform/brainstorms/product-roadmap-baseline.md
  - plans/reports/ba-audit-261005-0018-library-management-roadmap.md
  - docs/_product/prd.md
  - docs/_product/roadmap.md
  - docs/_product/decision-register.md
---

# Priority Crosswalk — Ánh xạ ưu tiên nguồn sang baseline

> `PROPOSAL` toàn bộ cho tới khi L1-approved cùng roadmap. Nguyên tắc: **giữ nguyên priority nguồn để truy vết**; mọi gate và release planning dùng **normalized priority** (P0 = bắt buộc trước pilot, P1 = sau khi MVP ổn định, P2 = candidate).

## 1. Hai hệ ưu tiên nguồn

| Nguồn | Thang | Nghĩa |
|---|---|---|
| `docs/he_thong_quan_ly_thu_vien.md` | P1 / P2 / P3 | P1 bắt buộc MVP, P2 nên có, P3 nếu còn thời gian |
| Brainstorm baseline | P0 / P1 / P2 | P0 must-have trước pilot, P1 should-have sau MVP, P2 candidate |

**Quy tắc mặc định (PROPOSAL):** nguồn `P1 → normalized P0`, nguồn `P2 → normalized P1`, nguồn `P3 → normalized P2`, **trừ khi** bảng §3 hoặc §4 ghi điều chỉnh có lý do. Không đổi ngầm — mọi ngoại lệ là một decision trong `decision-register.md`.

## 2. Sáu mâu thuẫn audit — resolution

Mỗi dòng là một PROPOSAL gắn decision ID; chi tiết owner/approver/due gate trong `decision-register.md`.

| # | Chủ đề | Mâu thuẫn nguồn | Resolution (PROPOSAL) | Decision |
|---|---|---|---|---|
| 1 | Thông báo | Mục 8 nguồn: "trong ứng dụng" mặc định; OQ-07: "in-app + email"; FR-C04 chỉ P2 | Kênh baseline = in-app + email cho sự kiện quan trọng. Thông báo tối thiểu (phiếu mượn tạo, sắp/quá hạn, phạt, hư hỏng chờ duyệt) → **P0/R1A**; trung tâm thông báo đầy đủ (FR-C04) → P1/R1B. SMS/push/Zalo → P2/R3. | DEC-P2-01 |
| 2 | Quá hạn | RP-04 là P1 nhưng job chuyển OVERDUE nằm ở Giai đoạn 2 | Job quá hạn + tính phạt tạm tính + RP-04 → **P0/R1A**; BR-03 chặn mượn chỉ bật sau khi job+ledger live (internal ordering). | DEC-P2-02 |
| 3 | Hư hỏng | Báo cáo hư hỏng P1 nhưng duyệt/disposition P2 → bản sao kẹt Chờ duyệt | Disposition tối thiểu (Bác bỏ / Sửa / Thanh lý, FR-L08) → **P0/R1A**, cùng release với tạo báo cáo; quy trình duyệt nâng cao → P1. | DEC-P2-03 |
| 4 | Fine | Trả sách P1 đã tính phạt nhưng thu/xử lý phạt ở P2 | Fine ledger tự động + **ghi nhận thu tiền mặt tối thiểu** → **P0/R1A** (để BR-03 và công nợ không kẹt); biên nhận in/xuất, miễn/điều chỉnh theo thẩm quyền → P1/R1B (cần financial-control approval). | DEC-P2-04 |
| 5 | Reservation | Luồng trả P1 phân bổ hàng chờ, nhưng module Reservation là P2 | R1A: điểm quyết định D5 trong trả **không phân bổ** — bản sao về Sẵn sàng/Chờ duyệt (contract ghi rõ trong SRS). Reservation trọn vòng (hàng chờ FIFO, giữ 48h, hết hạn) → **P1/R2**, release owner duy nhất. Không có release nào khác chứa reservation. | DEC-P2-05 |
| 6 | Audit | NFR-04 yêu cầu audit từ ngày đầu nhưng viewer FR-L10 ở P2 | Audit **capture** → **P0/R0** (trước giao dịch dữ liệu thật); audit **viewer** FR-L10 → P1/R1B. | DEC-P2-06 |

## 3. Crosswalk chi tiết theo FR/RP/capability nguồn

| ID nguồn | Nội dung | Source priority | Normalized | Release | Điều chỉnh / ghi chú |
|---|---|---|---|---|---|
| FR-C01 | Đăng nhập/đăng xuất, RBAC | P1 | P0 | R0 | — |
| FR-C02 | Quên/đổi mật khẩu | P1 | P0 | R0 | — |
| FR-C03 | Hồ sơ cá nhân | P1 | P0 | R0 | — |
| FR-C04 | Thông báo trong ứng dụng (đầy đủ) | P2 | P1 | R1B | Tách phần tối thiểu sự kiện quan trọng sang P0 — DEC-P2-01 |
| FR-R01 | Đăng ký tài khoản (+ kích hoạt) | P1 | P0 | R0 | Phụ thuộc OQ-03 default `PROPOSAL` |
| FR-R02 | Tra cứu sách | P1 | P0 | R1A | — |
| FR-R03 | Thẻ thư viện QR | P1 | P0 | R1A | Hiển thị thẻ phụ thuộc kích hoạt (R0) |
| FR-R04 | Sách đang mượn | P1 | P0 | R1A | — |
| FR-R05 | Lịch sử mượn | P1 | P0 | R1A | — |
| FR-R06 | Gia hạn online | P2 | P1 | R1B | BR-04 kiểm tra hàng chờ rỗng tới R2 — DEC-P2-05 |
| FR-R07 | Đặt trước sách | P2 | P1 | R2 | DEC-P2-05 |
| FR-R08 | Hủy/theo dõi đặt trước | P2 | P1 | R2 | DEC-P2-05 |
| FR-R09 | Xem phạt/công nợ | P2 | P1 | R1B | Ledger đã P0/R1A; chỉ phần hiển thị người đọc ở R1B |
| FR-S01 | Quét QR sách | P1 | P0 | R1A | — |
| FR-S02 | Quét QR thẻ người đọc | P1 | P0 | R1A | — |
| FR-S03 | Tạo phiếu mượn | P1 | P0 | R1A | — |
| FR-S04 | Nhận trả sách | P1 | P0 | R1A | D5 không phân bổ trong R1A — DEC-P2-05 |
| FR-S05 | Báo cáo hư hỏng | P1 | P0 | R1A | Đi kèm disposition tối thiểu — DEC-P2-03 |
| FR-S06 | Gia hạn tại quầy | P2 | P1 | R1B | Như FR-R06 |
| FR-S07 | Ghi nhận mất sách | P2 | **P0-PROPOSAL** | R1A | Nâng: Loan phải có đường kết thúc LOST trong MVP — DEC-P2-07 |
| FR-S08 | Thu phạt | P2 | P0 (tối thiểu) / P1 (nâng cao) | R1A / R1B | Chia scope — DEC-P2-04 |
| FR-S09 | Danh sách quá hạn (nhân viên) | P2 | P1 | R1B | RP-04 (P0) đã phủ nhu cầu đối soát |
| FR-S10 | Quản lý người đọc giới hạn | P2 | P1 | R1B | CRUD đầy đủ của Thủ thư đã ở R0 (FR-L05) |
| FR-S11 | Điểm danh | P3 | P2 | R3 candidate | Phụ thuộc OQ-02 |
| FR-L01 | Kế thừa quyền Nhân viên | P1 | P0 | R0/R1A | Theo phạm vi từng FR-S |
| FR-L02 | CRUD đầu sách | P1 | P0 | R0 | — |
| FR-L03 | Nhập bản sao + in QR | P1 | P0 | R0 | — |
| FR-L04 | Danh mục | P1 | P0 | R0 | — |
| FR-L05 | CRUD tài khoản người đọc | P1 | P0 | R0 | — |
| FR-L06 | CRUD tài khoản nhân viên | P1 | P0 | R0 | — |
| FR-L07 | Cấu hình quy định | P1 | P0 | R0 | Giá trị BR chờ GATE-DEC (OQ-04) |
| FR-L08 | Duyệt hư hỏng, thanh lý | P2 | **P0** | R1A | Nâng theo DEC-P2-03 (disposition tối thiểu) |
| FR-L09 | Báo cáo & xuất file | P2 | P0/P1 | R1A/R2 | Theo từng RP bên dưới |
| FR-L10 | Nhật ký hoạt động (viewer) | P2 | P1 | R1B | Capture đã P0/R0 — DEC-P2-06 |
| RP-01 | Tổng quan tài khoản | P1 | P0 | R1A | — |
| RP-02 | Tình trạng kho sách | P1 | P0 | R1A | — |
| RP-03 | Mượn–trả theo thời gian | P2 | P1 | R2 | — |
| RP-04 | Quá hạn | P1 | P0 | R1A | DEC-P2-02 |
| RP-05 | Phạt | P2 | P1 | R2 | — |
| RP-06 | Sách được quan tâm | P2 | P1 | R2 | — |
| RP-07 | Hư hỏng & thanh lý | P2 | P1 | R2 | — |
| RP-08 | Hoạt động nhân viên | P3 | P2 | R3 candidate | Phụ thuộc điểm danh (OQ-02) |
| (mới) | Import Excel + đối soát | P1 ngầm (OQ-15) | P0 | R0 | Audit blocker #6: đưa vào readiness — DEC-P2-09 |
| (mới) | Backup/restore + job owner | NFR-07 | P0 | R0/R1B | — |
| (mới) | Audit capture | NFR-04 | P0 | R0 | DEC-P2-06 |
| (mới) | Thông báo tối thiểu sự kiện | mục 8 | P0 | R1A | DEC-P2-01 |
| OQ-08 | Thanh toán online | P3 (mục 12) | P2 | R3 candidate | — |
| OQ-09 | Nhiều chi nhánh | P3 | P2 | R3 candidate | — |
| OQ-13 | Offline | P3 | P2 | R3 candidate | — |

## 4. Ngoại lệ nâng/hạ so với quy tắc mặc định

| Item | Từ | Sang | Lý do | Decision |
|---|---|---|---|---|
| Job OVERDUE + phạt tạm tính | P2 (nguồn) | P0 | BR-03 và RP-04 không thể đúng nếu job chưa chạy | DEC-P2-02 |
| FR-L08 disposition tối thiểu | P2 | P0 | Tránh bản sao kẹt Chờ duyệt (audit blocker #3) | DEC-P2-03 |
| FR-S08 thu tiền mặt tối thiểu | P2 | P0 | Công nợ phải có đường thanh toán trong pilot | DEC-P2-04 |
| FR-S07 ghi nhận mất | P2 | P0-PROPOSAL | Loan cần đường kết thúc LOST ngay MVP | DEC-P2-07 |
| FR-C04 tách 2 phần | P2 | P0/P1 | Sự kiện quan trọng cần kênh từ ngày đầu | DEC-P2-01 |
| FR-L10 viewer | P2 | P1 (capture P0) | Capture trước, giao diện sau | DEC-P2-06 |
| FR-R07/R08 Reservation | P2 | P1 (R2) | Một release owner duy nhất; R1A không phân bổ | DEC-P2-05 |
| FR-S09, FR-S10 | P2 | P1 | Vận hành pilot được phủ bởi RP-04/FR-L05 | — (quy tắc mặc định) |
| FR-R06/S06 gia hạn | P2 | P1 | Quy tắc mặc định; lưu ý BR-04/queue rỗng | DEC-P2-05 |

## 5. Quy tắc dùng trong gate và tài liệu hạ nguồn

- SRS/UC/test dùng **normalized priority + release**; cột source priority được giữ trong crosswalk này để truy vết ngược.
- Bất kỳ thay đổi priority nào sau L1 approval phải đi qua change request và cập nhật cả file này lẫn decision register.
- Mục gắn `-PROPOSAL` (FR-S07) chỉ trở thành baseline khi DEC tương ứng được Approved.

<!-- Phase 2 deliverable — QuanLyThuVIen BA workflow -->
