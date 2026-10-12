# -*- coding: utf-8 -*-
"""Phase 8: retarget live docs away from library-management-platform, then caller git-rms the folder."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def patch(rel: str, pairs: list[tuple[str, str]]) -> None:
    path = ROOT / rel
    text = path.read_text(encoding="utf-8")
    original = text
    for old, new in pairs:
        if old not in text:
            raise SystemExit(f"MISSING in {rel}:\n---\n{old[:180]}\n---")
        text = text.replace(old, new, 1) if text.count(old) == 1 else text.replace(old, new)
        # allow replace_all when old appears more than once only if we meant it
    if text == original:
        raise SystemExit(f"NO CHANGE: {rel}")
    path.write_text(text, encoding="utf-8", newline="\n")
    print(f"patched {rel}")


# --- id-registry ---
patch(
    "docs/_shared/id-registry.md",
    [
        ("updated: 2026-10-08", "updated: 2026-10-09"),
        (
            "  - docs/features/library-management-platform/srs/library-management-platform-spec.md",
            "  - docs/_shared/id-crosswalk-lmp.md\n  - docs/_shared/core-spec.md",
        ),
        (
            "| Open Question (SRS) | `OQ-LMP-NNN` | `OQ-LMP-001`…`OQ-LMP-018` | `srs/library-management-platform-spec.md` §12 | Sẽ retired sau phase 8 tách feature — tra mã mới ở `id-crosswalk-lmp.md` |",
            "| Open Question (SRS gộp, retired) | `OQ-LMP-NNN` | `OQ-LMP-001`…`OQ-LMP-018` | `id-crosswalk-lmp.md` | Retired 2026-10-09 — tra mã mới; không cấp thêm |",
        ),
        (
            "| Functional Req (SRS) | `FR-LMP-NNN` | `FR-LMP-001`…`FR-LMP-028` | SRS §3 | Sẽ retired sau phase 8 tách feature — tra mã mới ở `id-crosswalk-lmp.md` |",
            "| Functional Req (SRS gộp, retired) | `FR-LMP-NNN` | `FR-LMP-001`…`FR-LMP-028` | `id-crosswalk-lmp.md` | Retired 2026-10-09 — tra mã mới; không cấp thêm |",
        ),
        (
            "| Business Rule (SRS) | `BR-LMP-NNN` | `BR-LMP-001`…`BR-LMP-017` | SRS §5 | Crosswalk với BR-NN ở §3. Sẽ retired sau phase 8 tách feature — tra mã mới ở `id-crosswalk-lmp.md` |",
            "| Business Rule (SRS gộp, retired) | `BR-LMP-NNN` | `BR-LMP-001`…`BR-LMP-017` | `id-crosswalk-lmp.md` | Retired 2026-10-09 — tra mã mới; không cấp thêm |",
        ),
        (
            "| Non-Functional Req (SRS) | `NFR-LMP-NNN` | `NFR-LMP-001`…`NFR-LMP-012` | SRS §4 | Sẽ retired sau phase 8 tách feature — tra mã mới ở `id-crosswalk-lmp.md` |",
            "| Non-Functional Req (SRS gộp, retired) | `NFR-LMP-NNN` | `NFR-LMP-001`…`NFR-LMP-012` | `id-crosswalk-lmp.md` | Retired 2026-10-09 — tra mã mới; không cấp thêm |",
        ),
        (
            "| Error | `E-LMP-NNN` | `E-LMP-001`…`E-LMP-018` | SRS §6 | Sẽ retired sau phase 8 tách feature — tra mã mới ở `id-crosswalk-lmp.md` |",
            "| Error (SRS gộp, retired) | `E-LMP-NNN` | `E-LMP-001`…`E-LMP-018` | `id-crosswalk-lmp.md` | Retired 2026-10-09 — tra mã mới; không cấp thêm |",
        ),
        (
            "| Success Criteria | `SC-LMP-NN` | `SC-LMP-01`…`SC-LMP-07` | SRS §7 | Sẽ retired sau phase 8 tách feature — tra mã mới ở `id-crosswalk-lmp.md` |",
            "| Success Criteria (SRS gộp, retired) | `SC-LMP-NN` | `SC-LMP-01`…`SC-LMP-07` | `id-crosswalk-lmp.md` | Retired 2026-10-09 — tra mã mới; không cấp thêm |",
        ),
        (
            "| Use Case | `uc-<slug>` | `uc-access-control`…`uc-admin-import` (10) | `usecases/library-management-platform-usecase-index.md` | Slug = tên file |",
            "| Use Case | `uc-<slug>` | theo từng feature | `docs/features/{feature}/usecases/{feature}-usecase-index.md` | Slug = tên file |",
        ),
        (
            "| `FR-Cnn/Rnn/Lnn/Snn` | Giữ nguyên (series nguồn) | Map sang `FR-LMP-nnn` trong traceability Phase 6/8 — một FR-LMP có thể cover nhiều FR nguồn |",
            "| `FR-Cnn/Rnn/Lnn/Snn` | Giữ nguyên (series nguồn) | Map sang mã theo feature qua `id-crosswalk-lmp.md` — một FR nguồn có thể cover nhiều FR feature |",
        ),
        (
            """## 3. Crosswalk quy tắc nguồn → SRS

