---
paths:
  - ".claude/skills/jira/**"
  - "docs/**/userstories/**"
---

# Jira Mapping Rules‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

> Standard mapping từ BA vault docs sang Jira issues (issue hierarchy + field mapping).
>
> __Sync-state / idempotency / conflict / mapping store__ đã chuyển sang `.claude/rules/atlassian-sync.md` (gộp chung Jira+Confluence ở `.agents/state/atlassian/sync-state.yaml`). File này chỉ còn giữ __quy ước map cấu trúc__ (loại issue, field nào lấy từ đâu). Mọi chỗ dưới nhắc `docs/_shared/jira-map.md` là __di sản__ — nguồn thật giờ là `sync-state.yaml`.

## Issue hierarchy‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

| Vault artifact | Jira issue type | Parent | Path note |
|----------------|-----------------|--------|--------------|
| SRS feature | Epic | none or initiative | `docs/features/{feature}/srs/{feature}-spec.md` |
| User story | Story | Epic | `docs/features/{feature}/userstories/us-{NNN}.md` |
| AC item | Sub-task or checklist | Story | inline trong us-{NNN}.md |
| Use case | Linked doc only | Epic or Story | `docs/features/{feature}/usecases/uc-*.md` |

## Field mapping‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

| Jira field | Source |
|------------|--------|
| Summary | Story title (body H1) hoặc feature name |
| Description | Generated markdown summary với links back to vault paths (Jira Markdown format) |‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍
| Acceptance Criteria | `## Acceptance Criteria` section của US |
| Priority | frontmatter `priority` hoặc linked FR priority |
| Labels | `ba-vault`, feature slug, doc type |
| Components | optional user-provided mapping |
| Epic Link / Parent | generated từ SRS feature mapping |

Note: Description links dùng absolute repo path từ vault root, vd `[docs/features/payment/userstories/us-001.md](../../docs/features/payment/userstories/us-001.md)`.

## Idempotency (key ở index, không ở us frontmatter)‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

US files là __zero frontmatter__. Idempotency/mapping/sync-state canonical sống ở **`.agents/state/atlassian/sync-state.yaml`** (`mappings.jira.remote_id` + hashes + state) — xem `atlassian-sync.md`. `docs/_shared/jira-map.md` đã __bỏ__ (migrate + xóa).

* __Issue key (bản chiếu để đọc)__ — cột `Jira` trong bảng Stories của `docs/features/{feature}/userstories/{feature}-story-index.md` (vd `PROJ-123`, `—` nếu chưa push). Đây là __bản chiếu__ đồng bộ TỪ sync-state cho người đọc/Obsidian, KHÔNG phải nguồn thật.
* __url + pushed_at + hashes + state__ — ở `sync-state.yaml` (nguồn duy nhất).

Idempotency THẬT không chỉ dựa key: key đã tồn tại → __update qua remote preflight__ (Mục 5 `atlassian-sync.md`), KHÔNG ghi đè mù. `--force-create` là thao tác ngoại lệ có lý do + confirm riêng, KHÔNG phải đường tắt thường ngày.

## Mapping file‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

Mapping GỘP ở `.agents/state/atlassian/sync-state.yaml` (Jira + Confluence chung, xem `atlassian-sync.md` Mục 3). KHÔNG còn `docs/_shared/jira-map.md` / `confluence-map.md` rời.

## HARD GATE refuse on stale

`/jira --push` REFUSE nếu bất kỳ target US `status: stale`. No override flag. Dry-run vẫn cho phép với stale (read-only OK).‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍


<!-- wm:deb1cafe78b51baaf650c76e2fceb009 -->
<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền ai4ba.com</sub>
