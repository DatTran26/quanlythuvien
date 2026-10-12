---
title: "Phase 2: VPS và HTTPS"
status: todo
---

# Phase 2: VPS và HTTPS

## Overview

Đưa API phase 1 lên một VPS luôn bật để điện thoại gọi được từ 4G. Feature vận hành liên quan: phần backup tối thiểu của `ops-foundation`.

## Requirements

- [ ] VPS Ubuntu, tối thiểu 2 GB RAM, Docker Engine và Compose plugin.
- [ ] Một domain trỏ bản ghi A tới VPS.
- [ ] Caddy lấy chứng chỉ HTTPS và proxy tới API.
- [ ] PostgreSQL và file ảnh dùng volume đặt tên, không nằm trong container ghi đè khi deploy.
- [ ] `GET /api/health` trả 200 qua `https://` từ mạng không cùng Wi-Fi với máy dev.

## Implementation Steps

1. Thuê VPS và kiểm tra RAM trước khi cài. Dưới 2 GB thì dừng, không ép Spring lên gói nhỏ hơn.
2. Cài Docker. Mở firewall chỉ 22, 80, 443. PostgreSQL không publish ra internet.
3. Thêm service `caddy` vào Compose và `deploy/Caddyfile`: domain proxy sang `api:8080`.
4. Viết `apps/api/Dockerfile` multi-stage (build Maven, chạy Temurin JRE), heap 512 MB.
5. Đặt env production trên VPS: `JWT_SECRET`, mật khẩu DB, `SPRING_PROFILES_ACTIVE=prod`. Không copy seed mật khẩu dev.
6. Thêm cron hằng ngày `pg_dump` vào volume backup trên cùng VPS.

## Todo

- [ ] Compose trên VPS báo đủ ba service khỏe: caddy, api, db.
- [ ] Trình duyệt hoặc `curl` từ 4G thấy HTTPS hợp lệ và `/api/health` là 200.
- [ ] Port 5432 không mở ra internet.
- [ ] Một file dump SQL xuất hiện sau lần chạy cron thử.

## Success Criteria

Từ điện thoại dùng 4G, `https://<domain>/api/health` trả 200 với chứng chỉ đúng domain. `ss` hoặc firewall cho thấy 5432 không listen publicly.

## Risk Assessment

Hết hạn chứng chỉ hoặc DNS chưa lan sẽ làm app release fail vì Android chặn HTTP. Diễn tập health check trên 4G trước khi viết Flutter.

## Security Considerations

SSH bằng khóa, tắt đăng nhập mật khẩu root nếu nhà cung cấp cho phép. JWT secret production khác secret local. Volume DB không commit.