- `FR-<AREA>NN` (nguồn) ↔ `FR-LMP-NNN` (SRS): không phải 1:1. Bảng ánh xạ chính thức sinh ở Phase 6/8 traceability; tạm thời tham chiếu qua cột "Covers FR" của UC index.
- `BR-NN` (nguồn) ↔ `BR-LMP-NNN`: khác thứ tự — `BR-LMP` là rule đã chuẩn hoá, `BR-NN` trỏ tham số cấu hình (OQ-04).
- `NFR-NN` (nguồn, 01–08) ↔ `NFR-LMP-NNN` (SRS, 001–012): ánh xạ ghi trong cột Source/Acceptance của SRS §4 khi cần.
""",
            """## 3. Crosswalk quy tắc nguồn → SRS theo feature

- `FR-<AREA>NN` (nguồn) ↔ `{FR}-{feature}-NNN`: không phải 1:1. Bảng ánh xạ chính thức: `id-crosswalk-lmp.md` (series `FR-LMP-*` đã retired).
- `BR-NN` (nguồn) ↔ `{BR}-{feature|core}-NNN`: khác thứ tự — mã feature/core là rule đã chuẩn hoá, `BR-NN` trỏ tham số cấu hình (OQ-04).
- `NFR-NN` (nguồn, 01–08) ↔ `{NFR}-{feature|core}-NNN`: ánh xạ ghi trong `id-crosswalk-lmp.md` và cột Source/Acceptance của SRS đích.
""",
        ),
        (
            "4. Mọi OQ mới sau baseline dùng `GAP-OQ-NN` hoặc `OQ-LMP-NNN` tiếp theo — tuyệt đối không dùng `OQ-NN` trần (va chạm series nguồn).",
            "4. Mọi OQ mới sau baseline dùng `GAP-OQ-NN`, `OQ-core-NNN` hoặc `OQ-{feature}-NNN` — tuyệt đối không dùng `OQ-NN` trần (va chạm series nguồn) và không cấp thêm `OQ-LMP-*`.",
        ),
    ],
)

# --- navigation-map ---
patch(
    "docs/_shared/navigation-map.md",
    [
        ("updated: 2026-10-08", "updated: 2026-10-09"),
        (
            "  - docs/features/library-management-platform/srs/library-management-platform-userflow.md",
            "  - docs/features/access-control/srs/access-control-userflow.md",
        ),
    ],
)

# --- lifecycle-inventory ---
patch(
    "docs/_shared/domain/lifecycle-inventory.md",
    [
        ("updated: 2026-10-08", "updated: 2026-10-09"),
        (
            "  - docs/features/library-management-platform/srs/library-management-platform-spec.md",
            "  - docs/_shared/core-spec.md",
        ),
        (
            "Thuật ngữ theo `docs/_shared/project-profile.md`. Cột \"SRS alias\" ánh xạ sang namespace đang dùng trong `library-management-platform-spec.md` để truy vết chéo.",
            "Thuật ngữ theo `docs/_shared/project-profile.md`. Cột \"SRS alias\" ánh xạ sang namespace đang dùng trong `core-spec.md` và SRS từng feature để truy vết chéo.",
        ),
    ],
)

# --- library-erd ---
patch(
    "docs/_shared/domain/library-erd.md",
    [
        ("updated: 2026-10-08", "updated: 2026-10-09"),
        (
            "  - docs/features/library-management-platform/srs/library-management-platform-spec.md",
            "  - docs/_shared/core-spec.md",
        ),
        (
            "  - docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md",
            "  - docs/features/access-control/usecases/access-control-usecase-index.md",
        ),
        (
            "# library-management-platform — ERD + Data Dictionary (draft Phase 4)",
            "# Domain — ERD + Data Dictionary (draft Phase 4)",
        ),
        (
            "> Draft SRS Tier 2. File đích khi approved: `docs/_shared/domain/library-erd.md` (đã khai báo trong frontmatter spec §links).",
            "> Draft SRS Tier 2. File đích khi approved: `docs/_shared/domain/library-erd.md` (đã khai báo trong frontmatter `core-spec.md` §links).",
        ),
    ],
)

# --- library-states ---
patch(
    "docs/_shared/domain/library-states.md",
    [
        ("updated: 2026-10-08", "updated: 2026-10-09"),
        (
            "  - docs/features/library-management-platform/srs/library-management-platform-spec.md",
            "  - docs/_shared/core-spec.md",
        ),
        (
            "# library-management-platform — State Diagrams (SRS Tier 2)",
            "# Domain — State Diagrams (SRS Tier 2)",
        ),
    ],
)

# --- id-crosswalk ---
patch(
    "docs/_shared/id-crosswalk-lmp.md",
    [
        ("updated: 2026-10-08", "updated: 2026-10-09"),
        (
            "  - docs/features/library-management-platform/srs/library-management-platform-spec.md",
            "  - docs/_shared/core-spec.md",
        ),
        (
            "Mỗi dòng ánh xạ một item của feature gộp `library-management-platform` sang đúng một đích (feature hoặc phần dùng chung) và một mã mới, theo quyết định DEC-SF-01..09 trong `docs/_product/decision-register.md`. Mã `*-LMP-*` sẽ retired sau khi tách xong; bảng này là nơi duy nhất còn giữ chúng.",
            "Mỗi dòng ánh xạ một item của feature gộp đã gỡ (`library-management-platform`, xóa 2026-10-09) sang đúng một đích (feature hoặc phần dùng chung) và một mã mới, theo quyết định DEC-SF-01..09 trong `docs/_product/decision-register.md`. Mã `*-LMP-*` đã retired; bảng này là nơi duy nhất còn giữ chúng trong tài liệu sống.",
        ),
        (
            "- Nguồn ghi theo đường dẫn tương đối trong `docs/features/library-management-platform/`.",
            "- Nguồn là đường dẫn lịch sử trong git (thư mục `docs/features/library-management-platform/` đã gỡ 2026-10-09). Khôi phục file gốc từ tag `pre-split-features` nếu cần đối chiếu.",
        ),
    ],
)

# --- decision-register ---
patch(
    "docs/_product/decision-register.md",
    [
        ("updated: 2026-10-08", "updated: 2026-10-09"),
        ("Có — OQ-LMP-004", "Có — OQ-core-002"),
        ("Có — OQ-LMP-005/009", "Có — OQ-fine-collection-adv-001/002"),
        ("Có — OQ-LMP-005", "Có — OQ-fine-collection-adv-001"),
        (
            "Các decision trên gắn với `OQ-LMP-003/004/005/009/010` trong `docs/features/library-management-platform/srs/library-management-platform-spec.md` §12 và `OQ-10/OQ-11` trong `docs/he_thong_quan_ly_thu_vien.md` §11. Khi OQ được resolve, entry tương ứng phải cập nhật status + evidence.",
            "Các decision trên gắn với `OQ-reservation-001`, `OQ-core-002`, `OQ-fine-collection-adv-001/002`, `OQ-policy-config-001` (bảng đối chiếu mã gộp cũ ở `docs/_shared/id-crosswalk-lmp.md`) và `OQ-10/OQ-11` trong `docs/he_thong_quan_ly_thu_vien.md` §11. Khi OQ được resolve, entry tương ứng phải cập nhật status + evidence.",
        ),
        (
            "SRS hiện hữu (`library-management-platform-spec.md` §1) dùng R1/P0–R2/P1–Later/P2 và gắn Reservation `P0-PROPOSAL` — cần ánh xạ lại sau khi roadmap approved (drift risk, Reservation theo DEC-P2-05 là R2 không phải P0)",
            "SRS gộp cũ (đã tách, xem `id-crosswalk-lmp.md`) dùng R1/P0–R2/P1–Later/P2 và gắn Reservation `P0-PROPOSAL` — cần ánh xạ lại sau khi roadmap approved (drift risk, Reservation theo DEC-P2-05 là R2 không phải P0)",
        ),
        (
            "Gia hạn online thuộc `renewal`, đặt trước online thuộc `reservation` (R2). FR-LMP-024 tách theo",
            "Gia hạn online thuộc `renewal`, đặt trước online thuộc `reservation` (R2). Tách theo `FR-reader-self-service-002/003`, `FR-reservation-003`, `FR-expansion-candidates-001`",
        ),
        ("Có — OQ-LMP-014", "Có — OQ-account-admin-001"),
        (
            "spec FR-LMP-003; `priority-crosswalk.md` FR-R02",
            "FR-catalog-admin-002 / FR-reader-self-service-001; `priority-crosswalk.md` FR-R02",
        ),
    ],
)

# --- product-roadmap-baseline ---
patch(
    "docs/_product/product-roadmap-baseline.md",
    [
        (
            "DEC-D3-01/DEC-D3-02, liên quan OQ-LMP-004",
            "DEC-D3-01/DEC-D3-02, liên quan OQ-core-002",
        ),
    ],
)

# --- docs README ---
patch(
    "docs/README.md",
    [
        (
            "Bộ tài liệu đang được tách từ feature gộp `features/library-management-platform/` sang 23 thư mục feature theo `plans/261008-2006-split-features-per-prd-map/`. Feature gộp còn giữ tới khi tách xong; tra mã cũ `*-LMP-*` ở `_shared/id-crosswalk-lmp.md`.",
            "Feature gộp đã gỡ 2026-10-09. Tài liệu sống nằm ở 23 thư mục `features/{slug}/` theo Feature Map. Tra mã cũ (series đã retired) ở `_shared/id-crosswalk-lmp.md`.",
        ),
    ],
)

print("all live patches ok")
