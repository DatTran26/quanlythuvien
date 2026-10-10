---
title: "Phase 8: Import, báo cáo và nhật ký"
status: todo
---

# Phase 8: Import, báo cáo và nhật ký

## Overview

Đủ các màn quản trị còn lại trên điện thoại, với file nhỏ và dữ liệu có sẵn. Feature: `data-import`, `ops-reports`, `trend-reports`, phần audit của `ops-foundation`, `notification-audit-ui`.

## Requirements

- [ ] Import Excel đầu sách và bản sao có bước xem trước (dry-run) rồi mới ghi.
- [ ] Báo cáo kho và danh sách quá hạn. Xuất Excel. PDF dùng cùng bộ lọc.
- [ ] Báo cáo xu hướng mượn–trả, phạt, hư hỏng, sách được quan tâm, lọc theo khoảng ngày.
- [ ] Mọi tạo, sửa, xóa nghiệp vụ ghi một dòng audit: ai, lúc nào, việc gì, đối tượng nào.
- [ ] Quản trị xem được nhật ký trên app.

## Implementation Steps

1. Thêm Apache POI. Endpoint dry-run trả lỗi từng dòng, không ghi DB. Endpoint xác nhận ghi trong transaction.
2. App chọn file `.xlsx` nhỏ. Màn xem trước hiện số dòng lỗi.
3. Một lớp `AuditWriter` gọi trong service sau khi thao tác thành công. Không dùng AOP.
4. Query báo cáo theo khoảng ngày UTC+7. Excel tải về điện thoại. PDF sau khi Excel đã đúng số liệu.
5. Màn nhật ký phân trang, lọc theo ngày và loại việc.

## Todo

- [ ] File mẫu hợp lệ import xong đúng số bản sao.
- [ ] File có một dòng sai: dry-run báo dòng đó và không ghi dòng nào.
- [ ] Báo cáo quá hạn ra đúng phiếu seed.
- [ ] Một lần mượn tạo một dòng audit xem được trên app.

## Success Criteria

Bốn mục todo có test API hoặc kiểm tra trên app. OpenAPI có tag import, report, audit.

## Risk Assessment

PDF và Excel trên điện thoại dễ làm vỡ buổi demo nếu file lớn. Kịch bản bảo vệ dùng file dưới 20 dòng và một báo cáo đã lọc sẵn.

## Security Considerations

Chỉ admin hoặc librarian được import và xem audit, theo PRD từng feature. File upload giới hạn dung lượng. Không thực thi macro Excel.
