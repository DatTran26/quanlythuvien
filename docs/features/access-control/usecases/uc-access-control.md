---
type: usecase
feature: access-control
status: draft
updated: 2026-10-08
links:
  - docs/features/access-control/usecases/access-control-usecase-index.md
  - docs/features/access-control/srs/access-control-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
---

# Use Case: Xác thực, phân quyền và kiểm soát phiên (uc-access-control)

> Scope: access-control · Level: sea
> Screens: `access-login`, `forgot-password`, `reset-password`, `dashboard-home`, `session-expired` · Release: R0 (FR-access-control-001, FR-access-control-002)
> **Lưu ý Open:** mô hình identity (local account / SSO / external IdP) chưa chốt — **OQ-access-control-001**. Nội dung xác thực dưới đây viết theo mô hình local account là **PROPOSAL**; các quy tắc ủy quyền (BR-core-004) và hành vi phiên (FR-access-control-002) độc lập mô hình identity.

## Primary Actor

Thủ thư / Quản trị viên / Người đọc — mọi actor cần xác thực trước khi dùng chức năng. Hệ thống là actor phụ thực thi quyết định truy cập.

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Bảo mật/pháp chế | PII mask theo quyền (NFR-core-004); mọi từ chối truy cập có audit; retention/deletion chưa định nghĩa — OQ-core-003 (non-waivable trước GATE-GNG) |
| Thủ thư trưởng (domain approver) | Least privilege: actor chỉ thấy và làm đúng phạm vi vai trò được cấp |
| Thủ thư (vận hành quầy) | Hết phiên/step-up không làm mất dữ liệu đã lưu hoặc ngữ cảnh làm việc an toàn |

## Trigger

Actor mở ứng dụng hoặc gọi một chức năng yêu cầu xác thực/ủy quyền — bao gồm sau khi quét QR làm locator (QR không phải credential, BR-copy-inventory-001).

## Preconditions

- Tài khoản actor tồn tại, ở trạng thái `active` và được gán vai trò. (Open — phụ thuộc OQ-access-control-001.)
- Vai trò, phạm vi dữ liệu và policy truy cập đã được cấu hình qua quản trị cấu hình (FR-policy-config-001).
- UC này được **include** bởi `uc-checkout`, `uc-return`, `uc-fine-cash-payment` (quan hệ include trong UC index): mọi thao tác nghiệp vụ phải đi qua phiên hợp lệ và kiểm tra quyền.

## Guarantees

- **Minimal Guarantee:** Không lộ dữ liệu hoặc quyền khi bị từ chối; mọi access attempt bị từ chối được audit; phiên hết hạn quay về trạng thái an toàn, không mất dữ liệu đã lưu (FR-access-control-002).
- **Success Guarantee:** Actor hợp lệ nhận phiên có phạm vi vai trò; mọi action/field được phán quyết theo ma trận actor × resource × action × field × purpose, deny mặc định (NFR-core-003, BR-core-004); tác vụ nhạy cảm đi qua step-up trước khi thực thi.

## Main Success Scenario

1. Actor mở `access-login` và cung cấp credential (cơ chế credential cụ thể — Open OQ-access-control-001; PROPOSAL: local account).
2. Hệ thống xác thực, tạo phiên gắn vai trò và phạm vi dữ liệu được cấp (FR-access-control-001).
3. Hệ thống điều hướng `dashboard-home`, chỉ render các chức năng actor có quyền object/action (BR-core-004).
4. Khi actor gọi một action, hệ thống kiểm tra quyền actor × resource × action trước khi thực thi (NFR-core-003).
5. Khi render dữ liệu, hệ thống áp quyền field × purpose: field nhạy cảm (PII người đọc, tài chính) bị mask nếu actor thiếu quyền (NFR-core-004).
6. Actor thực hiện tác vụ nhạy cảm → hệ thống yêu cầu step-up xác thực lại (FR-access-control-002); xác thực thành công → tiếp tục tác vụ trong cùng ngữ cảnh.
7. Phiên hết hạn hoặc actor đăng xuất → `session-expired`/đăng xuất an toàn; dữ liệu đã commit được giữ, trạng thái quay về màn an toàn (FR-access-control-002).

## Extensions

**2a. Xác thực thất bại (credential sai / tài khoản không active / tài khoản bị khóa):**
- 2a1. Hệ thống từ chối vào và hiển thị thông báo chung không tiết lộ tài khoản có tồn tại hay không (PROPOSAL — kỹ thuật chống enumeration), map E-core-002 (access denied).
- 2a2. Ghi audit attempt. Recovery: actor nhập lại; luồng quên mật khẩu/kích hoạt phụ thuộc mô hình identity — OQ-access-control-001.

