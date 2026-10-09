---
title: "Phase 1: Nền Spring Boot và danh tính"
status: todo
---

# Phase 1: Nền Spring Boot và danh tính

## Overview

Dựng một JAR Spring Boot chạy local trong Docker, đăng nhập được ba vai trò, mật khẩu bcrypt, JWT có hạn, và có tài liệu OpenAPI. Feature: `access-control`, khung `account-admin`.

## Requirements

- [ ] Java 21, Spring Boot 3, Maven Wrapper, package gốc `com.quanlythuvien`.
- [ ] PostgreSQL 16 trong Compose. Migration bằng Flyway.
- [ ] Ba vai trò: `READER`, `LIBRARIAN`, `ADMIN`. Kiểm tra quyền trên server mỗi request.
- [ ] `ADMIN` tạo và khóa tài khoản thủ thư (`account-admin`). Thủ thư không sửa vai trò của nhau.
- [ ] JWT access 60 phút. Chưa làm refresh token.
- [ ] `GET /api/health` không cần đăng nhập. `GET /api/me` trả vai trò của token.
- [ ] springdoc phát OpenAPI tại `/v3/api-docs`.

## Implementation Steps

1. Tạo `apps/api` bằng Spring Initializr đủ Web, Security, Data JPA, Validation, Flyway, PostgreSQL.
2. Viết `deploy/docker-compose.yml` local: service `db` và `api`. API đợi DB khỏe rồi mới start. Heap Java `-Xmx512m`.
3. Migration `V1__identity.sql`: bảng user (email, password hash, role, status) và reader profile tối thiểu để phase sau nối vào.
4. `POST /api/auth/login` nhận email và mật khẩu, trả access token. Seed ba user bằng Flyway, mật khẩu chỉ nằm trong seed dev.
5. Security filter đọc Bearer token. Endpoint mẫu `GET /api/admin/ping` chỉ `ADMIN`.
6. Bật springdoc. CORS không cần cho app điện thoại. Chỉ mở profile `dev` nếu chạy Flutter trên Chrome.

## Todo

- [ ] `apps/api` build được bằng `./mvnw verify`.
- [ ] Compose local lên được và `/api/health` trả 200.
- [ ] Đăng nhập ba seed user, gọi `/api/me` đúng vai trò.
- [ ] Gọi endpoint admin bằng token người đọc bị từ chối.

## Success Criteria

`./mvnw verify` xanh. `docker compose -f deploy/docker-compose.yml up` xong, `curl` login trả JWT và `/api/me` đúng role. Token người đọc gọi route admin nhận 403.

## Risk Assessment

Spring Boot trên máy 2 GB dễ hết RAM khi để heap mặc định. Khóa `-Xmx512m` ngay từ image đầu tiên để phase 2 không phải sửa lại.

## Security Considerations

Mật khẩu chỉ lưu bcrypt. Secret JWT lấy từ biến môi trường, không commit. Seed dev không dùng lại trên VPS. Log không in token.
