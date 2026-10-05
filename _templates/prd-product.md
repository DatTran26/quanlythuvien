---
type: prd-product
status: draft
updated: {{date}}
links: []
---

# {{product_name}} — Product Requirements Document (project-level)‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

## 1. One-line Pitch‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

{{pitch}}

## 2. Problem & Why Now‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

{{problem}}

- __Vấn đề cốt lõi:__ {{core_problem}}
- __Ai đang đau:__ {{who_hurts}}
- __Giải pháp thay thế hiện tại:__ {{existing_alternatives}}
- __Why now:__ {{why_now}}

## 3. Target Users‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

| Nhóm người dùng | Vai trò (primary/secondary) | Job-to-be-done | Bối cảnh sử dụng |
|---|---|---|---|
| {{user_group}} | {{role}} | {{jtbd}} | {{context}} |

*Ai KHÔNG phải người dùng: {{non_users}}*

## 4. Value Proposition & Differentiator‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

{{value_prop}}

- __Giá trị cốt lõi (1 câu):__ {{core_value}}
- __Vì sao chọn mình thay vì giải pháp cũ:__ {{why_us}}
- __Lợi thế khác biệt:__ {{unfair_advantage}}

## 5. Goals & Non-Goals

__Mục tiêu (in-scope):__
- {{goal}}

__Ngoài phạm vi (non-goals / out-of-scope):__
- {{non_goal}}

## 6. Capability Themes

| Theme | Mô tả | Features thuộc theme |
|---|---|---|
| {{theme}} | {{theme_desc}} | {{theme_features}} |

## 7. Feature Map

### Luồng người dùng tổng quan

1) {{journey_step}} → `{{related_feature_slug}}`‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

### Bảng Feature Map

| # | Tính năng | Slug | Theme | Persona | Ưu tiên (MoSCoW) | Phụ thuộc | Chi tiết hóa |
|---|---|---|---|---|---|---|---|
| 1 | {{feature_name}} | `{{feature_slug}}` | {{theme}} | {{persona}} | {{moscow}} | {{feature_deps}} | ⬜ chưa |

### 7.1 {{feature_name}} — `{{feature_slug}}`

{{feature_desc_what_why_outcome}}

__Phục vụ job:__ {{feature_serves_jtbd}}

__Phạm vi v1:__ {{scope_in}}
__Chưa làm:__ {{scope_out}}

__Luồng chính:__
1) {{flow_step}}

__Rủi ro chính:__ {{feature_risk}} · __Đo thành công:__ {{feature_success_metric}}
__OQ riêng:__ {{feature_oq_refs}}

## 8. Success Metrics

| Vai trò | Chỉ số | Baseline | Target | Mốc thời gian |
|---|---|---|---|---|
| North Star | {{north_star}} | {{ns_baseline}} | {{ns_target}} | {{ns_horizon}} |
| Input | {{input_metric}} | {{input_baseline}} | {{input_target}} | {{input_horizon}} |
| Guardrail | {{guardrail_metric}} | {{guardrail_current}} | {{guardrail_threshold}} | liên tục |

__Mục tiêu 3 / 6 / 12 tháng:__ {{milestones}}

## 9. Constraints

- __Ngân sách / timeline / team:__ {{constraints_resource}}
- __Ràng buộc tích hợp (chỉ tên hệ thống):__ {{constraints_integration}}
- __Ràng buộc pháp lý / vùng / compliance:__ {{constraints_compliance}}

## 10. Risks & Assumptions

| Rủi ro / Giả định | Loại (value/usability/feasibility/viability) | Tầm quan trọng | Evidence | Khả năng | Hậu quả | Cách phòng |
|---|---|---|---|---|---|---|
| {{risk}} | {{risk_type}} | {{importance}} | {{evidence}} | {{likelihood}} | {{impact}} | {{mitigation}} |

## 11. Open Questions

- [ ] OQ-1: {{open_question}}‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍


<!-- wm:deb1cafe78b51baaf650c76e2fceb009 -->
<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền hoangphan.blog</sub>
