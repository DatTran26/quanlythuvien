# BA skills for QuanLyThuVien

Tài liệu nghiệp vụ của feature nằm tại `docs/features/{feature}/`.

## Skills

- `/brainstorm`, `/srs`, `/user-flow`
- `/wireframe-html`, `/wireframe-ascii`
- `/userstory`, `/ac`
- `/test-checklist`, `/test-cases`

## Support skills

- `/kg`, `/prototype-html`, `/figma`

## Runtime locations

- Claude Code: `.claude/skills/`
- Codex/shared agents: `.agents/skills/`
- Cursor: `.cursor/skills/`
- Shared templates: `_templates/`

## Required workflow

Các skill phải tuân rule và approval gate tại cây runtime tương ứng.
Không dùng đường dẫn BA-Kit gốc `docs/{feature}/`; dự án này dùng
`docs/features/{feature}/`.

HTML wireframe mặc định dùng khung Mobile 375 khi feature không chỉ định
thiết bị khác trong user-flow đã duyệt.

KG và Mermaid cần Node.js 18+. Mermaid render verification cần `mmdc`
và Chrome/Chrome Headless Shell.

Hook của Claude, Codex và Cursor dùng chung
`node .agents/hooks/ba-kit-run.mjs`.
