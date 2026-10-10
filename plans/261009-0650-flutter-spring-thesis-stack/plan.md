---
title: "Đồ án Flutter + Spring Boot trên một VPS"
description: "Một app Flutter gọi REST của Spring Boot modular monolith, PostgreSQL và HTTPS trên một VPS luôn bật, phủ feature P0 và P1 của hệ thống quản lý thư viện."
status: pending
priority: P1
effort: "9 phases"
issue: ""
branch: "develop-dat"
tags: [feature, frontend, backend, api, infra]
blockedBy: []
blocks: []
created: 2026-10-09
---

# Đồ án Flutter + Spring Boot trên một VPS

## Overview

Đồ án chạy trên điện thoại lúc bảo vệ. Một app Flutter phục vụ Người đọc, Thủ thư và Quản trị viên. Backend là một process Spring Boot 3 / Java 21, PostgreSQL, REST JSON và JWT. Triển khai bằng Docker Compose trên một VPS luôn bật, có HTTPS. Phạm vi nghiệp vụ là feature P0 và P1 trong `docs/_product/prd.md` Mục 7. `expansion-candidates` nằm ngoài.

Quyết định đã chốt với người dùng ngày 2026-10-09: đồ án để bảo vệ; một app điện thoại vì giảng viên yêu cầu; quản trị trên điện thoại được chấp nhận; backend mới theo REST; ngôn ngữ Java/Spring; host là VPS khoảng 100–200 nghìn/tháng, tối thiểu 2 GB RAM; sơ đồ phải phủ toàn bộ nghiệp vụ P0–P1.

## Goals

| # | Goal | Priority |
|---|------|----------|
| 1 | Điện thoại đăng nhập được ba vai trò qua HTTPS từ mạng di động | P1 |
| 2 | API từ chối mượn hoặc trả khi bản sao sai trạng thái | P1 |
| 3 | OpenAPI liệt kê đủ module P0 và P1 | P1 |
| 4 | Buổi bảo vệ có kịch bản diễn tập trên bản cài release | P1 |

## Phases

| # | Phase | Status |
|---|-------|--------|
| 1 | [Nền Spring Boot và danh tính](./phase-01-start.md) | Pending |
| 2 | [VPS và HTTPS](./phase-02-vps-https.md) | Pending |
| 3 | [Máy trạng thái bản sao và mượn–trả](./phase-03-circulation-core.md) | Pending |
| 4 | [Vỏ app Flutter](./phase-04-flutter-shell.md) | Pending |
| 5 | [Danh mục, QR và người đọc](./phase-05-catalog-qr.md) | Pending |
| 6 | [Trả, phạt, hư hỏng và mất](./phase-06-desk-exceptions.md) | Pending |
| 7 | [Đặt trước, gia hạn và thông báo](./phase-07-holds-notify.md) | Pending |
| 8 | [Import, báo cáo và nhật ký](./phase-08-import-report-audit.md) | Pending |
| 9 | [Dữ liệu demo và diễn tập](./phase-09-demo-rehearsal.md) | Pending |

## Dependencies

- Mã nằm trong repo này: `apps/api` (Spring Boot), `apps/mobile` (Flutter), `deploy/` (Compose và Caddy).
- Nghiệp vụ đọc từ `docs/_product/prd.md` Mục 7 và `docs/he_thong_quan_ly_thu_vien.md`. Khi hai nơi lệch, PRD feature map là danh sách việc; quy tắc trạng thái bản sao lấy từ `docs/_shared/domain/library-states.md`.
- Phase 2 cần image của phase 1. Phase 4 cần API phase 1 và URL HTTPS phase 2. Phase 3 chặn mọi luồng lưu thông phía sau.
- Phase 7 và phase 8 cùng phụ thuộc phase 6. Làm tuần tự nếu một người. Hai người thì phase 8 được bắt đầu sau phase 5 cho import danh mục, và chờ phase 6 cho báo cáo lưu thông.

## Ngoài phạm vi

- Web quản trị riêng, Flutter web, chế độ offline.
- Thanh toán online, đa chi nhánh, điểm danh, SMS, push, Zalo (`expansion-candidates`).
- Tách microservice, Firebase hoặc Supabase thay Spring.
- Refresh token, Redis, Kafka, Elasticsearch.
- Vận hành production nhiều năm. Backup demo là một cron `pg_dump`, không phải diễn tập khôi phục 30 bản.

## Success Criteria

- [ ] Từ 4G, ba vai trò đăng nhập thành công vào app release.
- [ ] `docker compose ps` trên VPS cho thấy Caddy, API và PostgreSQL đang chạy.
- [ ] API trả lỗi khi mượn hoặc trả một bản sao sai trạng thái, có test tự động.
- [ ] OpenAPI có nhóm danh tính, danh mục, bản sao, lưu thông, đặt trước, phạt, hư hỏng, thông báo, import, báo cáo, nhật ký.
- [ ] Kịch bản bảo vệ 8–10 phút chạy xong trên điện thoại không cần nhập kho bằng tay.

<!-- slug: flutter-spring-thesis-stack -->
