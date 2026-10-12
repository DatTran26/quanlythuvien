---
type: srs
feature: damage-lifecycle
status: draft
updated: 2026-10-12
links:
  - docs/features/damage-lifecycle/brainstorms/damage-lifecycle-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# damage-lifecycle — Software Requirements Specification

## 1. Scope

Nhân viên báo hư hỏng kèm 1–5 ảnh, bản sao chuyển Chờ duyệt ngay; Thủ thư quyết định Bác bỏ, Sửa hoặc Thanh lý; sửa xong đưa bản sao về kho.

**Release:** R1A

**Ngoài phạm vi:** Đặt trước bị ảnh hưởng bởi hư hỏng (từ R2).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Nhân viên | người | Vận hành quầy | Có |
| Thủ thư | người | Quản trị, duyệt ngoại lệ | Có |
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-damage-lifecycle-001 | Báo cáo hư hỏng | Tạo báo cáo hư hỏng gắn bản sao/phiếu mượn, mức độ, mô tả, bằng chứng ảnh 1–5 và trạng thái xử lý; disposition tối thiểu Bác bỏ/Sửa/Thanh lý. | P0 | R1A | demo/test | Spec cũ (xem id-crosswalk-lmp) |
| FR-damage-lifecycle-002 | Quản lý ảnh bằng chứng | Upload ảnh cho báo cáo hư hỏng/mất qua trust boundary: kiểm tra loại, kích thước, quét nội dung, không tin metadata gốc. | P1 | R1A | test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

| ID | Rule | Trigger | Implements FR | Source |
|---|---|---|---|---|
| BR-damage-lifecycle-001 | DamageReport chỉ đóng khi có quyết định repair/replace/no-charge/fine-linked và audit đầy đủ. | Resolve report | FR-damage-lifecycle-001 | Spec cũ (xem id-crosswalk-lmp) |
| BR-damage-lifecycle-002 | Upload bằng chứng phải qua trust boundary: MIME/sniffing, giới hạn size, quét nội dung, tên file lưu an toàn. | Upload attachment | FR-damage-lifecycle-002 | Spec cũ (xem id-crosswalk-lmp) |

Rule dùng chung áp dụng: BR-core-002, BR-core-003, BR-core-005 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

| Error ID | Title | Trigger | Severity | Related FR | Screen state | Recovery |
|---|---|---|---|---|---|---|
| E-damage-lifecycle-001 | Upload rejected | File sai loại/size/nội dung | major | FR-damage-lifecycle-002 | Attachment error | Cho chọn file khác, không lưu file rủi ro |

Lỗi dùng chung áp dụng: E-core-001, E-core-002, E-core-003, E-core-004, E-core-007, E-core-008 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-damage-lifecycle-01 | Không bản sao nào kẹt trạng thái tạm | Báo cáo tuổi trạng thái | 0 bản sao kẹt Chờ duyệt không có owner |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`DamageReport`, `Copy`, `Fine`, `FinancialEvent`, `AuditEvent`.

## 9. Flows (tóm tắt — chi tiết ở `srs/damage-lifecycle-flows.md`)

Báo cáo → Chờ duyệt → quyết định (Bác bỏ / Sửa / Thanh lý) → sửa xong.

## 10. Screens (tóm tắt — chi tiết ở `srs/damage-lifecycle-userflow.md` và `html-wireframe/`)

`damage-report-form`, `damage-report-detail`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Disposition tối thiểu Bác bỏ/Sửa/Thanh lý có ở R1A | DEC-P2-03 |
| 1–5 ảnh, mỗi ảnh ≤ 500 KB sau nén | SRC-NFR05 (nguồn) |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Hàng đợi thông báo | `notification-core` | Thông báo cho người đọc |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |
| Duyệt DEC-D3-06/07 | Domain approver | Thanh lý trực tiếp, bản giữ bị hỏng |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Bản sao chặn lưu thông ngay khi báo (OQ-11 nguồn) | FR-damage-lifecycle-001 |
| Thanh lý cần xác thực lại | `access-control` |

## 12. Open Questions

- [ ] OQ-damage-lifecycle-001 — Ảnh lưu theo báo cáo hay quản lý như tệp đính kèm riêng, lưu giữ bao lâu? Owner: domain/tech.
- [ ] OQ-damage-lifecycle-002 — Mức phạt hư hỏng chính thức (mặc định nguồn 0%/30%/100%)? Owner: Thủ thư trưởng.
