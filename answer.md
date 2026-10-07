# Tổng hợp trao đổi và quyết định User Flow

## 1. Bối cảnh

- Feature: Library Management Platform.
- Tài liệu nghiệp vụ: `docs/features/library-management-platform/`.
- Kế hoạch BA: `plans/261004-1734-library-management-full-ba-workflow/`.
- Giai đoạn hiện tại: Phase 5 — user flow và HTML wireframe.
- User flow là nguồn chia flow chung cho bước wireframe sau này.
- Thiết bị chính đã chọn cho màn hình quầy và quản trị: desktop 1024px.
- Reader portal R2 theo hướng mobile-first nhưng vẫn là đề xuất, chờ Product Owner duyệt qua OQ-LMP-015.

## 2. Sáu quyết định nghiệp vụ ban đầu

### 2.1. Thiết bị mục tiêu

- Xác nhận desktop 1024px là thiết bị chính cho Thủ thư và Quản trị viên.
- Reader portal R2 đề xuất responsive mobile-first.
- Mobile-first cho portal không được coi là đã phê duyệt cho đến khi OQ-LMP-015 được người có thẩm quyền duyệt.

### 2.2. Phạm vi user flow

- Vẽ master user flow phủ toàn bộ 10 use case hiện có, sau đó tách thành 11 flow nghiệp vụ.
- Mỗi flow phải có nhãn release R0, R1A, R1B hoặc R2.
- Reservation và các chức năng R2 vẫn xuất hiện nhưng phải ghi rõ `future/not in pilot`.
- Release boundary trong decision register vẫn là `PROPOSAL/Open` cho tới khi Product Owner duyệt; không được gọi là approved sớm.

### 2.3. Người đọc và self-service

- R1A không có màn hình self-service riêng cho Người đọc; nghiệp vụ R1A được phục vụ tại quầy.
- Gia hạn không thuộc R1A. Gia hạn tại quầy thuộc R1B; portal đầy đủ thuộc R2.
- FR-R09 “Người đọc xem công nợ” đang ở R1B nhưng chưa có UC/screen owner.
- OQ-LMP-016 phải chốt một trong hai phương án: tạo màn reader tối thiểu ở R1B hoặc chuyển FR-R09 sang portal R2.

### 2.4. Quên và đặt lại mật khẩu

- Account recovery/forgot-reset phải có trong user flow vì CAP-IDENT và FR-C02 thuộc R0.
- Forgot/reset chỉ áp dụng trực tiếp nếu identity model là local account.
- Nếu dùng SSO/external IdP, hệ thống chuyển người dùng sang provider.
- Cơ chế cụ thể tham chiếu OQ-LMP-007; không tạo OQ riêng chỉ cho reset mechanism.

### 2.5. Dashboard sau đăng nhập

- Đăng nhập thành công đi vào `dashboard-home`, không đi thẳng `circulation-desk`.
- Dashboard R0 chỉ gồm điều hướng theo vai trò và quick actions.
- Với Thủ thư, các hành động Mượn, Trả và Tra cứu phải nổi bật.
- Không tự thêm widget quá hạn, hold hoặc fine nếu chưa có requirement nguồn.
- Báo cáo quá hạn dẫn sang RP-04 từ R1A; hold chỉ có từ R2; KPI nghiệp vụ nằm ở `report-dashboard` theo release.

### 2.6. Reports

- `report-dashboard` là màn báo cáo nghiệp vụ độc lập, không phải dashboard import.
- `import-report` chỉ phục vụ dry-run và reconciliation của import.
- R1A gồm RP-01 tổng quan tài khoản, RP-02 tình trạng kho và RP-04 quá hạn.
- R2 gồm RP-03 mượn–trả theo thời gian, RP-05 phạt, RP-06 sách được quan tâm và RP-07 hư hỏng/thanh lý.
- Quản trị viên là actor có căn cứ nguồn. Quyền Thủ thư quầy xem báo cáo chờ OQ-LMP-017.

## 3. Cấu trúc user flow đã chốt

User flow cuối gồm 11 flow và 38 màn hình:

1. `auth-flow` — R0.
2. `catalog-admin-flow` — R0/R1A.
3. `reader-admin-flow` — R0/R1B.
4. `checkout-flow` — R1A.
5. `return-renewal-flow` — trả R1A, gia hạn R1B.
6. `reservation-flow` — R2, future.
7. `fine-payment-flow` — R1A/R1B.
8. `damage-lost-found-flow` — R1A/R1B.
9. `notification-audit-flow` — R0/R1A/R1B.
10. `admin-import-flow` — R0.
11. `reports-flow` — R1A/R2.

