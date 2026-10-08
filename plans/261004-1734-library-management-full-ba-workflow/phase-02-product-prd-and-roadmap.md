---
title: "Phase 2: Product PRD và roadmap"
status: in-review
priority: P1
effort: "1–2 approval cycles"
dependencies: [1]
---

# Phase 2: Product PRD và roadmap

## Mục tiêu

Biến baseline đã kiểm soát thành Product PRD và roadmap có outcome, dependency, release gate, non-goal và tiêu chí đo lường rõ ràng.

## Yêu cầu

- PRD bao phủ problem, actor, JTBD, value proposition, scope, capability, KPI, constraint, assumption và risk.
- Roadmap sử dụng R0/R1A/R1B/R2/R3; không cam kết quý/ngày khi chưa có capacity estimate.
- Mỗi item roadmap liên kết capability/requirement nguồn và decision liên quan bằng stable ID.
- Không có tính năng trong R1B phụ thuộc chức năng chỉ xuất hiện ở R2.
- R3 là candidate, không được trình bày như cam kết.
- Product PRD và roadmap qua hai cổng duyệt L1 riêng biệt.

## File tác động

- Tạo `docs/_product/prd.md`.
- Tạo `docs/_product/roadmap.md`.
- Tạo `docs/_product/priority-crosswalk.md` để giữ nguyên priority nguồn và ánh xạ sang normalized priority/release.
- Tạo `docs/_product/readiness-gates.md` cho Decision/Migration/UAT/Pilot/Operations/Training/Go-No-Go.
- Cập nhật `docs/_product/decision-register.md` khi phát sinh quyết định.

## Các bước thực hiện

1. Dùng template Product PRD của dự án, điền từ baseline và evidence đã duyệt.
2. Lập feature/capability map theo actor và value stream.
3. Lập priority crosswalk: source P1/P2/P3 ≠ normalized capability P0/P1/P2; mọi gate hạ nguồn dùng normalized field nhưng giữ source field để truy vết.
4. Xác định critical path bắt buộc: governance/legal → privileged identity/RBAC → policy/state → import/QR reconciliation → audit/backup/restore → catalog/copy/member → circulation/fine/damage → pilot/reporting.
5. Chia release R0, R1A, R1B, R2 và R3; với mỗi release ghi outcome, scope, dependency, entry gate, exit gate, metric và non-goal.
6. Gắn bảy gate bắt buộc: Decision, Migration, UAT, Pilot, Operations/Restore, Training/SOP và Release/Go-No-Go; mỗi gate có owner, artifact và exit evidence.
7. Rà dependency inversion, duplicate scope và implicit commitment.
8. Xin L1 approval cho PRD trước, sau đó cho roadmap; lưu approver, thời điểm và evidence.

## Todo

- [x] Hoàn thiện Product PRD.
- [x] Hoàn thiện feature/capability map.
- [x] Hoàn thiện priority crosswalk.
- [x] Hoàn thiện roadmap theo release.
- [x] Kiểm tra critical path và dependency.
- [x] Gắn owner/evidence cho Migration, UAT, Pilot, Operations, Training và Go-No-Go gates.
- [x] Ghi nhận hai approval gate.

## Verification

- Mọi capability roadmap phải tồn tại trong PRD hoặc được ghi rõ là discovery candidate.
- Không có R1B item phụ thuộc R2.
- Không có ngày/quý hoặc capacity được bịa đặt.
- Mỗi release có điều kiện vào/ra đo được và owner của blocker.

## Kịch bản kiểm tra

| Tình huống | Kỳ vọng |
|------------|---------|
| Notification cần Reservation nhưng Reservation chưa phát hành | Cùng release hoặc dependency/release được điều chỉnh |
| R3 analytics chưa có evidence | Gắn nhãn Candidate/Discovery, không cam kết |
| Metric chưa có baseline | Ghi phương pháp đo và owner thiết lập baseline, không bịa con số |

## Rủi ro và an toàn

- KPI về người dùng không được yêu cầu thu thập PII quá mức cần thiết.
- Scope pháp lý/phân quyền chưa duyệt phải là gate, không bị chôn trong ghi chú.

## Tiêu chí hoàn tất

- [ ] PRD và roadmap có L1 approval evidence.
- [x] Feature map phủ mọi value stream P0.
- [x] Roadmap không có contradiction hay dependency inversion.
- [x] Mỗi release có outcome và exit gate kiểm chứng được.

## Bước kế tiếp

Dùng PRD/roadmap làm biên để phục hồi lifecycle và rule nghiệp vụ ở Phase 3.
