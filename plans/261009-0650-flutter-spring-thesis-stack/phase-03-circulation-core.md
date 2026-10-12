---
title: "Phase 3: Máy trạng thái bản sao và mượn–trả"
status: todo
---

# Phase 3: Máy trạng thái bản sao và mượn–trả

## Overview

Chốt phần dễ vỡ nhất: trạng thái bản sao, mượn và trả trong transaction, khóa lạc quan. Feature: `policy-config` (bộ quy định chung), `checkout`, phần trả bình thường của `return-handling`. Bản sao tối thiểu để test, danh mục đầy đủ để phase 5.

## Requirements

- [ ] Bảng copy có cột `version` và trạng thái khớp `docs/_shared/domain/library-states.md`.
- [ ] Một bộ quy định mượn (số cuốn tối đa, số ngày, mức phạt/ngày) sửa được bởi `ADMIN`.
- [ ] `POST /api/loans` tạo phiếu trong transaction. Bản sao không khả dụng thì từ chối, không ghi nửa vời.
- [ ] Hai request mượn cùng một bản sao: một thành công, một bị từ chối vì version hoặc trạng thái.
- [ ] `POST /api/loans/{id}/return` trả bình thường và đưa bản sao về trạng thái sẵn sàng.

## Implementation Steps

1. Đọc vòng đời bản sao trong `docs/_shared/domain/library-states.md` và chép các chuyển trạng thái hợp lệ vào một enum cùng bảng chuyển, có test.
2. Migration copy, loan, policy. Seed một bản sao sẵn sàng và một bản sao đang mượn.
3. Service mượn: khóa theo id bản sao, kiểm tra trạng thái, kiểm tra hạn mức người đọc, ghi loan, đổi trạng thái, tăng version.
4. Service trả bình thường đi cùng transaction.
5. Test tích hợp Testcontainers hoặc Postgres trong Compose: mượn hợp lệ, mượn sai trạng thái, hai mượn song song.

## Todo

- [ ] Test từ chối mượn bản sao không sẵn sàng.
- [ ] Test hai mượn đồng thời chỉ một cái thành công.
- [ ] Test trả bình thường đổi trạng thái bản sao.
- [ ] OpenAPI có nhóm lưu thông và quy định.

## Success Criteria

`./mvnw verify` có các test trên và xanh. Gọi API mượn một bản sao đang mượn nhận lỗi 409, database không thêm phiếu mới.

## Risk Assessment

Nếu phase này dùng trạng thái tự nghĩ, phase 6 sẽ phải sửa API. Nguồn trạng thái là file domain đã trích, không phải tên cột đặt cho tiện.

## Security Considerations

Người đọc không được gọi API mượn hộ người khác. Thủ thư tạo phiếu cho người đọc đang active. Mọi lệnh đổi trạng thái đi qua service, không có endpoint sửa cột status thô.
