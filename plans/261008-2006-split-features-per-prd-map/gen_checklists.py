from pathlib import Path
import re
from collections import defaultdict

ROOT = Path(r"D:/Projects/QuanLyThuVIen")
FEAT = ROOT / "docs/features"
TODAY = "2026-10-09"
cross = (ROOT / "docs/_shared/id-crosswalk-lmp.md").read_text(encoding="utf-8")
chk_feat = {}
idmap = {}
old_rx = re.compile(r"((?:FR|NFR|BR|E|SC|CHK)-LMP-\d+)")
new_rx = re.compile(r"`((?:FR|NFR|BR|E|SC|CHK)-[a-z0-9-]+-\d+)`")
feat_rx = re.compile(r"`([a-z0-9-]+)`")
for line in cross.splitlines():
    om = old_rx.search(line)
    news = new_rx.findall(line)
    if om and news:
        idmap.setdefault(om.group(1), news[-1])
    if om and om.group(1).startswith("CHK-LMP-"):
        feats = feat_rx.findall(line)
        dest = feats[0] if feats else None
        new = news[-1] if news else None
        if dest and new and dest != "core":
            chk_feat[om.group(1)] = (dest, new)

keys = sorted(idmap, key=len, reverse=True)

def remap(s: str) -> str:
    for k in keys:
        s = s.replace(k, idmap[k])
    return s

src = (FEAT / "library-management-platform/test/checklist/checklist-feature.md").read_text(encoding="utf-8")
items = defaultdict(list)
for line in src.splitlines():
    m = re.search(r"(CHK-LMP-\d+)", line)
    if not m or m.group(1) not in chk_feat:
        continue
    feat, new = chk_feat[m.group(1)]
    items[feat].append(remap(line.replace(m.group(1), new)))

extra = {
    "reader-self-service": [
        "[1] [Yes] CHK-reader-self-service-001 → FR-reader-self-service-001 · Kiểm tra Người đọc tra cứu chỉ thấy dữ liệu công khai và số khả dụng",
        "[1] [Yes] CHK-reader-self-service-002 → FR-reader-self-service-002 · Kiểm tra đang mượn chỉ của chính mình",
        "[1] [Yes] CHK-reader-self-service-003 → FR-reader-self-service-004 · Kiểm tra QR ẩn khi thẻ chưa kích hoạt",
        "[1] [Yes] CHK-reader-self-service-004 → FR-reader-self-service-005 · Kiểm tra lịch sử chỉ của chính mình",
        "[2] [Yes] CHK-reader-self-service-005 → FR-reader-self-service-003 · Kiểm tra công nợ R1B chỉ xem, không thu online",
    ],
    "ops-reports": [
        "[1] [Yes] CHK-ops-reports-001 → FR-ops-reports-001 · Kiểm tra Quản trị viên xem RP-01/02/04 và xuất file",
        "[2] [Yes] CHK-ops-reports-002 → FR-ops-reports-002 · Kiểm tra Thủ thư xem danh sách quá hạn R1B",
        "[1] [Yes] CHK-ops-reports-003 → FR-ops-reports-001, E-core-002 · Kiểm tra thiếu quyền thì không xem báo cáo",
    ],
    "renewal": [
        "[2] [Yes] CHK-renewal-001 → FR-renewal-001 · Kiểm tra gia hạn thành công khi đủ điều kiện",
        "[2] [Yes] CHK-renewal-002 → FR-renewal-001 · Kiểm tra bị chặn thì hiện lý do, không bịa số lần",
    ],
    "reservation": [
        "[2] [Yes] CHK-reservation-001 → FR-reservation-001 · Kiểm tra tạo đặt trước vào hàng đợi",
        "[2] [Yes] CHK-reservation-002 → FR-reservation-002 · Kiểm tra hết hạn giữ thì mất lượt",
        "[2] [Yes] CHK-reservation-003 → FR-reservation-003 · Kiểm tra Người đọc đặt/hủy trên cổng",
    ],
    "trend-reports": [
        "[2] [Yes] CHK-trend-reports-001 → FR-trend-reports-001 · Kiểm tra Quản trị viên xem RP-03/05/06/07",
        "[2] [Yes] CHK-trend-reports-002 → FR-trend-reports-001, E-core-002 · Kiểm tra thiếu quyền thì không xem",
    ],
    "fine-collection-adv": [
        "[2] [Yes] CHK-fine-collection-adv-001 → FR-fine-collection-adv-001 · Kiểm tra biên nhận thu phạt R1B",
        "[2] [Yes] CHK-fine-collection-adv-002 → FR-fine-collection-adv-002 · Kiểm tra miễn/điều chỉnh cần step-up",
    ],
    "ops-foundation": [
        "[1] [No] CHK-ops-foundation-004 → FR-ops-foundation-002 · Kiểm tra backup hằng ngày và giữ 30 bản",
    ],
    "account-admin": [
        "[1] [Yes] CHK-account-admin-003 → FR-account-admin-003 · Kiểm tra Quản trị viên không xóa cứng tài khoản Thủ thư đã có lịch sử",
    ],
}
for k, v in extra.items():
    exist = "\n".join(items[k])
    for line in v:
        if line.split()[2] not in exist:
            items[k].append(line)

print("features with chk", sorted(items), {k: len(v) for k, v in items.items()})

for feat, lines in items.items():
    n = len(lines)
    body = f"# Checklist — {feat}\n\n" + "\n".join(lines) + "\n"
    d = FEAT / feat / "test"
    (d / "checklist").mkdir(parents=True, exist_ok=True)
    (d / "checklist" / "checklist-feature.md").write_text(body, encoding="utf-8")
    (d / "checklist" / f"{feat}-checklist-index.md").write_text(
        f"""---
type: test-checklist-index
feature: {feat}
status: draft
updated: {TODAY}
next_chk_id: {n + 1}
links:
  - docs/features/{feat}/srs/{feat}-spec.md
  - docs/features/{feat}/test/test-strategy.md
---

# Test Checklists — {feat}

Baseline nghĩa vụ từ SRS/US/AC đang `draft`. Chưa duyệt, chưa sinh test case.

## Checklists

| Scope | File | Items | Status | Updated |
|-------|------|-------|--------|---------|
| feature | [checklist-feature.md](checklist-feature.md) | {n} | draft | {TODAY} |
""",
        encoding="utf-8",
    )
    (d / "test-strategy.md").write_text(
        f"""---
type: test-strategy
feature: {feat}
status: draft
updated: {TODAY}
language: vi
device: mobile-375
profile: core-functional
---

# Chiến lược test — {feat}

## Durable

Tham chiếu `docs/_shared/test-strategy-baseline.md`.

- Ngôn ngữ checklist: tiếng Việt. Giữ mã ID và tên màn trong SRS.
- Thiết bị đối chiếu UI: Mobile 375.
- Dữ liệu giả, không PII/secret.
- Nguồn thiếu: không bịa ngưỡng; ghi `blocked`/`tbd` kèm OQ.

## Per-run {TODAY}

- Mục đích: baseline nghĩa vụ test sau khi tách feature.
- Không phải UAT/go-live.
""",
        encoding="utf-8",
    )
print("wrote", len(items))
