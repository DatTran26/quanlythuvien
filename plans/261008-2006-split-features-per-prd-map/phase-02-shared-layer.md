---
title: "Phase 2: Dựng tầng dùng chung docs/_shared/"
status: pending
priority: P1
effort: "1 ngày"
dependencies: [1]
---

# Phase 2: Dựng tầng dùng chung `docs/_shared/`

## Mục tiêu

Tạo xong mọi nội dung xuyên feature trước, để các feature ở phase 4–7 chỉ cần tham chiếu tới đây.

## Cấu trúc đích

```
docs/_shared/
├── core-spec.md                 # actors + mapping vai trò, NFR/BR/E chung, ràng buộc, phụ thuộc, giả định, invariant
├── navigation-map.md            # chuyển màn giữa các feature, dashboard theo vai trò
├── test-strategy-baseline.md    # phần bền của chiến lược test
├── id-crosswalk-lmp.md          # (phase 1)
├── id-registry.md               # (đã có)
├── project-profile.md           # (đã có)
└── domain/
    ├── library-erd.md           # từ srs/library-management-platform-erd.md
    ├── library-states.md        # từ srs/library-management-platform-states.md
    └── lifecycle-inventory.md   # từ domain/lifecycle-inventory.md
docs/_product/
└── product-roadmap-baseline.md  # từ brainstorms/product-roadmap-baseline.md
```

## Các bước

1. **Di chuyển mô hình miền** bằng `git mv` để giữ lịch sử: erd → `domain/library-erd.md`, states → `domain/library-states.md`, lifecycle-inventory → `domain/lifecycle-inventory.md`. Sau đó L2 diff cho từng file: đổi frontmatter (bỏ `feature:`, thêm `scope: shared`), đổi mã LMP sang mã mới theo crosswalk, đổi link. Thêm cột "Feature dùng" cho mỗi entity và mỗi state machine.
2. **Đổi ID dạng ngắn của tài liệu nguồn** (`BR-01`, `NFR-01`, `FR-C01`…) trong 3 file trên sang dạng có tiền tố nguồn đã chốt ở phase 1 (đề xuất `SRC-BR-01`) để hết 233 broken ref. Ghi alias trong `id-registry.md` Mục 2.
3. **Tạo `core-spec.md`** theo `_templates/srs-spec.md` nhưng chỉ chứa: Mục 0 (nhãn nguồn, namespace), Mục 2 (Actors + mapping vai trò đã chốt X7), NFR/BR/E chung (theo crosswalk), invariant từ flows Mục 0, Mục 11 (ràng buộc, phụ thuộc, giả định chung), OQ chung. Không có FR. Frontmatter `type: srs`, `status: draft`, không `feature:`.
4. **Tạo `navigation-map.md`**: bảng chuyển màn giữa feature (từ userflow Mục 3.5, chỉ các chuyển màn có hai đầu ở hai feature khác nhau), dashboard theo vai trò (từ `dashboard-home`), quy ước nút "quay lại".
5. **Tạo `test-strategy-baseline.md`** từ phần bền của `test/test-strategy.md` (môi trường, dữ liệu, thiết bị Mobile 375, ngôn ngữ).
6. **Di chuyển brainstorm sản phẩm**: `git mv` sang `docs/_product/product-roadmap-baseline.md`, đổi frontmatter `type: brainstorm` → giữ type, bỏ `feature:`, L2 diff cho link.
7. **Kiểm**: `mermaid-verify.mjs` cho `library-erd.md`, `library-states.md` exit 0; KG build và `explore` một ID chung bất kỳ resolve được.

## Lưu ý

- Feature gộp vẫn còn ở bước này; các file trong nó tạm trỏ sang file đã chuyển. Không xóa gì cho tới phase 8.
- Mỗi file mới/sửa qua L1/L2 theo `approval-gate.md`. Một L1 gộp cho cả phase là được (cùng loại thao tác), L2 riêng từng file sửa.

## Tiêu chí xong

- 8 file đích tồn tại; item `_shared` trong crosswalk đánh dấu "đã chuyển (phase 2)".
- 0 broken ref do ID dạng ngắn trong 3 file miền.
