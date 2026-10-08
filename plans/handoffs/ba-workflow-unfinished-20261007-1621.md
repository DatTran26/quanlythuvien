---
handoff-version: 1
generated: 2026-10-07T16:21:00+07:00
generator: ak:handoff@2.1.0
focus: "tiếp tục quy trình nghiệp vụ BA còn dang dở"
workspace: D:/Projects/QuanLyThuVIen
branch: develop-dat
head: 85538681e79e8745e93dc4c07e6f1ef82b0cbf9a
---

# HANDOFF: tiếp tục quy trình nghiệp vụ BA còn dang dở

## Mission and current status

Focus: "tiếp tục quy trình nghiệp vụ BA còn dang dở".

Done:

- SRS core, ERD, flows, states và 10 use case đã được tạo nhưng phần lớn còn `status: draft`.
- User flow canonical đã được duyệt với `stage: flow-approved`, `flow_hash: 1c2d7131`, gồm 11 flow và 38 màn hình.
- Mermaid của user flow đã được kiểm tra thành công trong phiên trước.
- BA-Kit đã được bổ sung cho Claude, Codex và Cursor; các template wireframe HTML hiện có đủ.

Remaining:

- Hoàn tất Phase 5: chốt lại device canonical, sinh HTML wireframe, kiểm tra navigation/accessibility/source fidelity.
- Thực hiện Phase 6: user story, backlog index, INVEST/DoR và acceptance criteria.
- Thực hiện Phase 7: test strategy, checklist, phê duyệt checklist và test case ánh xạ 1:1.
- Thực hiện Phase 8: traceability end-to-end, review độc lập, quality report, delivery handoff và operational-readiness evidence.
- Xử lý hoặc gắn owner/gate rõ cho các Open Question còn chặn approval/readiness.

Urgency: normal; không được tuyên bố BA baseline hoàn tất hoặc go-live ready khi các gate còn mở.

## Scope and guardrails

Workspace: `D:/Projects/QuanLyThuVIen`.

In scope: tài liệu BA của `library-management-platform`, kế hoạch Phase 5–8, artifact wireframe/backlog/AC/test/traceability và các quyết định nghiệp vụ liên quan.

Out of scope: triển khai ứng dụng, thay đổi database, tự quyết policy identity/privacy/finance/release, hoặc tự sửa lỗi baseline của KG engine.

Constraints:

- Cấu trúc tài liệu feature là `docs/features/{feature}/`.
- User flow canonical là nguồn chia flow duy nhất cho wireframe/prototype.
- Quyết định mới nhất của người dùng: HTML wireframe dùng khung Mobile 375.
- Mỗi bước ghi tài liệu phải qua approval gate của skill sở hữu; không bịa field, rule, threshold hoặc test data còn thiếu.
- Không sao chép secret, PII thật hoặc credential vào tài liệu/test data.

Safety boundaries: giữ nguyên thay đổi BA-Kit đang chưa commit; không reset/checkout/xóa các file đó. Không tự sửa 22 lỗi baseline KG nếu chưa có yêu cầu riêng.

## Current state

Branch: `develop-dat`.

HEAD: `85538681e79e8745e93dc4c07e6f1ef82b0cbf9a` (`chore: snapshot before BA-Kit import`).

Working tree: dirty do BA-Kit import đã duyệt nhưng chưa commit.

Changed files:

- 13 `SKILL.md` trong `.agents`, `.claude` và `.cursor` được sửa đường dẫn runtime hoặc `docs/features/`.

Untracked files:

- Các dependency skill `figma`, `kg`, `prototype-html`, `wireframe-ascii` trong `.agents/skills`, `.claude/skills`, `.cursor/skills`.
- `CLAUDE.md` mô tả BA skills của dự án.

Intentional local modifications: yes.

Trạng thái nghiệp vụ quan sát được:

