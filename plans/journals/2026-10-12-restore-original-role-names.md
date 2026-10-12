---
title: restore-original-role-names
date: 2026-10-12
summary: "Khôi phục tên role nghiệp vụ gốc trên toàn hệ thống, giữ quyền và bảo vệ phiên cũ."
---

# restore-original-role-names

## Kết quả

Đồng bộ Người đọc (READER), Nhân viên (STAFF), Thủ thư (LIBRARIAN) theo yêu cầu ngày 2026-10-12, giữ quyền của các nhóm tương ứng. Cập nhật Flutter, API, dữ liệu demo, wireframe, tài liệu và chỉ mục KG. Thay quyết định đổi tên tại DEC-SF-01.

## Chuyển đổi và kiểm chứng

V4 lưu snapshot id/role/display_name trước khi chuyển ADMIN thành LIBRARIAN và LIBRARIAN cũ thành STAFF trong một câu CASE. JWT yêu cầu roleVocabulary=source để phiên Nhân viên cũ không nhận quyền Thủ thư. Migration kiểm thử cả chạy lại, giữ tên thật và trạng thái khóa.

Maven verify với JDK 21: 11 test qua và build JAR thành công. Flutter: 12 test qua, analyze không có vấn đề. Simplifier đọc các test migration/JWT và không cần sửa. Giữ mọi thay đổi có sẵn của người dùng.

## Giới hạn vận hành

Docker daemon, PostgreSQL và API local không chạy; chưa migrate dữ liệu thật. docs/_shared/role-names.md ghi hướng dẫn pg_dump, nâng cấp đồng bộ và rollback. Người dùng đăng nhập lại sau nâng cấp. Không commit hoặc push.

> Historical work record — not durable authority. Prefer docs/specs/ADRs for current decisions.
