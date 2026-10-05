---
title: "Phase 6: Backlog và acceptance criteria"
status: pending
priority: P1
effort: "1–2 review cycles"
dependencies: [4, 5]
---

# Phase 6: Backlog và acceptance criteria

## Mục tiêu

Dùng `userstory` và `ac` để tạo backlog theo vertical outcome, có AC declarative và sẵn sàng refinement mà không biến story thành bản sao của màn hình hay test case.

## Yêu cầu

- Story truy vết về FR/use case/flow/screen và mang một outcome có giá trị.
- Áp dụng INVEST và Definition of Ready; story quá lớn phải tách theo outcome/flow/rule, không tách cơ học theo layer.
- Phân biệt fact, inference và OQ; không biến assumption thành requirement.
- AC dùng Given/When/Then, mô tả behavior/obligation; không chứa dữ liệu test chi tiết hay bước thao tác dư thừa.
- Mỗi story có priority/release, dependency, rule refs, error refs và AC ID ổn định.

## File tác động

- Tạo `docs/features/library-management-platform/userstories/library-management-platform-story-index.md` làm master metadata/readiness source.
- Tạo các `docs/features/library-management-platform/userstories/us-*.md`.
- Ghi AC trực tiếp trong story theo quy ước skill `ac`.
- Cập nhật decision register nếu backlog làm lộ scope/rule chưa quyết định.

## Các bước thực hiện

1. Chạy `userstory` theo từng value stream đã duyệt; tạo story map và index trước.
2. Sinh story vertical slice; gắn nguồn FR/UC/flow/screen và release owner.
3. Chạy INVEST/DoR review; tách story có nhiều outcome hoặc phụ thuộc chưa quản lý.
4. Chạy `ac` trên từng story ready; phủ happy, validation, permission, boundary, concurrency và recovery phù hợp.
5. Kiểm tra duplicate outcome, orphan requirement và AC mâu thuẫn BR/Error Matrix.
6. Review backlog với BA/PO/QA/Tech; ghi readiness state thay vì ép mọi story thành Ready.
7. Khi phát hiện decision mới, tạo impact matrix; mark stale, sửa và re-approve toàn bộ artifact bị ảnh hưởng trước khi tiếp tục.

## Todo

- [ ] Tạo story map và index.
- [ ] Sinh story cho toàn bộ P0 scope.
- [ ] Chạy INVEST/DoR và dependency review.
- [ ] Sinh AC có ID cho story đủ điều kiện.
- [ ] Lập danh sách Not Ready với lý do/owner/gate.
- [ ] Xác nhận stale count bằng 0 hoặc có deferred approval rõ ràng.

## Verification

- Mỗi P0 FR có ít nhất một story; mỗi story có ít nhất một source requirement.
- Không có hai story cùng outcome và điều kiện kích hoạt mà không nêu lý do.
- AC không dùng ngôn ngữ implementation-specific nếu SRS không yêu cầu.
- Story Not Ready không được chuyển sang Phase 7 như đầu vào test hoàn chỉnh.

## Kịch bản kiểm tra tối thiểu

| Kiểm tra | Kỳ vọng |
|----------|---------|
| Một story chứa checkout + return + fine | Tách theo outcome và dependency |
| AC chỉ nói “hệ thống hoạt động đúng” | Viết lại thành observable outcome |
| Rule retention còn Open | Story/AC liên quan giữ Not Ready và chỉ rõ decision gate |
| Permission/error chưa có AC | Bổ sung từ SRS Error Matrix/BR |

## Rủi ro và an toàn

- Không đưa credential/PII thật vào example AC.
- Không để UI hiện tại vô tình thu hẹp requirement nghiệp vụ đa kênh.

## Tiêu chí hoàn tất

- [ ] P0 FR được phủ bởi story và AC có ID.
- [ ] Story đáp ứng INVEST hoặc có lý do ngoại lệ rõ.
- [ ] Không có duplicate outcome/orphan source.
- [ ] Not Ready register có owner và unblock gate.

## Bước kế tiếp

Dùng SRS + story + AC đã sẵn sàng để sinh checklist và test case ở Phase 7.
