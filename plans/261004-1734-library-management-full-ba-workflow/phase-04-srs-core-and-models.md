---
title: "Phase 4: SRS core và models"
status: pending
priority: P1
effort: "2 approval cycles"
dependencies: [2, 3]
---

# Phase 4: SRS core và models

## Mục tiêu

Dùng skill `srs` để kỹ thuật hoá scope đã duyệt thành Core Spec, use cases, flow, state và ERD có ID ổn định và truy vết được.

## Yêu cầu

- Core Spec bao phủ FR, NFR, Business Rules, Error Matrix, data/privacy/security và dependency.
- Mỗi FR có actor, priority, source và verify-by.
- Mỗi requirement P0 có ít nhất happy path, validation/error và recovery behavior.
- ID dùng prefix feature, không tái sử dụng ID đã retired.
- Các hard-stop schema/state/release/identity/privacy/finance phải `Resolved + Approved` trước khi vào Tầng 1/2.
- Mỗi file Tầng 1 và Tầng 2 phải qua L1 approval theo đúng contract skill `srs`.

## File tác động

- Tạo `docs/features/library-management-platform/srs/library-management-platform-spec.md`.
- Tạo `docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md` và `usecases/uc-*.md`.
- Tạo các file phẳng `srs/library-management-platform-flows.md`, `srs/library-management-platform-states.md`, `srs/library-management-platform-erd.md`.

## Các bước thực hiện

1. Chạy `srs library-management-platform` theo release baseline: P0 fully specified/approved; P1/P2 chỉ capability envelope + dependency + deferred rationale, và dừng phase này sau Tầng 2.
2. Sinh Core Spec từ PRD, roadmap, decision register và lifecycle inventory.
3. Tạo use-case index và use case theo value stream; xác định pre/postcondition, main, alternate và exception flow.
4. Sinh flow/state Mermaid và ERD; giữ mỗi model có legend, invariant và source reference.
5. Chạy Mermaid verification; nếu semantic KG tooling không dùng được thì thực hiện fallback grep/link scan theo skill.
6. Thêm security contract: actor×resource×action×field×purpose; reset/session/step-up; QR chỉ là locator; audit tamper/redaction/retention; upload image trust boundary.
7. Review bởi BA + domain/tech/security reviewer phù hợp; ghi L1 approval cho từng file Tầng 1 rồi Tầng 2.

## Todo

- [ ] Hoàn thiện Core Spec.
- [ ] Hoàn thiện use cases.
- [ ] Hoàn thiện flows và states.
- [ ] Hoàn thiện ERD và data dictionary tối thiểu.
- [ ] Chạy quality gate và ghi approval evidence.

## Verification

- Không có orphan ID hoặc broken reference giữa FR/BR/Error/UC/model.
- Mermaid parse thành công; tên state/entity nhất quán với Core Spec.
- NFR có metric hoặc phương thức xác minh; điều chưa định lượng phải có decision owner.
- Error matrix phủ authorization, validation, concurrency, external failure và recovery.

## Kịch bản kiểm tra tối thiểu

| Nhóm | Phải có trong SRS |
|------|-------------------|
| Checkout/Return | atomicity, concurrency, due rule, damage, lost, fine side effect |
| Reservation | queue order, eligibility, expiry, pickup, notification failure |
| Fine/Payment | calculation, adjustment, waiver, partial/full payment, audit |
| Access/Privacy | role boundary, least privilege, retention/deletion decision |
| Catalog/Copy | bibliographic record vs physical copy, loanability, state recovery |

## Rủi ro và an toàn

- Không đưa credential, secret hoặc PII mẫu thật vào SRS.
- Security/privacy requirement chưa duyệt phải giữ trạng thái Open và chặn downstream thích hợp.

## Tiêu chí hoàn tất

- [ ] Mỗi file Tầng 1 và Tầng 2 có approval evidence.
- [ ] Tất cả P0 capability có FR/BR/Error/UC tương ứng.
- [ ] State/flow/ERD nhất quán và Mermaid hợp lệ.
- [ ] Không còn orphan reference.

## Bước kế tiếp

Chuyển sang UX flow và wireframe HTML ở Phase 5; sau đó quay lại `srs` Tier 3 ở các phase hạ nguồn.
