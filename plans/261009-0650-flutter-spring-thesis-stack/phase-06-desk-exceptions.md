---
title: "Phase 6: Trả, phạt, hư hỏng và mất"
status: todo
---

# Phase 6: Trả, phạt, hư hỏng và mất

## Overview

Khép vòng quầy: trả quá hạn, sổ phạt tối thiểu, thu tiền mặt, hư hỏng và mất sách. Feature: `return-handling`, `overdue-fines`, `damage-lifecycle`, `lost-handling`, `fine-collection-basic`.

## Requirements

- [ ] Trả quá hạn tính phạt theo quy định phase 3 và ghi sổ phạt.
- [ ] Người đọc còn phạt chưa thu thì bị chặn mượn mới.
- [ ] Thủ thư thu tiền mặt, ghi nhận đã thu. Chưa làm miễn giảm hay biên nhận nâng cao.
- [ ] Báo hư hỏng chặn lưu thông ngay, kèm ảnh nén khoảng 500 KB trên volume VPS. Duyệt hư hỏng để bản sao không kẹt trạng thái chờ.
- [ ] Ghi nhận mất và tìm lại theo trạng thái trong tài liệu domain.

## Implementation Steps

1. Job hoặc lệnh tính quá hạn mỗi ngày và khi trả. Một khoản phạt một phiếu, không nhân đôi khi job chạy lại.
2. API thu phạt tiền mặt. Service mượn đọc sổ phạt trước khi cho mượn.
3. Upload ảnh: API nhận file, ghi volume, DB lưu URL. App chọn ảnh từ máy.
4. Luồng duyệt hư hỏng cho quản trị hoặc thủ thư đúng PRD.
5. API mất và tìm lại, test chuyển trạng thái cấm.

## Todo

- [ ] Trả quá hạn tạo đúng một khoản phạt.
- [ ] Mượn mới bị chặn khi còn phạt chưa thu.
- [ ] Ảnh hư hỏng mở được bằng URL sau khi upload.
- [ ] Bản sao chờ duyệt không mượn được. Sau duyệt, trạng thái đi tiếp đúng sơ đồ.

## Success Criteria

Test API phủ bốn ý trên và xanh. Trên app, thủ thư trả một sách quá hạn rồi thấy khoản phạt.

## Risk Assessment

Ảnh lớn làm đầy đĩa VPS. Từ chối file trên 500 KB sau nén, và không lưu bytea trong PostgreSQL.

## Security Considerations

URL ảnh không public vô hạn. Tải ảnh qua API có kiểm tra vai trò, hoặc URL khó đoán và không liệt kê thư mục.