Số màn hình được tính là 36 màn duy nhất từ UC index, đã gồm `session-expired`, cộng `forgot-password` và `reset-password`, tổng cộng 38 màn.

## 4. Quy tắc và sửa đổi theo từng flow

### 4.1. Auth

- Sai credential, tài khoản inactive hoặc locked: E-LMP-002.
- Session expired hoặc step-up required: E-LMP-017.
- E-LMP-016 chỉ dùng cho thiếu quyền field nhạy cảm; sau đăng nhập phải mask/block field phù hợp.
- Forgot/reset gắn nhãn `PROPOSAL — chỉ áp dụng nếu identity=local`.
- SSO/IdP chuyển sang provider theo OQ-LMP-007.

### 4.2. Catalog admin

- FR-LMP-001/002 thuộc R0; FR-LMP-003 tra cứu khả dụng thuộc R1A.
- Thủ thư quầy CRUD catalog là đề xuất lệch ma trận nguồn và cần Domain Approver duyệt.
- Bao phủ E-LMP-001/002/003/005/015 và soft-delete theo BR-LMP-017.

### 4.3. Reader admin

- CRUD hồ sơ thuộc R0; khóa/mở người đọc thuộc R1B.
- Cả Thủ thư và Quản trị viên được khóa/mở người đọc.
- Chỉ tạo/xóa tài khoản bị giới hạn cho Quản trị viên.

### 4.4. Checkout

- Copy unavailable hoặc `ON_HOLD` của người khác: E-LMP-004.
- Reader locked, quá hạn, nợ vượt ngưỡng hoặc vượt loan limit: E-LMP-007.
- E-LMP-003 chỉ dùng khi mã Reader/Copy không tồn tại hoặc trùng business key.
- Concurrent conflict: E-LMP-005.
- Reservation held chỉ có hiệu lực từ R2.
- Checkout commit tại `checkout-review`, giữ pattern của UC index.

### 4.5. Return và renewal

- Trả sách thuộc R1A; gia hạn thuộc R1B.
- Quá hạn có thể tạo fine; hư hỏng chuyển sang damage report; mất chuyển sang lost-found.
- Gia hạn bị chặn khi hết lượt hoặc có reservation đang giữ từ R2.
- Bao phủ E-LMP-004/005/007/015 với feedback và recovery tương ứng.

### 4.6. Reservation

- Toàn bộ reservation thuộc R2 và được đánh dấu future.
- Hold expiry dùng E-LMP-008; ngưỡng tham chiếu OQ-LMP-010; hết hạn phải queue advance.
- Bao phủ E-LMP-005/008/015.
- Notify fail E-LMP-012/018 không làm hỏng business transaction chính.
- Nút Hủy phải được neo vào `reservation-queue` và `reservation-pickup`.
- Có empty state cho queue rỗng.

### 4.7. Fine payment

- R1A chỉ gồm ledger, assessment và payment tiền mặt tối thiểu.
- R1B gồm financial events nâng cao, receipt đầy đủ, waiver, adjustment, reversal, refund và reconciliation.
- Chỉ bật phần nâng cao sau khi OQ-LMP-005/009 và DEC-D3-04 được `Resolved + Approved`.
- Bao phủ E-LMP-005/006/009/010/013/015/016.
- Waiver, adjustment và refund yêu cầu step-up re-auth E-LMP-017.

### 4.8. Damage, lost và found

- R1A gồm báo hư hỏng, disposition tối thiểu và ghi nhận mất.
- R1B gồm found-after-lost, restore copy và đối soát nghĩa vụ.
- Thanh lý trực tiếp hoặc sửa không thành vẫn là PROPOSAL theo DEC-D3-07.
- Bao phủ E-LMP-001/003/011/015.
- Thanh lý yêu cầu step-up re-auth.

### 4.9. Notification và audit

- Audit capture thuộc R0.
- Notify tối thiểu thuộc R1A.
- Audit log, history timeline và notification viewer đầy đủ thuộc R1B.
- E-LMP-012 là delivery failure.
- E-LMP-018 là outbox/queue hoặc channel unavailable.
- E-LMP-013 là audit write failure và phải rollback hành động nhạy cảm.
- E-LMP-016 xử lý field-level access.

### 4.10. Admin import