- `docs/features/library-management-platform/srs/library-management-platform-userflow.md`: `flow-approved`.
- SRS/use case/domain artifacts vẫn chủ yếu là `draft`.
- `html-wireframe/`, `userstories/`, `test/checklist/`, `test/testcases/` hiện chưa có artifact; chỉ có một số thư mục rỗng.
- Phase 5–8 trong kế hoạch vẫn ghi `status: pending`.

## Decisions and rationale

| Decision | Rationale | Alternative rejected | Reference |
|---|---|---|---|
| User flow gồm 11 flow và 38 màn hình | Phủ 10 use case, happy/error/edge/permission/recovery và release boundaries | Chia lại flow trong bước wireframe | `answer.md`, user flow canonical |
| User flow canonical là nguồn chia flow duy nhất | Tránh ASCII/HTML/prototype suy luận lệch nhau | Mỗi renderer tự chia flow | `library-management-platform-userflow.md` |
| HTML wireframe tiếp theo dùng Mobile 375 | Quyết định mới nhất của người dùng | Tiếp tục desktop 1024 theo metadata cũ | User decision trong phiên hiện tại |
| Không sửa KG baseline trong tác vụ import | Bộ nguồn nguyên bản cũng fail cùng 22 test; phạm vi hiện tại chỉ cài/ghi nhận | Sửa engine không có phê duyệt | Kết quả self-test nguồn và bản import |
| Giữ BA-Kit đa runtime | Claude, Codex và Cursor đều cần cùng skill/template | Chỉ giữ `.claude` | `CLAUDE.md` và ba cây skill |

## Work performed

- Tạo snapshot an toàn bằng commit `8553868` trước BA-Kit import.
- Bổ sung 55 dependency files cho mỗi runtime `.claude`, `.agents`, `.cursor`.
- Giữ nguyên tám skill BA hiện hữu và bổ sung `kg`, `wireframe-ascii`, `prototype-html`, `figma`.
- Chuẩn hóa các skill liên quan sang `docs/features/{feature}` và đúng runtime path.
- Xác nhận đủ template `wireframe-html-template.html` và `wireframe-html-nav-template.html`.
- Tạo `CLAUDE.md` mô tả skill/path của dự án.
- Rà lại kế hoạch Phase 5–8 và các Open Question trong SRS/user flow.

0 redactions applied.

## Verification

| Check | Command/evidence | Outcome | When |
|---|---|---|---|
| Git safety snapshot | `git log`, `git status` | Commit `8553868` tồn tại; worktree import đang dirty có chủ đích | 2026-10-07 |
| Skill references | Quét 384 đường dẫn `@` trong 12 skill × 3 runtime | Tất cả dependency bắt buộc tồn tại; chỉ `docs/design.md` tùy chọn còn thiếu | 2026-10-07 |
| Legacy doc paths | Quét ngoài KG fixtures | Không còn `docs/{feature}` hoặc `docs/*/` trong skill runtime | 2026-10-07 |
| Node syntax | `node --check` cho KG engine và hook runner | Pass | 2026-10-07 |
| KG regression | `node .agents/skills/kg/engine/kg-selftest.mjs` | 115 pass / 22 fail | 2026-10-07 |
| KG source comparison | Chạy cùng self-test từ BA-Kit nguyên bản | Cũng 115 pass / 22 fail; xác nhận baseline upstream | 2026-10-07 |
| Required tools | Kiểm tra command/path | Node v24.18.0, `mmdc`, Bash, Python và Chrome đều có | 2026-10-07 |
| User-flow artifact | Frontmatter + prior verification evidence | `flow-approved`, hash `1c2d7131`; Mermaid trước đó pass 11/11 | 2026-10-07 |

Not run:

- Chưa chạy `wireframe-html` vì device metadata canonical chưa được đồng bộ với quyết định Mobile 375.
- Chưa chạy user story, AC, checklist hoặc test case vì Phase 5 chưa hoàn tất.
- Chưa commit BA-Kit import vì người dùng chưa yêu cầu commit cuối.

## Open risks and blockers