**2b. Vượt ngưỡng đăng nhập sai liên tiếp:**
- 2b1. Sau N lần xác thực thất bại liên tiếp trên cùng tài khoản, hệ thống **khóa tạm** (temporary lockout) và từ chối mọi attempt tiếp theo trong thời gian khóa — hiển thị thông báo chung (E-core-002), không tiết lộ lý do khóa hay trạng thái tài khoản. Ngưỡng N và thời gian khóa là **PROPOSAL — OQ-policy-config-001** (policy value, cấu hình qua FR-policy-config-001; nguồn không định nghĩa ngưỡng này).
- 2b2. Ghi audit mọi attempt và sự kiện khóa tạm; notify chủ tài khoản theo kênh thông báo hiệu lực (PROPOSAL). Recovery: chờ hết thời gian khóa hoặc Quản trị viên mở khóa qua `uc-account-admin`/quản trị tài khoản; cơ chế unlock (tự động theo thời gian vs admin) là Open — OQ-policy-config-001.

**4a. Actor thiếu quyền object/action (ví dụ Người đọc gọi chức năng quầy, Thủ thư gọi chức năng quản trị của Quản trị viên):**
- 4a1. Hệ thống từ chối, hiển thị access denied screen/banner (E-core-002), không thực thi action.
- 4a2. Ghi audit denial kèm actor/action/resource. Recovery: điều hướng về danh sách/màn an toàn actor có quyền; cần quyền thì liên hệ Quản trị viên.

**4b. Quyền hoặc trạng thái tài khoản thay đổi khi phiên đang mở:**
- 4b1. Hệ thống **re-evaluate quyền trên mỗi request**, không tin snapshot quyền lúc đăng nhập: tài khoản vừa bị khóa hoặc vừa bị thu hồi vai trò (bởi Quản trị viên — `uc-account-admin`) thì request kế tiếp bị từ chối ngay (E-core-002), không chờ phiên hết hạn.
- 4b2. Nếu phiên không còn hợp lệ (tài khoản bị khóa/xóa mềm, phiên bị thu hồi) → buộc re-auth, chuyển `session-expired` (E-access-control-001); hành động đang dở không commit. Recovery: actor xác thực lại với trạng thái/quyền mới nhất; quyền mới được cấp có hiệu lực ngay trên request kế tiếp, không cần đăng xuất (PROPOSAL — cơ chế re-evaluation).

**5a. Actor thiếu quyền ở field nhạy cảm:**
- 5a1. Hệ thống render field masked/blocked (E-core-009), không trả dữ liệu thô trong response.
- 5a2. Ghi audit access attempt. Recovery: actor tiếp tục làm việc với phần dữ liệu được phép; escalate xin cấp quyền nếu nghiệp vụ cần (BR-core-004 deny mặc định).

**6a. Step-up xác thực lại thất bại hoặc actor hủy:**
- 6a1. Tác vụ nhạy cảm bị hủy, không thực thi; phiên hiện tại vẫn giữ nếu còn hiệu lực (E-access-control-001).
- 6a2. Ghi audit attempt. Recovery: actor quay lại trạng thái an toàn trước tác vụ; dữ liệu đã lưu không bị ảnh hưởng.

**7a. Phiên hết hạn giữa thao tác (ví dụ đang nhập form ở quầy):**
- 7a1. Hệ thống chuyển `session-expired`/re-auth dialog (E-access-control-001); hành động đang dở không được commit khi chưa xác thực lại.
- 7a2. Sau xác thực lại thành công, quay về trạng thái an toàn; dữ liệu đã commit giữ nguyên, dữ liệu nhập dở được khôi phục nếu còn giữ phía client (PROPOSAL — theo baseline §6.4 interrupted transactions: mất kết nối trước xác nhận không tạo dữ liệu nghiệp vụ).

## Related Requirements

- FR: FR-access-control-001 (đăng nhập và phân quyền), FR-access-control-002 (step-up và session reset); liên quan FR-copy-inventory-002 (QR chỉ là locator — BR-copy-inventory-001).
- NFR: NFR-core-003 (authorization matrix), NFR-core-004 (PII masking/retention — OQ-core-003), NFR-core-005 (audit fail-closed).
- BR: BR-core-004 (deny mặc định), BR-copy-inventory-001 (scan ≠ authorization), BR-core-003 (audit cùng transaction).
- Errors covered: E-core-002, E-core-009, E-access-control-001.
- Open: **OQ-access-control-001** (identity model), OQ-core-003 (retention/privacy), OQ-policy-config-001 (ngưỡng lockout/thời gian khóa — ext 2b).
- UC consumers (include): `uc-checkout`, `uc-return`, `uc-fine-cash-payment`.
- **Nhãn tổng:** FACT = 3 vai trò + ma trận quyền nguồn §2, kiểm tra quyền phía server mọi API (SRC-NFR02), audit mọi thao tác (SRC-NFR04), khóa tạm người đọc theo quyền nguồn (theo mapping spec §2). PROPOSAL = mô hình local account (chờ OQ-access-control-001), step-up/session-reset (FR-access-control-002), lockout khi đăng nhập sai vượt ngưỡng (ext 2b), re-evaluate quyền mỗi request khi trạng thái đổi giữa phiên (ext 4b). Open = ngưỡng lockout và thời gian khóa (OQ-policy-config-001), retention/deletion PII (OQ-core-003), identity model (OQ-access-control-001).