- Thứ tự đúng: upload → dry-run → import-report → sửa/chạy lại → commit toàn batch → sinh QR → đối soát vật lý → reconciliation report.
- Không đặt reconcile trước commit.
- Bao phủ E-LMP-001/002/005/006/014/016.
- Override commit khi dry-run chưa pass yêu cầu step-up re-auth.
- OQ-LMP-018 xác định ai được approve override, điều kiện và bằng chứng cần có; gate là GATE-MIG.

### 4.11. Reports

- R1A hiển thị RP-01/02/04; R2 hiển thị RP-03/05/06/07.
- Có empty state cho `report-dashboard` ở R1A.
- Quyền Thủ thư quầy xem report tham chiếu OQ-LMP-017.

## 5. Quy ước UX đã chốt qua reviewer

- Lỗi critical như E-LMP-005/009/013 dùng modal chặn.
- Lỗi minor/major dùng inline feedback phù hợp ngữ cảnh.
- E-LMP-002 dùng banner hoặc redirect an toàn.
- UI có thể ẩn action theo RBAC như một fallback PROPOSAL, nhưng backend vẫn phải kiểm tra E-LMP-002 theo defense-in-depth.
- Các tác vụ nhạy cảm phải có nhánh step-up re-auth: financial override, thanh lý và import override.
- Flow phải phủ happy, error, edge, empty, permission và recovery.
- Mỗi cạnh Mermaid phải có dòng tương ứng trong transition table để wireframe không tự suy lại điều hướng.

## 6. Open Questions mới

- OQ-LMP-015: Reader portal R2 có chính thức mobile-first không? Owner: Product Owner. Gate: device/layout approval trước wireframe portal.
- OQ-LMP-016: FR-R09 dùng màn reader tối thiểu ở R1B hay chuyển sang portal R2? Owner: Product Owner. Gate: chốt release/UI owner trước wireframe reader.
- OQ-LMP-017: Thủ thư quầy có quyền xem reports không? Owner: Domain Approver. Gate: chốt permission trước wireframe/report acceptance.
- OQ-LMP-018: Ai approve commit import khi dry-run chưa pass, điều kiện và bằng chứng override là gì? Owner: Data Owner + Thủ thư trưởng/Product Owner. Gate: GATE-MIG.

Các OQ-LMP-015..018 phải nằm trong nguồn canonical `docs/features/library-management-platform/srs/library-management-platform-spec.md` Mục 12; user flow chỉ tham chiếu lại.

## 7. Trạng thái phê duyệt

- Preview v1 bị yêu cầu sửa do sai mapping error, release split, quyền actor, thứ tự import và phép đếm màn hình.
- Preview v2 bị yêu cầu sửa vòng cuối do gán nhầm OQ-LMP-009 cho import override và còn thiếu coverage error/recovery.
- UX Reviewer trả verdict `revise`; toàn bộ blocking và warning được báo là đã xử lý.
- HARD STOP cuối đã được trả lời `Chốt`.
- Được phép ghi `docs/features/library-management-platform/srs/library-management-platform-userflow.md` với `stage: flow-approved` và `flow_hash`.
- Sau khi ghi phải chạy Mermaid verify; chỉ hoàn tất khi exit code bằng 0.
- Nếu Mermaid được sửa trong quá trình verify thì phải tính lại `flow_hash`.
- Quy trình dừng ở user flow; không tự chuyển sang wireframe trong cùng bước.

## 8. Tài liệu nguồn chính

- `docs/features/library-management-platform/srs/library-management-platform-spec.md`
- `docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md`
- `docs/features/library-management-platform/usecases/uc-access-control.md`
- `docs/features/library-management-platform/usecases/uc-catalog-admin.md`
- `docs/features/library-management-platform/usecases/uc-reader-admin.md`
- `docs/features/library-management-platform/usecases/uc-checkout.md`
- `docs/features/library-management-platform/usecases/uc-return-renewal.md`
- `docs/features/library-management-platform/usecases/uc-reservation.md`
- `docs/features/library-management-platform/usecases/uc-fine-payment.md`
- `docs/features/library-management-platform/usecases/uc-damage-lost-found.md`
- `docs/features/library-management-platform/usecases/uc-notification-audit.md`
- `docs/features/library-management-platform/usecases/uc-admin-import.md`
- `docs/_product/decision-register.md`
- `docs/_product/priority-crosswalk.md`
- `docs/_product/roadmap.md`
- `plans/261004-1734-library-management-full-ba-workflow/phase-05-ux-flow-and-html-wireframe.md`
