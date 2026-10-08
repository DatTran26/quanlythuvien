---
type: readiness-gates
status: draft
updated: 2026-10-08
links:
  - docs/_product/prd.md
  - docs/_product/roadmap.md
  - docs/_product/priority-crosswalk.md
  - docs/_product/decision-register.md
  - plans/reports/ba-audit-261005-0018-library-management-roadmap.md
---

# Readiness Gates — Cổng sẵn sàng trên critical path

> `PROPOSAL` toàn bộ. Bảy gate gắn cố định vào critical path `governance/legal → identity/RBAC → policy/state → import/QR → audit/backup → catalog/member → circulation → pilot/reporting`. Gate đánh dấu **Non-waivable** không được bỏ qua dưới bất kỳ áp lực tiến độ nào; waive gate còn lại phải có quyết định ghi trong decision register kèm approver.

## Tổng quan

| Gate | Tên | Vị trí trên roadmap | Owner | Non-waivable | Feature liên quan |
|---|---|---|---|---|---|
| GATE-DEC | Decision | Entry R0; tiếp diễn trước GATE-GNG | Thủ thư trưởng (điều phối approver) | Có — với hard-stop decision | `policy-config`, `access-control`, `account-admin`, `fine-collection-adv`, `ops-foundation` (privacy) |
| GATE-MIG | Migration | Exit R0 | Quản trị viên | Có | `data-import`, `catalog-admin`, `copy-inventory` |
| GATE-UAT | UAT | Trong R1B | Đại diện thủ thư quầy + Quản trị viên | Có | Mọi feature R0–R1B |
| GATE-OPS | Operations / Restore | Một phần exit R0; đầy đủ trong R1B | Owner vận hành (chỉ định trong decision register — `PROPOSAL`) | Có (restore trước go-live) | `ops-foundation`, `notification-core` |
| GATE-TRN | Training / SOP | Trong R1B | Quản trị viên | Có | `checkout`, `return-handling`, `damage-lifecycle`, `lost-handling`, `fine-collection-basic` |
| GATE-PILOT | Pilot readiness | Cuối R1B | Thủ thư trưởng | Có | Mọi feature R0–R1B |
| GATE-GNG | Release / Go-No-Go | Cuối R1B | Thủ thư trưởng | **Có — tuyệt đối** | Mọi feature R0–R1B |

## GATE-DEC — Decision gate

| Trường | Nội dung |
|---|---|
| Mục đích | Mọi quyết định hard-stop (privileged identity OQ-01, giá trị BR-01..10 OQ-04, kích hoạt người đọc OQ-03, privacy/retention OQ-12, financial control — miễn/điều chỉnh phạt, kênh thông báo OQ-07) phải `Resolved + Approved` trước phase/release sở hữu. |
| Owner | Thủ thư trưởng (điều phối); approver riêng cho legal/privacy = người phụ trách pháp lý/quản trị dữ liệu; financial = Thủ thư trưởng + kế toán (`PROPOSAL` — chỉ định authority cuối là open item của plan). |
| Artifact | `docs/_product/decision-register.md` — mỗi DEC có owner, approver, due gate, evidence. |
| Entry evidence | Decision đã được raise với đủ trường bắt buộc. |
| Exit evidence | `Resolved + Approved` với approver + thời điểm + link evidence; external blocker (Excel, sơ đồ nguồn) có acceptance evidence hoặc reconstruction approval — **không** được trình bày là "phục hồi từ nguồn". |
| Security dimension | Privileged identity/RBAC authority và privacy/retention approval là **security gate trên critical path** — không có approval thì không build privilege và không go-live. |
| Waivable | Không với hard-stop decision; non-blocker chỉ cần owner + due gate (theo Phase 1 rule). |

## GATE-MIG — Migration / Import gate

| Trường | Nội dung |
|---|---|
| Mục đích | Dữ liệu thật đi vào hệ thống chỉ qua import có kiểm soát: dry-run, lỗi theo dòng, dedup, đối soát tổng, rollback theo batch. |
| Owner | Quản trị viên (dữ liệu) + đội kỹ thuật (công cụ import). |
| Artifact | Source profile + mapping của file Excel thật; báo cáo dry-run; biên bản đối soát vật lý; runbook rollback batch. |
| Entry evidence | File Excel đại diện đã được cung cấp (external blocker — owner Thủ thư trưởng); mapping được duyệt. |
| Exit evidence | 100% bản ghi lỗi/trùng được chỉ rõ và xử lý trước ghi chính thức; sai lệch kho sau đối soát vật lý ≤ 1% (target); demo rollback một batch lỗi thành công; QR sinh ra quét đúng, có phương án nhập mã thủ công. |
| Waivable | Không — không có kho dữ liệu đối soát được thì không bật giao dịch. |

## GATE-UAT — User Acceptance gate

| Trường | Nội dung |
|---|---|
| Mục đích | Mọi capability P0/R1A–R1B có scenario được người dùng đại diện chạy trên dữ liệu đại diện; traceability capability → requirement → scenario không còn blocker. |
| Owner | Đại diện thủ thư quầy (UAT) + Quản trị viên (nghiệm thu). |
| Artifact | UAT script theo scenario (happy/error/boundary/interruption/concurrent); biên bản UAT; danh sách lỗi với severity. |
| Entry evidence | R1A + phần chức năng R1B hoàn thành; AC tồn tại cho mọi item được UAT (nối Phase 6). |
| Exit evidence | 0 lỗi blocker mở; lỗi còn lại có owner + workaround SOP; traceability hoàn chỉnh cho P0. |
| Waivable | Không. |

