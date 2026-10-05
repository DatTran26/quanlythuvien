---
title: "Quy trình BA đầy đủ cho Hệ thống Quản lý Thư viện"
description: "Hoàn thiện product baseline, roadmap, SRS, UX, backlog và bộ kiểm thử bằng toàn bộ BA skill đã cài trong dự án."
status: in-progress
priority: P1
effort: "8 phases"
issue: ""
branch: ""
tags: [docs, product, ba, critical]
blockedBy: ["stakeholder-approval-authority", "representative-excel-source", "missing-copy-and-return-diagrams"]
blocks: []
created: 2026-10-05
---

# Quy trình BA đầy đủ cho Hệ thống Quản lý Thư viện

## Tổng quan

Chuyển tài liệu khám phá hiện có thành chuỗi đặc tả có truy vết từ quyết định sản phẩm đến test case. Kế hoạch dùng đủ 8 BA skill đang cài trong dự án: `brainstorm`, `srs`, `user-flow`, `wireframe-html`, `userstory`, `ac`, `test-checklist`, `test-cases`. Product PRD và roadmap dùng template nội bộ vì runtime không có skill chuyên biệt tương ứng.

## Scope challenge

- Tài sản đầu vào: tài liệu hệ thống, project profile, brainstorm baseline, báo cáo audit và roadmap sơ bộ.
- Phạm vi yêu cầu: toàn bộ chuỗi BA; không cắt UX, delivery backlog hay QA.
- Độ phức tạp: hơn 30 artifact tiềm năng, 8 giai đoạn và nhiều cổng duyệt có phụ thuộc.
- Quyết định: giữ nguyên phạm vi, dùng chế độ Deep; chia theo cổng phê duyệt để tránh tài liệu hạ nguồn xây trên giả định chưa được chốt.

## Mục tiêu

| # | Mục tiêu | Ưu tiên |
|---|----------|---------|
| 1 | Chốt baseline và decision register, phân biệt rõ fact/proposal/approved | P0 |
| 2 | Hoàn thiện Product PRD và roadmap có dependency, exit gate và release boundary | P0 |
| 3 | Đặc tả SRS cùng lifecycle/state/data model cho toàn bộ nghiệp vụ lõi | P0 |
| 4 | Tạo user flow và wireframe HTML nhất quán với SRS | P1 |
| 5 | Sinh backlog user story và acceptance criteria sẵn sàng refinement | P0 |
| 6 | Sinh checklist và test case truy vết 1:1, đủ happy/error/edge | P0 |
| 7 | Đóng gói traceability, quality review và handoff thực thi | P0 |

## Các giai đoạn

| # | Giai đoạn | Trạng thái | Phụ thuộc |
|---|-----------|------------|-----------|
| 1 | [Baseline và governance](./phase-01-baseline-governance.md) | In-progress | — |
| 2 | [Product PRD và roadmap](./phase-02-product-prd-and-roadmap.md) | In-review (chờ L1 approval) | 1 |
| 3 | [Domain model và phục hồi state](./phase-03-domain-models-and-state-recovery.md) | Completed | 1, 2 |
| 4 | [SRS core và models](./phase-04-srs-core-and-models.md) | Pending | 2, 3 |
| 5 | [UX flow và HTML wireframe](./phase-05-ux-flow-and-html-wireframe.md) | Pending | 4 |
| 6 | [Backlog và acceptance criteria](./phase-06-backlog-and-acceptance-criteria.md) | Pending | 4, 5 |
| 7 | [QA checklist và test cases](./phase-07-qa-checklist-and-test-cases.md) | Pending | 4, 5, 6 |
| 8 | [Traceability, review và handoff](./phase-08-traceability-review-and-handoff.md) | Pending | 1–7 |

## Dependency map

`Brainstorm baseline → Product PRD → Roadmap/Decision register → State recovery → SRS Core → Models → User flow → Wireframe HTML → User story → AC → Test checklist → Test cases → Final traceability review`

## Phụ thuộc liên kế hoạch và bên ngoài

