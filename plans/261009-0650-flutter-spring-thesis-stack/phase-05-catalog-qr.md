---
title: "Phase 5: Danh mục, QR và người đọc"
status: todo
---

# Phase 5: Danh mục, QR và người đọc

## Overview

Thủ thư và quản trị quản lý đầu sách, bản sao, QR. Người đọc tra cứu và xem thẻ của mình. Feature: `catalog-admin`, `copy-inventory`, `reader-onboarding`, phần tra cứu của `reader-self-service`.

## Requirements

- [ ] CRUD đầu sách, danh mục, vị trí kệ, cờ được mượn về.
- [ ] Mỗi bản sao có mã QR. API tra cứu theo mã trả về trong dưới 1 giây trên VPS đang thức, với bộ seed nhỏ của đồ án.
- [ ] App quét QR bằng camera và có ô nhập mã tay.
- [ ] Người đọc tự đăng ký ở trạng thái chờ. Chỉ mượn sau khi thủ thư kích hoạt.
- [ ] Người đọc xem thẻ của mình và danh sách phiếu mượn của mình (`reader-self-service`).
- [ ] Màn mượn ở khu thủ thư gọi API phase 3 sau khi quét đúng bản sao sẵn sàng.

## Implementation Steps

1. Migration title, category, copy code, shelf. Gắn copy đã có ở phase 3 vào title.
2. API tạo bản sao sinh mã. Payload QR là mã bản sao, không nhét dữ liệu nghiệp vụ dài.
3. `GET /api/copies/by-code/{code}` dùng cho cả camera và nhập tay.
4. API đăng ký và kích hoạt người đọc. Service mượn từ chối reader chưa active.
5. Flutter: form đầu sách ngắn, nút quét, ô nhập tay, màn kết quả, nút cho mượn.

## Todo

- [ ] Tạo một đầu sách và hai bản sao trên điện thoại quản trị.
- [ ] Quét QR ra đúng bản sao.
- [ ] Nhập tay khi không quét vẫn ra cùng bản sao.
- [ ] Người đọc chờ kích hoạt bị từ chối lúc mượn.

## Success Criteria

Luồng quét → thấy sách → cho mượn chạy trên điện thoại với API public. Test API từ chối reader chưa kích hoạt xanh.

## Risk Assessment

Form quản trị trên điện thoại dễ dài. Mỗi form một việc, không gộp nhập kho và import trên cùng màn. Import để phase 8.

## Security Considerations

Người đọc chỉ xem đầu sách và bản sao của chính mình ở phần thẻ và phiếu. Sửa danh mục thuộc librarian hoặc admin theo PRD feature tương ứng.