## GATE-OPS — Operations / Restore gate

| Trường | Nội dung |
|---|---|
| Mục đích | Vận hành sống sót được: backup theo lịch, **ít nhất một lần restore thành công trước go-live**, mọi tác vụ nền có owner và idempotency, runbook xử lý sự cố. |
| Owner | Owner vận hành (`PROPOSAL` — cần chỉ định; hiện gán tạm Thủ thư trưởng phê duyệt). |
| Artifact | Runbook; lịch backup (hằng ngày, giữ 30 bản — NFR-07); biên bản restore drill; bảng owner cho từng job (quá hạn 00:05, nhắc hạn 08:00, hết hạn giữ 15', hết hạn thẻ). |
| Entry evidence | Backup job chạy đều trong R0; checklist job đã có. |
| Exit evidence | Restore drill thành công có biên bản (R0: một lần trên dữ liệu import; R1B: một lần trên dữ liệu gần go-live); mọi job có owner; runbook sự cố mất kết nối/double-scan/job lỗi sẵn sàng. |
| Waivable | Restore drill trước go-live: **không waivable**. |

## GATE-TRN — Training / SOP gate

| Trường | Nội dung |
|---|---|
| Mục đích | Người vận hành thật biết dùng hệ thống và xử lý ngoại lệ trước pilot. |
| Owner | Quản trị viên. |
| Artifact | SOP cho Thủ thư (mượn/trả/hư hỏng/mất/thu phạt/QR hỏng) và Quản trị viên (import, duyệt, cấu hình, báo cáo); dữ liệu tập luyện; biên bản diễn tập. |
| Entry evidence | UAT đã chạy để SOP phản ánh hành vi thật. |
| Exit evidence | ≥1 buổi diễn tập đầy đủ tại quầy với dữ liệu tập; mọi thủ thư pilot đã thực hành mượn–trả–ngoại lệ. |
| Waivable | Không. |

## GATE-PILOT — Pilot readiness gate

| Trường | Nội dung |
|---|---|
| Mục đích | Pilot có khung rõ: người dùng/thiết bị/dữ liệu đại diện, tiêu chí dừng, kênh hỗ trợ, phạm vi một cơ sở hai quầy. |
| Owner | Thủ thư trưởng. |
| Artifact | Kế hoạch pilot (phạm vi, danh sách quầy/thiết bị, tập người đọc đại diện); tiêu chí dừng/tiếp tục; kênh báo lỗi và SLA hỗ trợ nội bộ. |
| Entry evidence | GATE-UAT, GATE-OPS, GATE-TRN đạt. |
| Exit evidence | Kế hoạch pilot được Thủ thư trưởng duyệt; checklist thiết bị (camera/quét QR, in nhãn) hoàn tất. |
| Waivable | Không. |

## GATE-GNG — Release / Go-No-Go gate

| Trường | Nội dung |
|---|---|
| Mục đích | Quyết định go-live cuối cùng trên toàn bộ evidence; **non-waivable**. |
| Owner | Thủ thư trưởng (Product Owner) ký; đối chiếu legal/privacy/financial approver. |
| Artifact | Biên bản Go-No-Go: tổng hợp exit evidence của 6 gate trên + danh sách rủi ro mở có chấp nhận + quyết định ký. |
| Entry evidence | Tất cả gate trước đạt hoặc có waive hợp lệ (riêng DEC hard-stop, MIG, OPS-restore, UAT không waive được). |
| Exit evidence | Quyết định Go hoặc No-Go ghi vào decision register kèm approver/thời điểm; nếu Go — pilot plan kích hoạt; nếu No-Go — backlog sửa và điều kiện họp lại. |
| Security dimension | Kiểm chứng cuối: RBAC server-side (NFR-02), PII tối thiểu theo vai trò, audit bật, retention/privacy đã approved — thiếu một mục là No-Go. |
| Waivable | **Không — bất kỳ điều kiện nào.** |

## Ma trận evidence theo release

| Release | Gate áp dụng | Evidence chính |
|---|---|---|
| R0 entry | GATE-DEC (phần nền tảng) | DEC identity/policy/activation Resolved+Approved |
| R0 exit | GATE-MIG + GATE-OPS (phần) | Đối soát kho ≤1%; restore drill lần 1 |
| R1A exit | (không gate riêng) | Exit criteria release trong roadmap §4 |
| R1B | GATE-UAT, GATE-TRN, GATE-OPS (đầy đủ), GATE-PILOT, GATE-DEC (financial/privacy còn lại), GATE-GNG | Biên bản 6 gate + Go-No-Go |
| R2 | GATE-DEC (nếu giá trị BR-08..10 cần duyệt riêng) | Regression luồng trả + hàng chờ |
| R3 | Quyết định riêng từng initiative | Business case + approval từng mục |

<!-- Phase 2 deliverable — QuanLyThuVIen BA workflow -->