- Kế thừa dữ liệu khám phá từ `plans/261005-0018-library-management-product-roadmap/`; kế hoạch này là source of truth mới cho BA delivery, kế hoạch cũ chỉ còn vai trò evidence và phải được đánh dấu superseded khi baseline mới được duyệt.
- Phụ thuộc stakeholder cung cấp Excel đại diện, nội dung hai sơ đồ Copy/return bị thiếu và authority phê duyệt identity/privacy/financial controls. Các dependency này phải có owner, due gate và acceptance evidence trong decision register.

## Tiêu chí hoàn tất

- [ ] Cả 8 BA skill được dùng đúng prerequisite và approval gate.
- [ ] Roadmap không có dependency đảo chiều; mỗi release có outcome, scope, dependency, entry/exit gate và non-goal.
- [ ] Mỗi yêu cầu P0 truy vết được qua FR/BR/Error/NFR → Story/AC hoặc verification contract → CHK → TC/evidence.
- [ ] Copy, Loan, Reservation, Fine và DamageReport có lifecycle/state transition đầy đủ.
- [ ] Không còn blocker chưa có owner, approver và due gate.
- [ ] Mermaid, liên kết nội bộ, HTML entry point và schema tài liệu đều được kiểm tra.
- [ ] `ak plan validate` vượt qua không có lỗi.

## Câu hỏi cần quyết định trong quá trình thực hiện

- Chính sách lưu giữ/xoá dữ liệu cá nhân và nhật ký phải được chủ dự án hoặc bên pháp lý phê duyệt trước khi khoá NFR.
- Nếu không lấy được sơ đồ nguồn, phải tổ chức reconstruct-as-proposal và có domain approval; không gọi là “phục hồi từ nguồn”.
- Cần chỉ định authority cuối cùng cho privileged identity, privacy và financial-control gates.

## Red Team Review

### Session — 2026-10-05

**Findings:** 37 raw findings (16 consolidated accepted; 21 duplicate findings rejected as independently actionable because they are subsumed by the accepted root causes).  
**Severity breakdown:** 8 Critical, 27 High, 2 Medium.

| # | Finding hợp nhất | Mức | Disposition | Áp dụng |
|---|------------------|-----|-------------|---------|
| 1 | Hai plan cùng scope thiếu source-of-truth | High | Accept | Plan, Phase 8 |
| 2 | External inputs/authority không được khai báo blocker | Critical | Accept | Plan, Phase 1 |
| 3 | OQ collision và hard-stop có thể bị vượt | Critical | Accept | Phase 1, 4 |
| 4 | Thiếu stable ID/retirement governance | High | Accept | Phase 1 |
| 5 | Critical path bỏ qua security/operations gates | Critical | Accept | Phase 2 |
| 6 | Thiếu priority crosswalk | High | Accept | Phase 2 |
| 7 | Lifecycle inventory không có artifact bền | High | Accept | Phase 3 |
| 8 | Financial recovery/ledger thiếu tính toàn vẹn | Critical | Accept | Phase 3, 4 |
| 9 | Checkout/reservation thiếu atomicity và idempotency | High | Accept | Phase 3, 7 |
| 10 | Artifact path/frontmatter sai contract skill | High | Accept | Phase 4–8 |
| 11 | Security contract chưa đủ object/field/session/QR/upload/audit | Critical | Accept | Phase 4, 7 |
| 12 | Full-scope SRS mâu thuẫn release baseline | Medium | Accept | Phase 4 |
| 13 | NFR mất khỏi QA/traceability | High | Accept | Phase 7, 8 |
| 14 | Thiếu stale propagation/re-approval loop | High | Accept | Phase 6, 8 |
| 15 | Operational readiness thiếu deliverable/gate | Critical | Accept | Phase 2, 8 |
| 16 | Proposal mới bị trình bày như requirement | High | Accept | Phase 3 |

Các finding bị Reject đều là bản lặp của 16 nguyên nhân trên; không có finding có bằng chứng mới bị bỏ qua.

<!-- slug: library-management-full-ba-workflow -->
