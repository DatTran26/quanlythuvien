---
title: "Phase 7: Đặt trước, gia hạn và thông báo"
status: todo
---

# Phase 7: Đặt trước, gia hạn và thông báo

## Overview

Phần P1 còn lại của vòng sách và thông báo. Feature: `renewal`, `reservation`, `notification-core`, `fine-collection-adv`.

## Requirements

- [ ] Gia hạn tại quầy và trên app người đọc khi còn lượt và không có người đặt trước.
- [ ] Đặt trước, hàng chờ, giữ sách, hết hạn giữ. Bản sao đang giữ không cho người khác mượn.
- [ ] Thông báo trong app cho sự kiện chính (sắp hết hạn, sẵn sàng lấy, phạt mới).
- [ ] Một SMTP cho email mẫu. Nếu SMTP lỗi, bản ghi thông báo trong app vẫn được tạo.
- [ ] Thu phạt nâng cao: biên nhận, miễn hoặc điều chỉnh theo đúng vai trò trong PRD.

## Implementation Steps

1. Bảng reservation và quy tắc hết hạn giữ chạy bằng scheduler Spring.
2. Gia hạn kiểm tra hàng chờ trước khi cộng ngày.
3. Bảng notification. Mỗi sự kiện ghi một dòng. Màn người đọc liệt kê thông báo của mình.
4. Mail sender bọc try/catch, lỗi SMTP ghi log và không rollback nghiệp vụ chính.
5. API miễn hoặc điều chỉnh phạt ghi lý do và người thực hiện.

## Todo

- [ ] Gia hạn bị từ chối khi đã có người đặt trước.
- [ ] Hết hạn giữ trả bản sao về trạng thái cho mượn.
- [ ] Người đọc thấy thông báo trong app sau một sự kiện mẫu.
- [ ] Miễn phạt bởi đúng vai trò, người đọc không gọi được API này.

## Success Criteria

Bốn test trên xanh. Demo được một vòng: đặt trước → sách trả về → thông báo trong app → giữ → hết hạn hoặc cho mượn.

## Risk Assessment

Scheduler và mượn cùng đụng bản sao. Dùng cùng service đổi trạng thái và cột version của phase 3, không viết câu SQL cập nhật trạng thái riêng.

## Security Considerations

Người đọc chỉ hủy đặt trước của mình và chỉ đọc thông báo của mình. Miễn phạt là thao tác admin hoặc vai trò PRD quy định, có lý do bắt buộc.
