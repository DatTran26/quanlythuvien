---
type: srs
feature: data-import
status: draft
updated: 2026-10-08
links:
  - docs/features/data-import/brainstorms/data-import-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# data-import — Software Requirements Specification

## 1. Scope

Nhập dữ liệu đầu sách và bản sao từ Excel: chạy thử, báo lỗi theo dòng, ghi cả lô một lần khi chạy thử đạt, đối soát với kiểm kê vật lý.

**Release:** R0

**Ngoài phạm vi:** Cấu trúc cột chính thức (chờ file đại diện).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Quản trị viên | người | Quản trị dữ liệu, cấu hình, tài khoản | Có |
| Thủ thư | người | Vận hành quầy | Có |
| Thủ thư trưởng | stakeholder | Duyệt quy định và go-live | Có như stakeholder |
| Hệ thống | hệ thống | Thực thi kiểm tra, ghi audit | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-data-import-001 | Import và đối soát | Nhập dữ liệu ban đầu qua file đại diện, validate staging, báo lỗi theo dòng, dry-run trước commit và reconciliation sau import. | P0 | R0 | test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

| ID | Category | Requirement | Priority | Release | Acceptance |
|---|---|---|---|---|---|
| NFR-data-import-001 | data quality | Import phải có dry-run, lỗi theo dòng và số liệu đối soát trước khi commit. | P0 | R0 | Import fixture test + reconciliation report; GATE-MIG |

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

| ID | Rule | Trigger | Implements FR | Source |
|---|---|---|---|---|
| BR-data-import-001 | Import commit chỉ sau dry-run pass hoặc override được phê duyệt; reconciliation phải đối chiếu số lượng, bản ghi lỗi và bản ghi bỏ qua. | Import run | FR-data-import-001 | Spec cũ (xem id-crosswalk-lmp) |

Rule dùng chung áp dụng: BR-core-003 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

| Error ID | Title | Trigger | Severity | Related FR | Screen state | Recovery |
|---|---|---|---|---|---|---|
| E-data-import-001 | Import invalid hoặc mismatch | File sai format/dòng lỗi/reconcile lệch | major | FR-data-import-001 | Import report error | Cho tải file sửa hoặc dry-run lại; không commit nếu chưa pass |

Lỗi dùng chung áp dụng: E-core-002, E-core-004, E-core-005, E-core-007, E-core-009 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-data-import-01 | Import có kiểm soát | Dry-run và reconcile report | Chỉ commit khi pass hoặc override approved |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`ImportBatch`, `ImportIssue`; ghi vào `BibliographicRecord`, `Copy`.

## 9. Flows (tóm tắt — chi tiết ở `srs/data-import-flows.md`)

Tải file → chạy thử → sửa → ghi cả lô → sinh QR → dán nhãn → đối soát.

## 10. Screens (tóm tắt — chi tiết ở `srs/data-import-userflow.md` và `html-wireframe/`)

`import-upload`, `import-report`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Không suy đoán cấu trúc Excel khi chưa có file đại diện | core-spec Mục 11 |
| GATE-MIG là điều kiện thoát R0 | `docs/_product/readiness-gates.md` |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| File Excel đại diện | Data owner | Cấu trúc cột, rule kiểm dòng |
| Sinh QR | `copy-inventory` | Dán nhãn, đối soát |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Ghi theo lô hoàn tác được bằng hủy lô hoặc khôi phục backup | Rollback R0 |

## 12. Open Questions

- [ ] OQ-data-import-001 — File Excel đại diện và cấu trúc cột chính thức? Owner: data owner.
- [ ] OQ-data-import-002 — Ai được duyệt override khi chạy thử chưa đạt, điều kiện và bằng chứng? Owner: data owner + Thủ thư trưởng.
- [ ] OQ-data-import-003 — Có import hồ sơ người đọc không? Owner: data owner.
