---
type: ba-roadmap-plan
status: in-progress
updated: 2026-10-05
links:
  - docs/he_thong_quan_ly_thu_vien.md
  - docs/_shared/project-profile.md
  - docs/features/library-management-platform/brainstorms/product-roadmap-baseline.md
  - plans/reports/ba-audit-261005-0018-library-management-roadmap.md
---

# Kế hoạch làm rõ roadmap sản phẩm Hệ thống Quản lý Thư viện

## Outcome

Tạo một baseline sản phẩm có thể dùng để ra quyết định: capability được phân rã thành epic/feature, sắp release theo dependency, có entry/exit gate, KPI, rủi ro, phạm vi pilot và đường truy vết đến requirement chi tiết.

## Constraints

- Một cơ sở và web responsive trong baseline đầu.
- Không đưa online payment, multi-branch hoặc offline vào release cam kết khi chưa có business case riêng.
- Không coi giá trị đề xuất trong tài liệu cũ là quyết định đã phê duyệt nếu chưa được baseline hóa.
- Không thiết kế database/API/framework trong tài liệu roadmap.
- Tài liệu chính thức phải phân biệt Fact, Baseline decision, Proposal và Open question.

## Non-goals

- Không triển khai phần mềm trong kế hoạch này.
- Không lập timeline theo ngày hoặc ước lượng chi phí khi chưa có team capacity.
- Không tạo test case chi tiết trước khi requirement và flow được khóa.
- Không cam kết các candidate initiatives của R3.

## Phase 1 — Product baseline

**Input:** tài liệu nguồn và kết quả audit.

**Công việc:**

1. Chốt vision, actor, product owner, phạm vi và non-scope.
2. Chuẩn hóa các baseline decision từ 15 OQ.
3. Xác định KPI pilot và các quyết định cần legal/data owner duyệt.
4. Phục hồi các artifact bị thiếu: state machine Copy và flow trả.

**Output:** project profile, brainstorm baseline, audit report.

**Exit criteria:** không còn mâu thuẫn nội bộ về scope MVP; các OQ chưa thể tự quyết có owner và gate.

## Phase 2 — Capability và value-stream decomposition

1. Phân rã sản phẩm thành các workstream:
   - governance và policy;
   - identity và access;
   - catalog, inventory, QR và migration;
   - circulation;
   - reservation và notification;
   - fine, damage và financial control;
   - privacy, audit và reporting;
   - operational readiness.
2. Xác định capability P0/P1/P2 và owner nghiệp vụ.
3. Lập dependency map và critical path.
4. Tách epic/feature đủ nhỏ để viết PRD/SRS độc lập.

**Exit criteria:** mỗi capability có outcome, actor, dependency và proposed release.

## Phase 3 — Product roadmap

1. R0 — Product contract & readiness.
2. R1A — Identity, inventory và data readiness.
3. R1B — Minimum viable operations và pilot.
4. R2 — Reader self-service, reservation, automation và analytics.
5. R3 — Candidate initiatives chỉ sau decision gate.

Mỗi release phải có mục tiêu, scope, dependency, entry criteria, exit criteria, KPI, rủi ro và rollback boundary.

**Exit criteria:** không có producer ở release sớm hơn consumer/resolver bắt buộc; critical path được kiểm tra chéo.

## Phase 4 — Requirements package

Thực hiện tuần tự theo từng epic đã được ưu tiên:

1. URD: persona, need, journey và success measure.
2. BRD: objective, policy, scope và business risk.
3. PRD: capability, priority, dependency và done-when.
4. SRS: FR/NFR/BR/error/success criteria.
5. Models: use case, flow, state và entity model.
6. UX: user flow rồi wireframe.
7. Delivery: user story, acceptance criteria và test checklist.

**Exit criteria:** mỗi P0 capability truy vết được đến requirement và scenario nghiệm thu.

## Phase 5 — Readiness và sign-off

1. Migration dry-run và đối soát QR.
2. UAT theo vai trò và lifecycle.
3. Diễn tập backup/restore, job retry và xử lý sự cố.
4. Đào tạo, SOP, hỗ trợ pilot và tiêu chí rollback.
5. Go/no-go do Thủ thư trưởng phê duyệt.

## Validation

- Kiểm tra link và frontmatter của mọi tài liệu.
- Kiểm tra terminology thống nhất với project profile.
- Kiểm tra roadmap dependency bằng critical path.
- Review độc lập theo góc Senior BA, QA và feasibility.
- Không đóng plan nếu còn blocker không có owner/gate.

## Risks and rollback

| Risk | Control | Rollback boundary |
|---|---|---|
| Nguồn thiếu state/flow | Phục hồi trước SRS | Không khóa requirement liên quan |
| Dữ liệu import không đạt | Dry-run và đối soát | Không bật giao dịch dữ liệu thật |
| Pilot có lỗi nghiêm trọng | Tiêu chí dừng và hỗ trợ tại chỗ | Quay về quy trình cũ trong phạm vi pilot |
| Scope candidate chen vào MVP | Decision gate riêng | Loại khỏi release, không làm thay đổi critical path |

## Acceptance criteria

- Có roadmap R0–R3 kèm dependency và readiness gate.
- Có capability map và ma trận capability–epic–release.
- Mọi P0 capability có owner, KPI và điều kiện hoàn thành.
- State machine Copy và flow trả được phục hồi hoặc được đánh blocker rõ.
- Mọi câu hỏi mở còn lại có owner và thời điểm phải chốt.
- Không còn xung đột P1/P2 làm vòng vận hành bị đứt.

