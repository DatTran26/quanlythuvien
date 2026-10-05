---
paths:
  - ".claude/agents/**"
---

# Agent Conventions‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

> Patterns cho review agents trong vault. Mọi agent ở `.claude/agents/<name>.md` tuân rules này.

## Agent file structure‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

```yaml
---
name: senior-ba
description: 1-line summary of agent's expertise và when to use
expertise: [completeness, edge-cases, requirement-clarity]
review_targets: [srs, urd, brd, prd, srs-flows, srs-screen, brainstorm, user-story, use-case]
output_format: structured-findings-v1
---

# {Persona name}

> {Persona definition: 1 paragraph establishing voice, experience, perspective.}

## Review approach

{Bullet list HOW agent reviews — scan first, mid, last.}

## Severity rubric

{Definitions BLOCKING / WARNING / SUGGESTION specific to this agent's domain.}

## Common findings

{Typical issues agent flags — checklist style.}

## What NOT to flag

{Out-of-scope domains; explicit để prevent overlap với other agents.}

## Output format

Follow [review-format.md](./review-format.md) v1 strictly.

## Reference materials

When reviewing, agent reads:
- Target doc (provided by orchestrator)
- @.agents-standard/rules/{relevant-rule}.md
- @docs/features/{feature}/... (runtime resolved by phase review của skill sinh doc — placeholder `{feature}` thay bằng target's frontmatter feature value)
```

## Roles + review_targets‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

| Role | `name` | Phase | Domain |
|------|--------|-------|--------|
| Senior BA | `senior-ba` | 4 | Completeness, edge cases, requirement clarity |
| Product Owner | `po-reviewer` | 4 | Business value, scope creep, prioritization |
| Product Manager | `pm-reviewer` | 4 | Cross-feature consistency, dependencies, timeline |
| UI/UX | `uxui-reviewer` | 4 | Screen flows, states (loading/empty/error), consistency |
| QA | `qa-reviewer` | 4 | AC testability, missing test cases, coverage |
| Tech | `tech-reviewer` | 4 | Feasibility, performance, security implications |
| Change Tracker | `change-tracker` | 6 | Impact analysis cho /cr |
| Gap Analyst | `gap-analyst` | 6 | Traceability, orphaned reqs, stale chain |

## Path conventions (placeholder resolution)‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

Agent reference materials dùng path placeholder `{feature}` — resolved bởi phase review khi spawn agent:

* `@docs/features/{feature}/{feature}-urd.md` → resolves to target doc's `feature` frontmatter value.
* `@docs/_shared/...` → no resolution, project-level shared.

Agent KHÔNG được hardcode feature slug (vd `@docs/features/payment/payment-urd.md`) — luôn dùng placeholder.

Nếu target không có `feature:` frontmatter, phase review skip reference đó hoặc prompt user pick feature context.

## Guidelines‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

* __One agent = one persona.__ Đừng merge senior-ba + qa — different thinking.
* __Agents critique, không write content.__ Không propose new sections; chỉ propose edits to specific lines.
* __Stay in-scope.__ Senior BA không flag tech feasibility — đó là tech-reviewer's job.
* __No double-counting.__ Nếu BLOCKING tồn tại, không repeat WARNING. Pick severity cao nhất.
* __Findings atomic.__ Mỗi finding 1 thing, 1 suggested fix. Compound findings split.
* __Agent KHÔNG dùng directly Edit tool.__ phase review orchestrator áp dụng fixes (auto-fix).
* __Stale chain awareness__ (Phase 6+): agents nên check `status: stale` của target và `docs/_shared/staleness.md` để flag cascade.‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍


<!-- wm:deb1cafe78b51baaf650c76e2fceb009 -->
<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền hoangphan.blog</sub>