- Type: blocker. Owner: BA/Product Owner. Impact: user flow vẫn ghi `primary_device: desktop` và mô tả màn quầy/quản trị 1024px, trong khi quyết định mới nhất là Mobile 375; phải đồng bộ canonical artifact trước khi sinh wireframe để tránh layout sai nguồn.
- Type: blocker. Owner: Product Owner. Impact: OQ-LMP-015 và OQ-LMP-016 chưa chốt phạm vi/device của reader portal và màn reader R1B.
- Type: blocker. Owner: Domain Approver. Impact: OQ-LMP-017 chưa chốt quyền Thủ thư xem reports, ảnh hưởng wireframe và AC permission.
- Type: blocker. Owner: Data Owner + Thủ thư trưởng/Product Owner. Impact: OQ-LMP-018 chưa chốt quyền/điều kiện/evidence cho import override.
- Type: risk. Owner: product/security/privacy/finance/domain owners. Impact: OQ-LMP-001..014 còn nhiều policy, threshold và approval gate mở; story/AC/test liên quan phải giữ Not Ready thay vì tự suy đoán.
- Type: risk. Owner: BA lead. Impact: SRS và use case còn `draft`; downstream artifact phải ghi rõ nguồn draft và readiness gate.
- Type: risk. Owner: BA-Kit maintainer. Impact: KG self-test có 22 lỗi baseline; không dùng kết quả KG rỗng để kết luận nghiệp vụ, luôn đọc prose theo `kg-usage.md`.
- Type: question. Owner: Product/Design. Impact: `docs/design.md` chưa có; `prototype-html` có fallback nhưng chưa có design token canonical.

## Exact next actions

1. **First safe step** — đọc `library-management-platform-userflow.md`, `answer.md` và Phase 5; ghi nhận quyết định Mobile 375 vào canonical device metadata/nội dung qua approval gate trước khi tạo wireframe.
2. Chạy `/wireframe-html library-management-platform` từ user flow đã đồng bộ; tạo entry HTML, index và từng file flow trong `html-wireframe/`.
3. Mở entry HTML và kiểm tra 11 flow: navigation, screen order, error/empty/permission/recovery, keyboard focus và source mapping.
4. Cập nhật Phase 5 chỉ sau khi wireframe verification đạt; giữ các OQ unresolved được gắn owner/gate.
5. Chạy `/userstory library-management-platform`, sau đó `/ac` cho story đủ điều kiện; story phụ thuộc OQ mở phải giữ Not Ready.
6. Lập `test-strategy.md`, chạy `/test-checklist`, duyệt checklist rồi mới chạy `/test-cases`; kiểm tra CHK↔TC 1:1.
7. Tạo traceability P0 end-to-end, chạy review độc lập, xử lý blocker/major và lập handoff/operational readiness ở Phase 8.
8. Sau khi người dùng duyệt trạng thái import, commit riêng BA-Kit changes bằng conventional commit; không trộn với artifact nghiệp vụ mới.

## Source pointers

- `answer.md`
- `CLAUDE.md`
- `plans/261004-1734-library-management-full-ba-workflow/plan.md`
- `plans/261004-1734-library-management-full-ba-workflow/phase-05-ux-flow-and-html-wireframe.md`
- `plans/261004-1734-library-management-full-ba-workflow/phase-06-backlog-and-acceptance-criteria.md`
- `plans/261004-1734-library-management-full-ba-workflow/phase-07-qa-checklist-and-test-cases.md`
- `plans/261004-1734-library-management-full-ba-workflow/phase-08-traceability-review-and-handoff.md`
- `docs/features/library-management-platform/srs/library-management-platform-spec.md`
- `docs/features/library-management-platform/srs/library-management-platform-userflow.md`
- `docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md`
- `.agents/skills/wireframe-html/SKILL.md`
- `.agents/skills/userstory/SKILL.md`
- `.agents/skills/ac/SKILL.md`
- `.agents/skills/test-checklist/SKILL.md`
- `.agents/skills/test-cases/SKILL.md`
