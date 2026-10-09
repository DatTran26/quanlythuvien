# -*- coding: utf-8 -*-
"""Generate remaining BA docs for split features. Run: python -I thisfile"""
from __future__ import annotations

import hashlib
import re
from collections import defaultdict
from datetime import date
from pathlib import Path

ROOT = Path(r"D:\Projects\QuanLyThuVIen")
DOCS = ROOT / "docs"
FEAT = DOCS / "features"
TODAY = "2026-10-09"
AUTHOR = "@dattran26"

ID_MAP: dict[str, str] = {}
CHK_FEAT: dict[str, tuple[str, str]] = {}  # CHK-LMP-NNN -> (feature, new_id)


def parse_crosswalk() -> None:
    text = (DOCS / "_shared" / "id-crosswalk-lmp.md").read_text(encoding="utf-8")
    for m in re.finditer(
        r"\| (FR|NFR|BR|E|SC|US|CHK)-LMP-(\d+) \|[^|]*\| `([^`]+)` \| `([^`]+)`",
        text,
    ):
        old = f"{m.group(1)}-LMP-{m.group(2)}"
        feat, new = m.group(3), m.group(4)
        if m.group(1) == "CHK":
            CHK_FEAT[old] = (feat, new)
        # last mapping wins for split FRs; prefer keeping first for generic remap
        ID_MAP.setdefault(old, new)
    # explicit preferred remaps for split IDs used in prose
    extra = {
        "FR-LMP-003": "FR-catalog-admin-002",
        "FR-LMP-004": "FR-reader-onboarding-001",
        "FR-LMP-015": "FR-fine-collection-basic-001",
        "FR-LMP-018": "FR-lost-handling-001",
        "FR-LMP-019": "FR-notification-core-001",
        "FR-LMP-020": "FR-ops-foundation-001",
        "FR-LMP-023": "FR-ops-reports-001",
        "FR-LMP-024": "FR-reader-self-service-002",
    }
    ID_MAP.update(extra)
    ID_MAP.update(
        {
            "OQ-LMP-007": "OQ-access-control-001",
            "OQ-LMP-010": "OQ-policy-config-001",
            "OQ-LMP-014": "OQ-account-admin-001",
            "OQ-LMP-015": "OQ-reader-self-service-001",
            "OQ-LMP-016": "OQ-reader-self-service-002",
            "OQ-LMP-018": "OQ-data-import-002",
        }
    )


def remap(text: str) -> str:
    keys = sorted(ID_MAP, key=len, reverse=True)
    for k in keys:
        text = text.replace(k, ID_MAP[k])
    text = text.replace("library-management-platform", "{FEAT_PLACEHOLDER}")
    # restore brand-like leftover later per file
    text = text.replace("Nhân viên quản lý người đọc", "Thủ thư")
    text = text.replace("Thủ thư quầy", "Thủ thư")
    text = text.replace("Người tra cứu", "Thủ thư")
    return text


def sha8(s: str) -> str:
    return hashlib.sha256(s.encode("utf-8")).hexdigest()[:8]


def write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content.replace("\r\n", "\n"), encoding="utf-8")


def spec_oqs(feature: str) -> list[str]:
    p = FEAT / feature / "srs" / f"{feature}-spec.md"
    if not p.exists():
        return []
    text = p.read_text(encoding="utf-8")
    return re.findall(r"^- \[ \] .+$", text, re.M)


def userflow_doc(feature: str, title: str, body1: str, screens: list[tuple], flows: list[tuple], trans: list[tuple]) -> None:
    oqs = spec_oqs(feature)
    oq_block = "\n".join(oqs) if oqs else "(Không có câu hỏi mở trong spec.)"
    muc1 = f"## 1. User Flow\n\n{body1.strip()}\n"
    fh = sha8(muc1)
    rows_s = "\n".join(
        f"| {n} | {slug} | {name} | {purpose} | {flow} |"
        for n, slug, name, purpose, flow in screens
    )
    rows_f = "\n".join(f"| {a} | {b} | {c} |" for a, b, c in flows)
    rows_t = "\n".join(f"| {a} | {b} | {c} | {d} |" for a, b, c, d in trans)
    md = f"""---
type: srs-userflow
feature: {feature}
updated: {TODAY}
primary_device: mobile
stage: flow-approved
flow_approved_at: {TODAY}
flow_hash: "{fh}"
---
# {title} — User Flow

{muc1}
## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
{rows_s}

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
{rows_f}

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác ghi bằng chữ khi đích chưa có wireframe; feature R0 dùng `../../{{slug}}/html-wireframe/`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
{rows_t}

## 4. Open Questions

{oq_block}
"""
    write(FEAT / feature / "srs" / f"{feature}-userflow.md", md)
    return fh


STYLE_SRC = FEAT / "access-control" / "html-wireframe" / "auth-flow.html"


def css() -> str:
    html = STYLE_SRC.read_text(encoding="utf-8")
    m = re.search(r"<style>(.*?)</style>", html, re.S)
    return m.group(1) if m else ""


def extract_screens(html_path: Path) -> dict[str, str]:
    html = html_path.read_text(encoding="utf-8")
    out = {}
    for m in re.finditer(
        r'<(div|article) class="wf-screen" id="s(\d+)">(.*?)<div class="wf-screen-label">([^<]+)</div>\s*</\1>',
        html,
        re.S,
    ):
        slug = m.group(4).strip()
        inner = m.group(3)
        out[slug] = (m.group(2), inner)
    return out


HREF = {
    "reader-admin-flow.html": "../../account-admin/html-wireframe/account-admin-flow.html",
    "catalog-admin-flow.html": "../../catalog-admin/html-wireframe/catalog-admin-flow.html",
    "return-renewal-flow.html": "../../return-handling/html-wireframe/return-handling-flow.html",
    "fine-payment-flow.html": "../../fine-collection-basic/html-wireframe/fine-collection-basic-flow.html",
    "auth-flow.html": "../../access-control/html-wireframe/auth-flow.html",
    "checkout-flow.html": "../../checkout/html-wireframe/checkout-flow.html",
    "reservation-flow.html": "../../reservation/html-wireframe/reservation-flow.html",
    "damage-lost-found-flow.html": "../../damage-lifecycle/html-wireframe/damage-lifecycle-flow.html",
    "notification-audit-flow.html": "../../notification-core/html-wireframe/notification-status-flow.html",
    "reports-flow.html": "../../ops-reports/html-wireframe/ops-reports-flow.html",
    "admin-import-flow.html": "../../policy-config/html-wireframe/policy-config-flow.html",
}


def polish_html(s: str) -> str:
    s = remap(s)
    for a, b in HREF.items():
        s = s.replace(f'href="{a}', f'href="{b}')
        s = s.replace(f"href='{a}", f"href='{b}")
    s = s.replace("QuanLyThuVien", "HỆ THỐNG QUẢN LÝ THƯ VIỆN")
    s = s.replace("đề xuất 50.000đ", "50.000đ — DEC-SF-10")
    s = s.replace("N=5 đề xuất", "N=5 — DEC-SF-10")
    s = s.replace("Người dùng hệ thống", "Người dùng")
    return s


def screen_block(n: int, slug: str, inner: str) -> str:
    inner = re.sub(r'<div class="wf-step-badge">\d+</div>', f'<div class="wf-step-badge">{n}</div>', inner, count=1)
    return f'<div class="wf-screen" id="s{n}">{inner}<div class="wf-screen-label">{slug}</div>\n  </div>'


def simple_screen(n: int, bar: str, title: str, slug: str, body: str) -> str:
    return f"""<div class="wf-screen" id="s{n}">
    <div class="wf-step-badge">{n}</div><div class="wf-device-tag">mobile · 375px</div>
    <div class="wf-screen-frame"><div class="wf-screen-bar"><div class="wf-dot"></div><div class="wf-dot"></div><div class="wf-dot"></div><span class="wf-bar-title">{bar}</span></div>
      <div class="wf-screen-content"><div class="wf-app-brand">HỆ THỐNG QUẢN LÝ THƯ VIỆN</div><div class="wf-screen-title">{title}</div>
        {body}
      </div></div><div class="wf-screen-label">{slug}</div>
  </div>"""


def wrap_flow(feature: str, flow_slug: str, flow_title: str, desc: str, screens_html: str, n_screens: int) -> str:
    st = css()
    return f"""<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{feature} — {flow_title} | Wireframe</title>
  <style>{st}</style>
</head>
<body>
<script>if (window.self !== window.top) document.documentElement.classList.add('in-iframe');</script>
<div class="wf-breadcrumb"><a href="{feature}-wireframe.html">← Mục lục wireframe ({feature})</a></div>
<div class="wf-page" data-device="mobile">
  <div class="wf-header">
    <div class="wf-feature-label">Feature: {feature} / Wireframe</div>
    <div class="wf-flow-title">{flow_title}</div>
    <div class="wf-flow-meta">Mobile 375 · {n_screens} màn · {TODAY} · đen trắng</div>
    <div class="wf-flow-desc">{desc}</div>
  </div>
  <div class="wf-rows">
    {screens_html}
  </div>
  <div class="wf-footer">
    <span>{feature} / {flow_slug}</span>
    <span>/wireframe-html · {TODAY}</span>
  </div>
</div>
</body>
</html>
"""


def entry_html(feature: str, flows: list[tuple], n_screens: int, fh: str) -> str:
    # flows: (file, title, screen_links_html)
    side = []
    fmap = []
    first = flows[0][0]
    for i, (fn, title, links, count) in enumerate(flows, 1):
        side.append(
            f'<div class="flow"><a href="{fn}" data-flow="{fn}">{i:02d} · {title} ({count})</a><div class="screens">{links}</div></div>'
        )
        fmap.append(f'<a href="{fn}">{title}</a>')
    st = FEAT.joinpath("access-control/html-wireframe/access-control-wireframe.html").read_text(encoding="utf-8")
    style = re.search(r"<style>(.*?)</style>", st, re.S).group(1)
    return f"""<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{feature} — Mục lục HTML wireframe</title>
  <style>{style}</style>
</head>
<body>
<div class="layout">
  <nav class="sidebar" aria-label="Mục lục wireframe">
    <div class="brand">{feature}</div><div class="meta">HTML wireframe · Mobile 375<br>{len(flows)} flow · {n_screens} màn hình<br>flow_hash: {fh}</div>
    {''.join(side)}
  </nav>
  <main class="main"><header class="header"><h1>{feature} — Wireframe</h1><p>Wireframe đen trắng khung Mobile 375, bám user flow đã duyệt. Chuyển màn sang feature khác xem docs/_shared/navigation-map.md.</p><div class="flow-map">{''.join(fmap)}</div></header><iframe id="viewer" class="viewer" name="wireframe-viewer" title="Flow wireframe" src="{first}"></iframe><p class="fallback">Nếu iframe bị trình duyệt chặn khi mở local file, chọn trực tiếp một flow trong mục lục.</p></main>
</div>
<script>
  const viewer=document.getElementById('viewer');
  document.querySelectorAll('[data-flow]').forEach(link=>link.addEventListener('click',event=>{{event.preventDefault();viewer.src=link.getAttribute('href');}}));
  document.querySelectorAll('.screens a').forEach(link=>link.addEventListener('click',event=>{{event.preventDefault();viewer.src=link.getAttribute('href');}}));
</script>
</body>
</html>
"""


def index_md(feature: str, flows: list[tuple], n_screens: int, fh: str, oqs: list[str]) -> str:
    rows = "\n".join(
        f"| {i} | {title} | [`{fn}`]({fn}) | {slugs} | {count} | {rel} |"
        for i, (fn, title, slugs, count, rel) in enumerate(flows, 1)
    )
    gates = "\n".join(f"- {q.lstrip('- [ ] ')}" for q in oqs) or "- (không)"
    return f"""---
type: wireframe-html-index
feature: {feature}
status: draft
stage: draft
primary_device: mobile
device_width: 375
flow_hash: {fh}
flows: {len(flows)}
screens: {n_screens}
updated: {TODAY}
entry: {feature}-wireframe.html
links:
  - docs/features/{feature}/srs/{feature}-userflow.md
  - docs/features/{feature}/srs/{feature}-spec.md
---

# HTML wireframe index — {feature}

Mở [`{feature}-wireframe.html`]({feature}-wireframe.html) để duyệt mục lục và từng flow trong iframe.

## Inventory

| # | Flow | File | Màn hình | Số màn | Release |
|---|------|------|----------|--------|---------|
{rows}

**Tổng:** {len(flows)} flow, {n_screens} màn hình. Thứ tự màn lấy từ `srs/{feature}-userflow.md` (`flow_hash: {fh}`).

## Open gates

{gates}

## Sources

- `../srs/{feature}-userflow.md`
- `../srs/{feature}-spec.md`
"""


def emit_wf(feature: str, flow_slug: str, flow_title: str, desc: str, blocks: list[tuple[str, str]], rel: str, fh: str) -> None:
    html_screens = "\n".join(screen_block(i, slug, inner) for i, (slug, inner) in enumerate(blocks, 1))
    html_screens = polish_html(html_screens)
    n = len(blocks)
    flow_file = f"{flow_slug}.html"
    write(FEAT / feature / "html-wireframe" / flow_file, wrap_flow(feature, flow_slug, flow_title, desc, html_screens, n))
    links = "".join(f'<a href="{flow_file}#s{i}" title="{slug}">[{i}] {slug}</a>' for i, (slug, _) in enumerate(blocks, 1))
    slugs = " → ".join(s for s, _ in blocks)
    entry = entry_html(feature, [(flow_file, flow_title, links, n)], n, fh)
    write(FEAT / feature / "html-wireframe" / f"{feature}-wireframe.html", entry)
    write(
        FEAT / feature / "html-wireframe" / f"{feature}-wireframe-html-index.md",
        index_md(feature, [(flow_file, flow_title, slugs, n, rel)], n, fh, spec_oqs(feature)),
    )


# ---------- userflows ----------
M = """classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107"""


def build_userflows() -> dict[str, str]:
    hashes = {}

    hashes["checkout"] = userflow_doc(
        "checkout",
        "Mượn tại quầy",
        f"""### Flow: checkout-flow — R1A

```mermaid
flowchart TD
    n1["[1] Quầy lưu thông"]
    n2["[2] Quét người đọc và bản sao"]
    n3["[3] Rà soát mượn"]
    d1{{"Người đọc đủ điều kiện?"}}
    d2{{"Bản sao hợp lệ để mượn?"}}
    d3{{"Commit nguyên tử thành công?"}}
    n4["[4] Xung đột checkout"]
    ok1["Biên nhận trên màn hình"]
    e1["E-core-006 — khóa, quá hạn, vượt 5 cuốn, nợ từ 50.000đ"]
    e2["E-checkout-001 — loại cuốn lỗi, giữ giỏ hợp lệ"]
    e3["E-core-003 — mã không tìm thấy"]

    n1 -->|"Bắt đầu mượn"| n2
    n2 -->|"Locate reader"| d1
    d1 -->|"Không"| e1
    e1 -.->|"Khắc phục hoặc đổi người đọc"| n2
    d1 -->|"Có"| d2
    d2 -->|"Không"| e2
    e2 -.->|"Quét cuốn khác"| n2
    n2 -->|"Mã không tồn tại"| e3
    e3 -.->|"Quét hoặc nhập lại"| n2
    d2 -->|"Giỏ hợp lệ"| n3
    n3 -->|"Xác nhận"| d3
    d3 -->|"Có"| ok1
    d3 -->|"Conflict E-core-004"| n4
    n4 -.->|"Tải trạng thái mới"| n3
    ok1 -.->|"Giao dịch mới"| n1

    {M}
    class n1,n2,n3,ok1 happy
    class e1,e2,e3 error
    class n4 edge
```""",
        [
            (1, "circulation-desk", "Quầy lưu thông", "Điểm vào mượn tại quầy.", "checkout-flow"),
            (2, "checkout-scan", "Quét checkout", "Quét thẻ và từng bản sao, kiểm tra D1/D2 ngay.", "checkout-flow"),
            (3, "checkout-review", "Rà soát mượn", "Xác nhận giỏ, commit nguyên tử, hiện biên nhận.", "checkout-flow"),
            (4, "checkout-conflict", "Xung đột checkout", "Hai quầy tranh bản sao — tải lại an toàn.", "checkout-flow"),
        ],
        [("checkout-flow", "Mượn tại quầy", "circulation-desk → checkout-scan → checkout-review → checkout-conflict")],
        [
            ("Quầy [1]", "Quét [2]", "Bắt đầu mượn", "Luôn"),
            ("Quét [2]", "(giữ) [2]", "Locate reader", "E-core-006 hoặc E-core-003"),
            ("Quét [2]", "Rà soát [3]", "Giỏ hợp lệ", "D1 và D2 đạt"),
            ("Rà soát [3]", "Xung đột [4]", "Xác nhận", "E-core-004"),
            ("Xung đột [4]", "Rà soát [3]", "Tải lại", "Luôn"),
            ("Rà soát [3]", "Quầy [1]", "Commit thành công", "Hiện biên nhận trên màn; in — OQ-checkout-001"),
        ],
    )

    hashes["return-handling"] = userflow_doc(
        "return-handling",
        "Trả sách",
        f"""### Flow: return-handling-flow — R1A

```mermaid
flowchart TD
    n1["[1] Quét trả sách"]
    d1{{"Kết quả kiểm tra bản sao?"}}
    n2["[2] Kết quả trả"]
    e1["E-core-008 — trạng thái không cho trả"]
    x1["Tiếp tục thu phạt — fine-collection-basic"]
    x2["Tiếp tục hư hỏng — damage-lifecycle"]
    x3["Tiếp tục mất — lost-handling"]

    n1 -->|"Quét bản sao"| d1
    d1 -->|"Trả bình thường"| n2
    d1 -->|"Quá hạn"| n2
    n2 -->|"Còn nợ phạt"| x1
    d1 -->|"Hư hỏng"| x2
    d1 -->|"Mất"| x3
    d1 -->|"Không hợp lệ"| e1
    e1 -.->|"Quét lại"| n1
    n2 -.->|"Trả cuốn tiếp"| n1

    {M}
    class n1,n2 happy
    class e1 error
    class x1,x2,x3 edge
```""",
        [
            (1, "return-scan", "Quét trả sách", "Nhận diện bản sao đang mượn và kiểm tra trạng thái.", "return-handling-flow"),
            (2, "return-result", "Kết quả trả", "Đóng khoản mượn, báo quá hạn hoặc hướng ngoại lệ.", "return-handling-flow"),
        ],
        [("return-handling-flow", "Trả tại quầy", "return-scan → return-result")],
        [
            ("Quét trả [1]", "Kết quả [2]", "Quét hợp lệ", "Bản sao đang mượn"),
            ("Quét trả [1]", "(giữ) [1]", "Quét", "E-core-008"),
            ("Kết quả [2]", "fine-collection-basic (chữ)", "Còn nợ", "Quá hạn đã ghi fine"),
            ("Quét trả [1]", "damage-lifecycle (chữ)", "Phát hiện hư", "Rẽ báo hư"),
            ("Quét trả [1]", "lost-handling (chữ)", "Ghi nhận mất", "Rẽ mất"),
        ],
    )

    hashes["damage-lifecycle"] = userflow_doc(
        "damage-lifecycle",
        "Báo cáo hư hỏng",
        f"""### Flow: damage-lifecycle-flow — R1A

```mermaid
flowchart TD
    n1["[1] Biểu mẫu báo hư hỏng"]
    d1{{"Dữ liệu và 1 đến 5 ảnh hợp lệ?"}}
    n2["[2] Chi tiết báo cáo hư hỏng"]
    e1["E-damage-lifecycle-001 — ảnh hoặc dữ liệu lỗi"]
    x1["Tính phí — fine-collection-basic"]
    x2["Ghi nhận mất — lost-handling"]
    s1["Step-up thanh lý"]

    n1 -->|"Gửi báo cáo"| d1
    d1 -->|"Có"| n2
    d1 -->|"Không"| e1
    e1 -.->|"Sửa"| n1
    n2 -->|"Tính phí"| x1
    n2 -->|"Chuyển mất"| x2
    n2 -->|"Thanh lý"| s1
    s1 -.->|"Xác thực lại"| n2

    {M}
    class n1,n2 happy
    class e1 error
    class x1,x2,s1 edge
```""",
        [
            (1, "damage-report-form", "Biểu mẫu hư hỏng", "Gửi báo cáo và 1–5 ảnh, cách ly bản sao.", "damage-lifecycle-flow"),
            (2, "damage-report-detail", "Chi tiết hư hỏng", "Duyệt disposition: sửa, tính phí, thanh lý, chuyển mất.", "damage-lifecycle-flow"),
        ],
        [("damage-lifecycle-flow", "Báo hư và duyệt", "damage-report-form → damage-report-detail")],
        [
            ("Form [1]", "Chi tiết [2]", "Gửi hợp lệ", "1–5 ảnh, dữ liệu đủ"),
            ("Form [1]", "(giữ) [1]", "Gửi", "E-damage-lifecycle-001"),
            ("Chi tiết [2]", "fine-collection-basic (chữ)", "Tính phí", "Sau duyệt"),
            ("Chi tiết [2]", "lost-handling (chữ)", "Chuyển mất", "Khi không sửa được"),
        ],
    )

    hashes["lost-handling"] = userflow_doc(
        "lost-handling",
        "Ghi nhận mất và tìm lại",
        f"""### Flow: lost-handling-flow — R1A/R1B

```mermaid
flowchart TD
    n1["[1] Ghi nhận mất — R1A"]
    d1{{"Ghi nhận hợp lệ?"}}
    n2["[2] Tìm lại sau khi mất — R1B"]
    e1["E-core-008 — trạng thái không cho ghi mất"]
    x1["Nghĩa vụ bồi thường — fine-collection-basic"]

    n1 -->|"Xác nhận mất"| d1
    d1 -->|"Có"| x1
    d1 -->|"Không"| e1
    e1 -.->|"Sửa"| n1
    x1 -.->|"R1B tìm lại"| n2
    n2 -->|"Đối soát nghĩa vụ"| x1

    {M}
    class n1 happy
    class e1 error
    class n2,x1 edge
```""",
        [
            (1, "lost-record", "Ghi nhận mất", "R1A: đóng khoản mượn theo mất, mở nghĩa vụ bồi thường tối thiểu.", "lost-handling-flow"),
            (2, "found-after-lost", "Tìm lại sau mất", "R1B: đối soát nghĩa vụ khi sách được tìm lại.", "lost-handling-flow"),
        ],
        [("lost-handling-flow", "Mất và tìm lại", "lost-record → found-after-lost")],
        [
            ("Ghi mất [1]", "fine-collection-basic (chữ)", "Xác nhận mất", "R1A P0"),
            ("Ghi mất [1]", "(giữ) [1]", "Xác nhận", "E-core-008"),
            ("Tìm lại [2]", "fine-collection-basic (chữ)", "Đối soát", "R1B"),
        ],
    )

    hashes["fine-collection-basic"] = userflow_doc(
        "fine-collection-basic",
        "Thu phạt tiền mặt",
        f"""### Flow: fine-collection-basic-flow — R1A

```mermaid
flowchart TD
    n1["[1] Danh sách công nợ"]
    n2["[2] Chi tiết công nợ"]
    n3["[3] Thanh toán tiền mặt"]
    d1{{"Thu hợp lệ, chưa trùng?"}}
    e1["E-fine-collection-basic-001 — số tiền không hợp lệ"]
    e2["E-fine-collection-basic-002 / E-core-005 — trùng giao dịch"]

    n1 -->|"Chọn khoản"| n2
    n2 -->|"Thu tiền mặt"| n3
    n3 -->|"Xác nhận"| d1
    d1 -->|"Có"| n2
    d1 -->|"Số không hợp lệ"| e1
    d1 -->|"Trùng"| e2
    e1 -.->|"Sửa số"| n3
    e2 -.->|"Xem kết quả gốc"| n2

    {M}
    class n1,n2,n3 happy
    class e1,e2 error
```""",
        [
            (1, "fine-list", "Danh sách công nợ", "Tra cứu khoản phạt của người đọc.", "fine-collection-basic-flow"),
            (2, "fine-detail", "Chi tiết công nợ", "Số dư và hành động thu được phép.", "fine-collection-basic-flow"),
            (3, "fine-payment", "Thanh toán tiền mặt", "Ghi nhận thu tiền mặt idempotent.", "fine-collection-basic-flow"),
        ],
        [("fine-collection-basic-flow", "Thu tiền mặt", "fine-list → fine-detail → fine-payment")],
        [
            ("Danh sách [1]", "Chi tiết [2]", "Chọn khoản", "Luôn"),
            ("Chi tiết [2]", "Thu [3]", "Thu tiền mặt", "R1A"),
            ("Thu [3]", "Chi tiết [2]", "Xác nhận", "Idempotent thành công"),
            ("Thu [3]", "(giữ) [3]", "Xác nhận", "E-fine-collection-basic-001"),
        ],
    )

    hashes["reader-self-service"] = userflow_doc(
        "reader-self-service",
        "Cổng người đọc",
        f"""### Flow: reader-portal-flow — R1A/R1B

```mermaid
flowchart TD
    n1["[1] Tra cứu sách"]
    n2["[2] Chi tiết đầu sách"]
    n3["[3] Thẻ QR"]
    n4["[4] Đang mượn"]
    n5["[5] Lịch sử mượn"]
    n6["[6] Công nợ của tôi — R1B"]
    e1["Empty — không có kết quả"]
    e2["Thẻ chưa kích hoạt — ẩn QR"]
    e3["E-core-002 — xem dữ liệu người khác"]

    n1 -->|"Chọn kết quả"| n2
    n1 -->|"Không khớp"| e1
    e1 -.->|"Đổi từ khóa"| n1
    n3 -->|"Thẻ không hiện"| e2
    n4 -->|"Lọc lịch sử"| n5
    n4 -->|"Xem công nợ R1B"| n6
    n2 -->|"Xem dữ liệu người khác"| e3

    {M}
    class n1,n2,n3,n4,n5 happy
    class e1,e2,e3 error
    class n6 edge
```""",
        [
            (1, "reader-search", "Tra cứu sách", "Tìm theo tên, tác giả, ISBN, thể loại; lọc còn/hết.", "reader-portal-flow"),
            (2, "reader-bib-detail", "Chi tiết đầu sách", "Chỉ xem thông tin, số khả dụng, vị trí kệ.", "reader-portal-flow"),
            (3, "reader-qr", "Thẻ QR", "Hiện mã QR khi tài khoản đã kích hoạt và thẻ còn hạn.", "reader-portal-flow"),
            (4, "reader-current-loans", "Đang mượn", "Phiếu mở, hạn trả, quá hạn.", "reader-portal-flow"),
            (5, "reader-loan-history", "Lịch sử mượn", "Phiếu đã đóng, lọc thời gian.", "reader-portal-flow"),
            (6, "reader-my-fines", "Công nợ của tôi", "R1B xem công nợ, không thanh toán online.", "reader-portal-flow"),
        ],
        [("reader-portal-flow", "Cổng người đọc", "reader-search → reader-bib-detail → reader-qr → reader-current-loans → reader-loan-history → reader-my-fines")],
        [
            ("Tra cứu [1]", "Chi tiết [2]", "Chọn kết quả", "Có bản ghi"),
            ("Tra cứu [1]", "(giữ) [1]", "Tìm", "Empty"),
            ("Thẻ QR [3]", "(giữ) [3]", "Mở thẻ", "Chưa kích hoạt thì ẩn QR"),
            ("Đang mượn [4]", "Lịch sử [5]", "Xem lịch sử", "Luôn"),
            ("Đang mượn [4]", "Công nợ [6]", "Xem công nợ", "R1B"),
        ],
    )

    hashes["notification-core"] = userflow_doc(
        "notification-core",
        "Trạng thái thông báo",
        f"""### Flow: notification-status-flow — R1A

```mermaid
flowchart TD
    n1["[1] Trạng thái thông báo"]
    d1{{"Gửi kênh ngoài thành công?"}}
    e1["E-notification-core-001 — retry"]
    e2["E-notification-core-002 — dead-letter"]
    ok1["Giao dịch nghiệp vụ đã commit"]

    n1 -->|"Xem outbox"| d1
    d1 -->|"Có"| ok1
    d1 -->|"Lỗi tạm"| e1
    e1 -.->|"Retry"| n1
    d1 -->|"Hết lần thử"| e2
    e2 -.->|"Xử lý hàng lỗi"| n1

    {M}
    class n1,ok1 happy
    class e1,e2 error
```""",
        [
            (1, "notification-status", "Trạng thái thông báo", "Outbox, retry, dead-letter; gửi lỗi không làm hỏng giao dịch chính.", "notification-status-flow"),
        ],
        [("notification-status-flow", "Outbox thông báo", "notification-status")],
        [
            ("Trạng thái [1]", "(giữ) [1]", "Retry", "E-notification-core-001"),
            ("Trạng thái [1]", "(giữ) [1]", "Dead-letter", "E-notification-core-002"),
        ],
    )

    hashes["ops-reports"] = userflow_doc(
        "ops-reports",
        "Báo cáo vận hành",
        f"""### Flow: ops-reports-flow — R1A/R1B

```mermaid
flowchart TD
    n1["[1] Dashboard báo cáo"]
    d1{{"Có quyền và có dữ liệu?"}}
    r1["RP-01, RP-02, RP-04"]
    n2["[2] Danh sách quá hạn Thủ thư — R1B"]
    e1["E-core-002 — không có quyền"]
    empty["Empty — chưa có dữ liệu kỳ"]

    n1 -->|"Tải"| d1
    d1 -->|"Có quyền R1A"| r1
    d1 -->|"Empty"| empty
    d1 -->|"Không quyền"| e1
    empty -.->|"Đổi lọc"| n1
    n1 -->|"R1B"| n2

    {M}
    class n1,r1 happy
    class e1 error
    class n2,empty edge
```""",
        [
            (1, "report-dashboard", "Dashboard báo cáo", "RP-01 tài khoản, RP-02 kho, RP-04 quá hạn; lọc; xuất Excel/PDF.", "ops-reports-flow"),
            (2, "overdue-list-staff", "Danh sách quá hạn", "R1B Thủ thư xem phiếu quá hạn để nhắc.", "ops-reports-flow"),
        ],
        [("ops-reports-flow", "Báo cáo vận hành", "report-dashboard → overdue-list-staff")],
        [
            ("Dashboard [1]", "(giữ) [1]", "Tải RP-01/02/04", "Có quyền và có dữ liệu"),
            ("Dashboard [1]", "(giữ) [1]", "Tải", "Empty hoặc E-core-002"),
            ("Dashboard [1]", "Quá hạn [2]", "Mở danh sách Thủ thư", "R1B"),
        ],
    )

    hashes["renewal"] = userflow_doc(
        "renewal",
        "Gia hạn",
        f"""### Flow: renewal-flow — R1B

```mermaid
flowchart TD
    n1["[1] Yêu cầu gia hạn"]
    d1{{"Đủ điều kiện gia hạn?"}}
    n2["[2] Kết quả gia hạn"]
    e1["Bị chặn — quá hạn, nợ, hàng chờ R2"]

    n1 -->|"Gửi yêu cầu quầy hoặc cổng"| d1
    d1 -->|"Có"| n2
    d1 -->|"Không"| e1
    e1 -.->|"Xem lý do"| n2

    {M}
    class n1,n2 happy
    class e1 error
```""",
        [
            (1, "renewal-request", "Yêu cầu gia hạn", "Thủ thư tại quầy hoặc Người đọc trên cổng chọn khoản đang mượn.", "renewal-flow"),
            (2, "renewal-result", "Kết quả gia hạn", "Thành công hoặc lý do chặn. Số lần/cộng ngày còn OQ-renewal-001.", "renewal-flow"),
        ],
        [("renewal-flow", "Gia hạn quầy và online", "renewal-request → renewal-result")],
        [
            ("Yêu cầu [1]", "Kết quả [2]", "Gửi", "Luôn"),
            ("Yêu cầu [1]", "Kết quả [2]", "Gửi", "Bị chặn — hiện lý do"),
        ],
    )

    hashes["fine-collection-adv"] = userflow_doc(
        "fine-collection-adv",
        "Thu phạt nâng cao",
        f"""### Flow: fine-adv-flow — R1B

```mermaid
flowchart TD
    n1["[1] Sự kiện tài chính"]
    n2["[2] Miễn / điều chỉnh / hoàn"]
    n3["[3] Biên nhận thu phạt"]
    d1{{"Step-up và quyền hợp lệ?"}}
    e1["E-core-002 / audit fail"]

    n1 -->|"Tác vụ nâng cao"| n2
    n2 -->|"Xác thực lại"| d1
    d1 -->|"Có"| n3
    d1 -->|"Không"| e1
    e1 -.->|"Hủy"| n1
    n3 -.->|"Quay ledger"| n1

    {M}
    class n1,n3 happy
    class e1 error
    class n2 edge
```""",
        [
            (1, "financial-events", "Sự kiện tài chính", "Ledger khoản phạt và sự kiện thu/miễn/điều chỉnh.", "fine-adv-flow"),
            (2, "fine-adjust", "Miễn điều chỉnh hoàn", "Step-up re-auth cho waiver/adjustment/refund.", "fine-adv-flow"),
            (3, "fine-receipt", "Biên nhận thu phạt", "R1B loại biên nhận thu phạt.", "fine-adv-flow"),
        ],
        [("fine-adv-flow", "Tài chính nâng cao", "financial-events → fine-adjust → fine-receipt")],
        [
            ("Ledger [1]", "Điều chỉnh [2]", "Tác vụ R1B", "Cần step-up"),
            ("Điều chỉnh [2]", "Biên nhận [3]", "Duyệt thành công", "Quyền và re-auth"),
            ("Điều chỉnh [2]", "Ledger [1]", "Thất bại", "E-core-002"),
        ],
    )

    hashes["notification-audit-ui"] = userflow_doc(
        "notification-audit-ui",
        "Trung tâm thông báo và audit",
        f"""### Flow: notification-audit-flow — R1B

```mermaid
flowchart TD
    n1["[1] Trung tâm thông báo"]
    n2["[2] Nhật ký audit"]
    n3["[3] Dòng thời gian lịch sử"]
    d1{{"Có quyền đọc?"}}
    e1["E-core-002 / E-core-009 — mask hoặc từ chối"]

    n1 -->|"Mở audit"| n2
    n2 -->|"Mở resource"| d1
    d1 -->|"Có"| n3
    d1 -->|"Không"| e1
    e1 -.->|"Quay lại đã redacted"| n2
    n3 -.->|"Quay audit"| n2

    {M}
    class n1,n2,n3 happy
    class e1 error
```""",
        [
            (1, "notification-center", "Trung tâm thông báo", "Hộp thư in-app mọi vai trò — DEC-SF-09, màn mới.", "notification-audit-flow"),
            (2, "audit-log", "Nhật ký audit", "Tra cứu hành động nhạy cảm.", "notification-audit-flow"),
            (3, "history-timeline", "Dòng thời gian", "Lịch sử resource đã redacted theo quyền.", "notification-audit-flow"),
        ],
        [("notification-audit-flow", "Thông báo và audit viewer", "notification-center → audit-log → history-timeline")],
        [
            ("Trung tâm [1]", "Audit [2]", "Mở nhật ký", "Quản trị viên"),
            ("Audit [2]", "Timeline [3]", "Mở resource", "Có quyền"),
            ("Audit [2]", "(giữ) [2]", "Mở resource", "E-core-002 / E-core-009"),
        ],
    )

    hashes["reservation"] = userflow_doc(
        "reservation",
        "Đặt trước",
        f"""### Flow: reservation-flow — R2

```mermaid
flowchart TD
    n1["[1] Tìm tài liệu đặt trước"]
    n2["[2] Biểu mẫu đặt trước"]
    n3["[3] Hàng đợi đặt trước"]
    n4["[4] Nhận bản giữ"]
    d1{{"Reservation còn hợp lệ?"}}
    e1["E-reservation-001 — conflict"]
    empty["Empty — chưa có hàng đợi"]
    x1["Checkout — chữ"]

    n1 -->|"Chọn"| n2
    n2 -->|"Gửi"| d1
    d1 -->|"Có"| n3
    d1 -->|"Không"| e1
    e1 -.->|"Sửa"| n2
    n3 -->|"Đến lượt"| n4
    n3 -->|"Hủy"| empty
    n4 -->|"Nhận sách"| x1
    empty -.->|"Tạo mới"| n1

    {M}
    class n1,n2,n3,n4 happy
    class e1 error
    class empty,x1 edge
```""",
        [
            (1, "reservation-search", "Tìm đặt trước", "Chọn tài liệu cho reservation, quầy hoặc cổng.", "reservation-flow"),
            (2, "reservation-form", "Biểu mẫu đặt trước", "Gửi yêu cầu giữ chỗ.", "reservation-flow"),
            (3, "reservation-queue", "Hàng đợi", "Vị trí, hủy, empty state.", "reservation-flow"),
            (4, "reservation-pickup", "Nhận bản giữ", "Pickup, hủy hoặc hết hạn; tiếp tục checkout.", "reservation-flow"),
        ],
        [("reservation-flow", "Đặt trước trọn vòng", "reservation-search → reservation-form → reservation-queue → reservation-pickup")],
        [
            ("Tìm [1]", "Form [2]", "Chọn tài liệu", "Luôn"),
            ("Form [2]", "Hàng đợi [3]", "Gửi hợp lệ", "Còn slot"),
            ("Form [2]", "(giữ) [2]", "Gửi", "E-reservation-001"),
            ("Hàng đợi [3]", "Nhận [4]", "Đến lượt còn hạn", "Hold còn hạn"),
            ("Nhận [4]", "checkout (chữ)", "Nhận sách", "Tiếp tục mượn"),
        ],
    )

    hashes["trend-reports"] = userflow_doc(
        "trend-reports",
        "Báo cáo xu hướng",
        f"""### Flow: trend-reports-flow — R2

```mermaid
flowchart TD
    n1["[1] Dashboard xu hướng"]
    d1{{"Có quyền và có dữ liệu?"}}
    r1["RP-03, RP-05, RP-06, RP-07"]
    e1["E-core-002"]
    empty["Empty kỳ"]

    n1 -->|"Tải"| d1
    d1 -->|"Có"| r1
    d1 -->|"Empty"| empty
    d1 -->|"Không quyền"| e1
    empty -.->|"Đổi lọc"| n1

    {M}
    class n1,r1 happy
    class e1 error
    class empty edge
```""",
        [
            (1, "trend-dashboard", "Dashboard xu hướng", "RP-03 lưu thông, RP-05 phạt, RP-06 top/không mượn, RP-07 hư hỏng; xuất Excel/PDF.", "trend-reports-flow"),
        ],
        [("trend-reports-flow", "Báo cáo xu hướng", "trend-dashboard")],
        [
            ("Dashboard [1]", "(giữ) [1]", "Tải RP", "Có quyền"),
            ("Dashboard [1]", "(giữ) [1]", "Tải", "Empty hoặc E-core-002"),
        ],
    )
    return hashes


def inner_from_lmp(src: Path, slug: str) -> str:
    screens = extract_screens(src)
    if slug not in screens:
        raise SystemExit(f"missing screen {slug} in {src}")
    _num, inner = screens[slug]
    return inner


def fake_inner(bar: str, title: str, body: str) -> str:
    return f"""
    <div class="wf-step-badge">0</div><div class="wf-device-tag">mobile · 375px</div>
    <div class="wf-screen-frame"><div class="wf-screen-bar"><div class="wf-dot"></div><div class="wf-dot"></div><div class="wf-dot"></div><span class="wf-bar-title">{bar}</span></div>
      <div class="wf-screen-content"><div class="wf-app-brand">HỆ THỐNG QUẢN LÝ THƯ VIỆN</div><div class="wf-screen-title">{title}</div>
        {body}
      </div></div>"""


def build_wireframes(hashes: dict[str, str]) -> None:
    L = FEAT / "library-management-platform" / "html-wireframe"
    emit_wf(
        "checkout",
        "checkout-flow",
        "Mượn tại quầy",
        "Quét thẻ và bản sao, commit nguyên tử, biên nhận trên màn. Máy in/khổ giấy còn OQ-checkout-001.",
        [
            ("circulation-desk", inner_from_lmp(L / "checkout-flow.html", "circulation-desk")),
            ("checkout-scan", inner_from_lmp(L / "checkout-flow.html", "checkout-scan")),
            ("checkout-review", inner_from_lmp(L / "checkout-flow.html", "checkout-review")),
            ("checkout-conflict", inner_from_lmp(L / "checkout-flow.html", "checkout-conflict")),
        ],
        "R1A",
        hashes["checkout"],
    )
    emit_wf(
        "return-handling",
        "return-handling-flow",
        "Trả tại quầy",
        "Quét trả, đóng khoản mượn; rẽ phạt/hư/mất sang feature tương ứng.",
        [
            ("return-scan", inner_from_lmp(L / "return-renewal-flow.html", "return-scan")),
            ("return-result", inner_from_lmp(L / "return-renewal-flow.html", "return-result")),
        ],
        "R1A",
        hashes["return-handling"],
    )
    emit_wf(
        "damage-lifecycle",
        "damage-lifecycle-flow",
        "Báo hư và duyệt",
        "Gửi 1–5 ảnh, cách ly bản sao, duyệt disposition.",
        [
            ("damage-report-form", inner_from_lmp(L / "damage-lost-found-flow.html", "damage-report-form")),
            ("damage-report-detail", inner_from_lmp(L / "damage-lost-found-flow.html", "damage-report-detail")),
        ],
        "R1A",
        hashes["damage-lifecycle"],
    )
    lost_src = inner_from_lmp(L / "damage-lost-found-flow.html", "lost-found")
    emit_wf(
        "lost-handling",
        "lost-handling-flow",
        "Mất và tìm lại",
        "R1A ghi nhận mất tối thiểu; R1B tìm lại. Mức bồi thường còn OQ.",
        [
            ("lost-record", lost_src),
            (
                "found-after-lost",
                fake_inner(
                    "Tìm lại",
                    "Tìm lại sau khi mất — R1B",
                    '<div class="banner banner-info">Đối soát nghĩa vụ bồi thường khi sách được tìm lại. Mức hoàn/cấn trừ còn OQ-lost-handling-001.</div><button class="btn-primary" type="button">Ghi nhận tìm lại</button><p class="hint-text">Thu phạt chi tiết thuộc fine-collection-basic / fine-collection-adv.</p>',
                ),
            ),
        ],
        "R1A/R1B",
        hashes["lost-handling"],
    )
    emit_wf(
        "fine-collection-basic",
        "fine-collection-basic-flow",
        "Thu tiền mặt",
        "List/detail/thu tiền mặt idempotent. Không gồm ledger nâng cao.",
        [
            ("fine-list", inner_from_lmp(L / "fine-payment-flow.html", "fine-list")),
            ("fine-detail", inner_from_lmp(L / "fine-payment-flow.html", "fine-detail")),
            ("fine-payment", inner_from_lmp(L / "fine-payment-flow.html", "fine-payment")),
        ],
        "R1A",
        hashes["fine-collection-basic"],
    )
    emit_wf(
        "renewal",
        "renewal-flow",
        "Gia hạn",
        "Quầy và cổng người đọc — R1B. Số lần/cộng ngày còn OQ-renewal-001.",
        [
            (
                "renewal-request",
                fake_inner(
                    "Yêu cầu gia hạn",
                    "Chọn khoản đang mượn",
                    '<p class="info-label">Thủ thư tại quầy hoặc Người đọc trên cổng.</p><div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">Giải tích 1</div><div class="wf-card-sub">Hạn trả hiện tại · không quá hạn</div></div></div><button class="btn-primary" type="button">Gửi yêu cầu gia hạn</button><p class="hint-text">Hàng chờ đặt trước chặn gia hạn tới R2 — DEC-P2-05.</p>',
                ),
            ),
            ("renewal-result", inner_from_lmp(L / "return-renewal-flow.html", "renewal-result")),
        ],
        "R1B",
        hashes["renewal"],
    )
    emit_wf(
        "fine-collection-adv",
        "fine-adv-flow",
        "Tài chính nâng cao",
        "Ledger, miễn/điều chỉnh/hoàn + step-up, biên nhận thu phạt R1B.",
        [
            ("financial-events", inner_from_lmp(L / "fine-payment-flow.html", "financial-events")),
            (
                "fine-adjust",
                fake_inner(
                    "Điều chỉnh",
                    "Miễn / điều chỉnh / hoàn — R1B",
                    '<div class="banner banner-warn">Cần xác thực lại. Chính sách còn OQ-fine-collection-adv-001.</div><button class="btn-primary" type="button">Xác thực lại rồi ghi</button><button class="btn-secondary" type="button">Hủy</button>',
                ),
            ),
            (
                "fine-receipt",
                fake_inner(
                    "Biên nhận",
                    "Biên nhận thu phạt",
                    '<p class="info-label">R1B. Mẫu giấy còn OQ-fine-collection-adv-003.</p><div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">Biên nhận #—</div><div class="wf-card-sub">Số tiền · người đọc · thời điểm</div></div></div><button class="btn-secondary" type="button">In (máy/khổ OQ)</button>',
                ),
            ),
        ],
        "R1B",
        hashes["fine-collection-adv"],
    )
    emit_wf(
        "notification-core",
        "notification-status-flow",
        "Outbox thông báo",
        "Theo dõi gửi, retry, dead-letter. Gửi lỗi không rollback giao dịch chính.",
        [("notification-status", inner_from_lmp(L / "notification-audit-flow.html", "notification-status"))],
        "R1A",
        hashes["notification-core"],
    )
    emit_wf(
        "notification-audit-ui",
        "notification-audit-flow",
        "Trung tâm thông báo và audit",
        "Hộp thư in-app (mới DEC-SF-09), nhật ký audit, timeline redacted.",
        [
            (
                "notification-center",
                fake_inner(
                    "Thông báo",
                    "Trung tâm thông báo",
                    '<div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">Sắp đến hạn</div><div class="wf-card-sub">In-app · chưa đọc</div></div></div><div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">Phát sinh phạt</div><div class="wf-card-sub">In-app + email</div></div></div><p class="hint-text">Giữ bao lâu / đánh dấu chưa đọc — OQ-notification-audit-ui-001. Retry gửi thuộc notification-core.</p>',
                ),
            ),
            ("audit-log", inner_from_lmp(L / "notification-audit-flow.html", "audit-log")),
            ("history-timeline", inner_from_lmp(L / "notification-audit-flow.html", "history-timeline")),
        ],
        "R1B",
        hashes["notification-audit-ui"],
    )
    emit_wf(
        "reservation",
        "reservation-flow",
        "Đặt trước trọn vòng",
        "Quầy và cổng người đọc — R2. Giới hạn/giữ chỗ còn OQ-reservation-002.",
        [
            ("reservation-search", inner_from_lmp(L / "reservation-flow.html", "reservation-search")),
            ("reservation-form", inner_from_lmp(L / "reservation-flow.html", "reservation-form")),
            ("reservation-queue", inner_from_lmp(L / "reservation-flow.html", "reservation-queue")),
            ("reservation-pickup", inner_from_lmp(L / "reservation-flow.html", "reservation-pickup")),
        ],
        "R2",
        hashes["reservation"],
    )
    emit_wf(
        "ops-reports",
        "ops-reports-flow",
        "Báo cáo vận hành",
        "RP-01/02/04 và danh sách quá hạn Thủ thư R1B. Không gồm xu hướng R2.",
        [
            ("report-dashboard", inner_from_lmp(L / "reports-flow.html", "report-dashboard")),
            (
                "overdue-list-staff",
                fake_inner(
                    "Quá hạn",
                    "Danh sách quá hạn — R1B",
                    '<div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">Phiếu quá hạn</div><div class="wf-card-sub">Người đọc · số ngày · đầu sách</div></div></div><p class="hint-text">Quyền Thủ thư xem RP-01/02/04 còn OQ-ops-reports-001.</p><button class="btn-secondary" type="button">Xuất Excel</button>',
                ),
            ),
        ],
        "R1A/R1B",
        hashes["ops-reports"],
    )
    emit_wf(
        "trend-reports",
        "trend-reports-flow",
        "Báo cáo xu hướng",
        "RP-03/05/06/07. Số sách top còn OQ-trend-reports-001.",
        [
            (
                "trend-dashboard",
                fake_inner(
                    "Xu hướng",
                    "Dashboard xu hướng — R2",
                    '<div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">RP-03 Lượt mượn/trả</div><div class="wf-card-sub">Ngày / tháng / năm</div></div></div><div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">RP-05 Phạt</div><div class="wf-card-sub">Phát sinh · đã thu · chưa thu · miễn</div></div></div><div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">RP-06 Top / không mượn</div><div class="wf-card-sub">Top N còn OQ-trend-reports-001</div></div></div><div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">RP-07 Hư hỏng</div><div class="wf-card-sub">Duyệt · thanh lý trong kỳ</div></div></div><button class="btn-primary" type="button">Xuất Excel</button><button class="btn-secondary" type="button">Xuất PDF</button>',
                ),
            )
        ],
        "R2",
        hashes["trend-reports"],
    )
    # reader portal — all new
    rss = [
        ("reader-search", "Tra cứu", "Tìm sách", '<div class="field"><label>Từ khóa</label><input type="text" placeholder="Tên, tác giả, ISBN"></div><button class="btn-primary" type="button">Tìm</button><div class="banner banner-info">Lọc còn/hết. Tra cứu quản trị thuộc catalog-admin.</div>'),
        ("reader-bib-detail", "Chi tiết", "Đầu sách", '<div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">Giải tích 1</div><div class="wf-card-sub">Khả dụng 2 · kệ A1 · chỉ xem</div></div></div><p class="hint-text">Đặt trước / gia hạn online là feature khác (chữ).</p>'),
        ("reader-qr", "Thẻ QR", "Thẻ thư viện", '<div class="icon-lg">(QR)</div><p class="info-label">Chỉ hiện khi đã kích hoạt và thẻ còn hạn.</p><div class="banner banner-warn">Thẻ chưa kích hoạt — ẩn QR.</div>'),
        ("reader-current-loans", "Đang mượn", "Khoản đang mở", '<div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">Giải tích 1</div><div class="wf-card-sub">Hạn trả · còn N ngày</div></div></div>'),
        ("reader-loan-history", "Lịch sử", "Phiếu đã đóng", '<div class="field"><label>Khoảng thời gian</label><input type="text" placeholder="Từ — đến"></div><div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">Đã trả</div><div class="wf-card-sub">Ngày đóng phiếu</div></div></div>'),
        ("reader-my-fines", "Công nợ", "Công nợ của tôi — R1B", '<div class="wf-card"><div class="wf-card-body"><div class="wf-card-title">Phạt quá hạn</div><div class="wf-card-sub">Chưa thanh toán · không thu online</div></div></div>'),
    ]
    emit_wf(
        "reader-self-service",
        "reader-portal-flow",
        "Cổng người đọc",
        "Tra cứu, thẻ QR, đang mượn, lịch sử (R1A) và công nợ tối thiểu (R1B). Thiết bị cổng còn OQ-reader-self-service-001; Max chốt khung Mobile 375.",
        [(slug, fake_inner(bar, title, body)) for slug, bar, title, body in rss],
        "R1A/R1B",
        hashes["reader-self-service"],
    )


def fr_link(fr: str) -> str:
    # FR-checkout-001 -> feature checkout
    m = re.match(r"FR-([a-z0-9-]+)-(\d+)", fr)
    if not m:
        return fr
    feat = m.group(1)
    return f"[[docs/features/{feat}/srs/{feat}-spec.md#{fr}|{fr}]]"


def story_file(feature: str, num: int, title: str, persona: str, body: str) -> None:
    write(FEAT / feature / "userstories" / f"us-{num:03d}.md", body)


def transfer_story(src_us: str, dest_feat: str, dest_num: int, persona: str | None = None) -> str:
    src = (FEAT / "library-management-platform" / "userstories" / src_us).read_text(encoding="utf-8")
    src = remap(src)
    src = src.replace("{FEAT_PLACEHOLDER}", dest_feat)
    src = src.replace(
        f"docs/features/{dest_feat}/srs/{dest_feat}-spec.md#",
        "NEEDFIX#",
    )
    # fix FR links to correct feature folders using ID_MAP values
    def repl_fr(m):
        fr = m.group(0)
        return fr_link(fr)

    src = re.sub(r"FR-[a-z0-9-]+-\d+", lambda m: m.group(0), src)
    src = src.replace(
        f"[[docs/features/{dest_feat}/html-wireframe/",
        f"[[docs/features/{dest_feat}/html-wireframe/",
    )
    src = src.replace(
        "docs/features/library-management-platform/html-wireframe/",
        f"docs/features/{dest_feat}/html-wireframe/",
    )
    src = src.replace(
        "docs/features/library-management-platform/usecases/",
        f"docs/features/{dest_feat}/usecases/",
    )
    if persona:
        src = re.sub(r"Với vai trò \*\*[^*]+\*\*", f"Với vai trò **{persona}**", src, count=1)
    # restore cross-feature FR links: replace NEEDFIX by scanning FR- in covers
    src = src.replace("NEEDFIX#", f"docs/features/{dest_feat}/srs/{dest_feat}-spec.md#")
    src = src.replace(
        f"docs/features/{dest_feat}/srs/{dest_feat}-spec.md#FR-",
        f"docs/features/{dest_feat}/srs/{dest_feat}-spec.md#FR-",
    )
    # point wiki FR to owning spec when feature in ID differs
    def wiki_fr(m):
        fr = m.group(1)
        own = re.match(r"FR-([a-z0-9-]+)-\d+", fr)
        if not own:
            return m.group(0)
        of = own.group(1)
        return f"[[docs/features/{of}/srs/{of}-spec.md#{fr}|{fr}]]"

    src = re.sub(
        rf"\[\[docs/features/{dest_feat}/srs/{dest_feat}-spec.md#(FR-[a-z0-9-]+-\d+)\|{re.escape('FR-')}[^\]]+\]\]",
        wiki_fr,
        src,
    )
    src = re.sub(
        r"\[\[docs/features/[^]]+#(FR-[a-z0-9-]+-\d+)\|[^\]]+\]\]",
        wiki_fr,
        src,
    )
    write(FEAT / dest_feat / "userstories" / f"us-{dest_num:03d}.md", src)
    # title
    tm = re.search(r"^# US-\d+: (.+)$", src, re.M)
    return tm.group(1) if tm else f"US-{dest_num:03d}"


def new_story(feature: str, num: int, title: str, persona: str, frs: list[str], screens: str, acs: list[tuple], oq: str) -> str:
    fr_rows = "\n".join(f"| {fr_link(fr)} | P0 | từ spec |" for fr in frs)
    ac_blocks = []
    for i, (typ, covers, screen, gherkin) in enumerate(acs, 1):
        ac_blocks.append(
            f"""### AC-{i:03d} — {covers}

* **Type:** {typ}
* **Covers:** {covers}
* **Screen:** `{screen}`

```gherkin
{gherkin}
```"""
        )
    body = f"""<!-- built from draft SRS, may need refinement -->

# US-{num:03d}: {title}

## User Story

Với vai trò **{persona}**, tôi muốn {title.lower()}, để hoàn thành nghĩa vụ nghiệp vụ đã ghi trong spec.

## Context

Chuyển từ spec feature `{feature}`. Không bịa ngưỡng còn OQ.

**Trong phạm vi:** outcome đã có FR.

**Ngoài phạm vi:** số liệu PROPOSAL/OQ.

## Linked Requirements

| FR | Priority | Notes |
|---|---|---|
{fr_rows}

## Acceptance Criteria

{chr(10).join(ac_blocks)}

## UI / Screen References

- {screens}

## Open Questions

- {oq}
"""
    write(FEAT / feature / "userstories" / f"us-{num:03d}.md", body)
    return title


def write_index(feature: str, rows: list[tuple]) -> None:
    # rows: num, title, persona, fr, screens, pri
    table = "\n".join(
        f"| {n} | [US-{n:03d}](us-{n:03d}.md) | {title} | {persona} | {fr} | {screens} | {pri} | draft | — | {TODAY} |"
        for n, title, persona, fr, screens, pri in rows
    )
    md = f"""---
type: userstory-index
feature: {feature}
status: draft
updated: {TODAY}
links:
  - docs/features/{feature}/srs/{feature}-spec.md
---

# {feature} — User Stories Index

> Backlog draft từ SRS `draft`. Story cần refinement trước Definition of Ready. Persona theo DEC-SF-08.

## User Stories

| # | ID | Title | Persona | Covers FR | Screens | Priority | Status | Jira | Updated |
|---|----|-------|---------|-----------|---------|----------|--------|------|---------|
{table}
"""
    write(FEAT / feature / "userstories" / f"{feature}-story-index.md", md)


def build_stories() -> None:
    mapping = [
        ("us-001.md", "access-control", 1, "Người dùng"),
        ("us-002.md", "access-control", 2, "Người dùng đã đăng nhập"),
        ("us-003.md", "catalog-admin", 1, "Quản trị viên"),
        ("us-005.md", "catalog-admin", 2, "Thủ thư"),
        ("us-004.md", "copy-inventory", 1, "Quản trị viên"),
        ("us-006.md", "reader-onboarding", 1, "Thủ thư"),
        ("us-007.md", "policy-config", 1, "Quản trị viên"),
        ("us-008.md", "data-import", 1, "Quản trị viên"),
        ("us-009.md", "data-import", 2, "Quản trị viên"),
        ("us-010.md", "ops-foundation", 1, "Hệ thống"),
        ("us-011.md", "checkout", 1, "Thủ thư"),
        ("us-012.md", "return-handling", 1, "Thủ thư"),
        ("us-013.md", "overdue-fines", 1, "Hệ thống"),
        ("us-014.md", "fine-collection-basic", 1, "Thủ thư"),
        ("us-015.md", "damage-lifecycle", 1, "Thủ thư"),
        ("us-016.md", "damage-lifecycle", 2, "Quản trị viên"),
        ("us-017.md", "lost-handling", 1, "Thủ thư"),
        ("us-018.md", "notification-core", 1, "Hệ thống"),
    ]
    titles: dict[tuple[str, int], str] = {}
    for src, feat, num, persona in mapping:
        titles[(feat, num)] = transfer_story(src, feat, num, persona)

    titles[("access-control", 3)] = new_story(
        "access-control",
        3,
        "Khôi phục mật khẩu khi quên",
        "Người dùng",
        ["FR-access-control-003"],
        "`forgot-password`, `reset-password`",
        [
            (
                "happy-path",
                "FR-access-control-003",
                "forgot-password",
                "Given người dùng yêu cầu khôi phục\nWhen gửi định danh\nThen hệ thống thông báo trung tính và chỉ gửi hướng dẫn nếu tài khoản hợp lệ",
            )
        ],
        "🔴 OQ-access-control-001 mô hình danh tính",
    )
    titles[("ops-foundation", 2)] = new_story(
        "ops-foundation",
        2,
        "Backup hằng ngày và diễn tập khôi phục",
        "Hệ thống",
        ["FR-ops-foundation-002"],
        "không có màn",
        [
            (
                "happy-path",
                "FR-ops-foundation-002",
                "—",
                "Given hệ thống vận hành\nWhen tới lịch backup ngày\nThen có bản backup mới và giữ tối đa 30 bản gần nhất",
            )
        ],
        "🔴 OQ-ops-foundation-001 owner vận hành",
    )
    titles[("account-admin", 1)] = new_story(
        "account-admin",
        1,
        "Cập nhật và xóa mềm hồ sơ người đọc",
        "Quản trị viên",
        ["FR-account-admin-001"],
        "`reader-list`, `reader-form`, `reader-detail`",
        [
            (
                "happy-path",
                "FR-account-admin-001",
                "reader-form",
                "Given Quản trị viên mở hồ sơ người đọc\nWhen lưu thay đổi hợp lệ\nThen hồ sơ được cập nhật và có audit",
            )
        ],
        "🔴 OQ-account-admin-001 ai quản lý Quản trị viên",
    )
    titles[("account-admin", 2)] = new_story(
        "account-admin",
        2,
        "Quản lý tài khoản Thủ thư",
        "Quản trị viên",
        ["FR-account-admin-003"],
        "`reader-list` (tài khoản nội bộ)",
        [
            (
                "happy-path",
                "FR-account-admin-003",
                "—",
                "Given Quản trị viên có quyền\nWhen tạo hoặc khóa tài khoản Thủ thư\nThen tài khoản đổi trạng thái, không xóa cứng nếu đã có lịch sử, và có audit",
            )
        ],
        "🔴 OQ-account-admin-001",
    )
    titles[("account-admin", 3)] = new_story(
        "account-admin",
        3,
        "Thủ thư khóa tạm người đọc",
        "Thủ thư",
        ["FR-account-admin-002"],
        "`reader-detail`",
        [
            (
                "permission",
                "FR-account-admin-002",
                "reader-detail",
                "Given Thủ thư có quyền R1B\nWhen khóa tạm người đọc\nThen tài khoản bị khóa tạm và có audit",
            )
        ],
        "🟢 R1B P1 theo DEC-SF-04",
    )
    titles[("checkout", 2)] = new_story(
        "checkout",
        2,
        "Hiển thị biên nhận mượn trên màn hình",
        "Thủ thư",
        ["FR-checkout-003"],
        "`checkout-review`",
        [
            (
                "happy-path",
                "FR-checkout-003",
                "checkout-review",
                "Given phiếu mượn ghi thành công\nWhen hệ thống hiện biên nhận\nThen Thủ thư thấy hạn trả từng cuốn trên màn; in giấy còn OQ-checkout-001",
            )
        ],
        "🔴 OQ-checkout-001 khổ giấy/máy in",
    )
    titles[("lost-handling", 2)] = new_story(
        "lost-handling",
        2,
        "Đối soát khi tìm lại sách đã mất",
        "Thủ thư",
        ["FR-lost-handling-002"],
        "`found-after-lost`",
        [
            (
                "happy-path",
                "FR-lost-handling-002",
                "found-after-lost",
                "Given sách đã ghi mất được tìm lại\nWhen Thủ thư ghi nhận tìm lại\nThen hệ thống đối soát nghĩa vụ bồi thường theo policy đã chốt",
            )
        ],
        "🔴 OQ-lost-handling-001 mức bồi thường",
    )
    rss_stories = [
        (1, "Tra cứu sách trên cổng người đọc", "Người đọc", ["FR-reader-self-service-001"], "reader-search", "Given Người đọc đã đăng nhập\nWhen tìm sách theo từ khóa\nThen chỉ thấy đầu sách khớp và số khả dụng, không thấy form quản trị"),
        (2, "Xem sách đang mượn của mình", "Người đọc", ["FR-reader-self-service-002"], "reader-current-loans", "Given Người đọc có phiếu mở\nWhen mở đang mượn\nThen thấy hạn trả của chính mình, không thấy người khác"),
        (3, "Mở thẻ QR cá nhân", "Người đọc", ["FR-reader-self-service-004"], "reader-qr", "Given thẻ đã kích hoạt còn hạn\nWhen mở thẻ QR\nThen mã hiện để Thủ thư quét; thẻ chưa kích hoạt thì không hiện QR"),
        (4, "Xem lịch sử mượn", "Người đọc", ["FR-reader-self-service-005"], "reader-loan-history", "Given Người đọc có phiếu đã đóng\nWhen lọc khoảng thời gian\nThen chỉ thấy lịch sử của chính mình"),
        (5, "Xem công nợ của mình", "Người đọc", ["FR-reader-self-service-003"], "reader-my-fines", "Given có khoản phạt\nWhen mở công nợ R1B\nThen thấy trạng thái đã/chưa thanh toán, không thu online"),
    ]
    for num, title, persona, frs, screen, g in rss_stories:
        titles[("reader-self-service", num)] = new_story(
            "reader-self-service", num, title, persona, frs, f"`{screen}`", [("happy-path", frs[0], screen, g)], "🔴 giữ OQ cổng/thiết bị"
        )
    extras = [
        ("ops-reports", 1, "Xem báo cáo vận hành RP-01/02/04", "Quản trị viên", ["FR-ops-reports-001"], "report-dashboard"),
        ("ops-reports", 2, "Xem danh sách quá hạn tại quầy", "Thủ thư", ["FR-ops-reports-002"], "overdue-list-staff"),
        ("renewal", 1, "Gia hạn khoản đang mượn", "Thủ thư", ["FR-renewal-001"], "renewal-request"),
        ("reservation", 1, "Đặt trước và nhận bản giữ", "Người đọc", ["FR-reservation-001", "FR-reservation-002"], "reservation-queue"),
        ("reservation", 2, "Đặt trước trên cổng người đọc", "Người đọc", ["FR-reservation-003"], "reservation-form"),
        ("fine-collection-adv", 1, "Xuất biên nhận thu phạt", "Thủ thư", ["FR-fine-collection-adv-001"], "fine-receipt"),
        ("fine-collection-adv", 2, "Miễn điều chỉnh hoặc hoàn tiền phạt", "Quản trị viên", ["FR-fine-collection-adv-002"], "fine-adjust"),
        ("notification-audit-ui", 1, "Đọc thông báo in-app", "Người dùng", ["FR-notification-audit-ui-001"], "notification-center"),
        ("notification-audit-ui", 2, "Xem nhật ký audit", "Quản trị viên", ["FR-notification-audit-ui-002"], "audit-log"),
        ("trend-reports", 1, "Xem báo cáo xu hướng", "Quản trị viên", ["FR-trend-reports-001"], "trend-dashboard"),
        ("copy-inventory", 2, "Sinh QR hàng loạt và in nhãn", "Quản trị viên", ["FR-copy-inventory-003"], "copy-form"),
        ("catalog-admin", 3, "Quản lý danh mục thể loại", "Quản trị viên", ["FR-catalog-admin-003"], "bibliographic-form"),
        ("access-control", 4, "Cập nhật hồ sơ cá nhân", "Người dùng", ["FR-access-control-004"], "dashboard-home"),
    ]
    for feat, num, title, persona, frs, screen in extras:
        titles[(feat, num)] = new_story(
            feat,
            num,
            title,
            persona,
            frs,
            f"`{screen}`" if screen != "—" else "không có màn",
            [
                (
                    "happy-path",
                    frs[0],
                    screen,
                    f"Given actor đúng vai trò\nWhen hoàn thành {title.lower()}\nThen kết quả nghiệp vụ quan sát được theo spec, không bịa ngưỡng OQ",
                )
            ],
            "🟢 fact spec / 🔴 OQ trong spec feature",
        )

    # indexes
    by = defaultdict(list)
    meta = {
        ("access-control", 1): ("Người dùng", "FR-access-control-001", "access-login", "P0"),
        ("access-control", 2): ("Người dùng đã đăng nhập", "FR-access-control-002", "session-expired", "P0"),
        ("access-control", 3): ("Người dùng", "FR-access-control-003", "forgot-password", "P0"),
        ("access-control", 4): ("Người dùng", "FR-access-control-004", "dashboard-home", "P0"),
        ("catalog-admin", 1): ("Quản trị viên", "FR-catalog-admin-001", "bibliographic-form", "P0"),
        ("catalog-admin", 2): ("Thủ thư", "FR-catalog-admin-002", "catalog-search", "P0"),
        ("catalog-admin", 3): ("Quản trị viên", "FR-catalog-admin-003", "bibliographic-form", "P0"),
        ("copy-inventory", 1): ("Quản trị viên", "FR-copy-inventory-001", "copy-form", "P0"),
        ("copy-inventory", 2): ("Quản trị viên", "FR-copy-inventory-003", "copy-form", "P0"),
        ("reader-onboarding", 1): ("Thủ thư", "FR-reader-onboarding-001", "reader-form", "P0"),
        ("policy-config", 1): ("Quản trị viên", "FR-policy-config-001", "admin-config", "P0"),
        ("data-import", 1): ("Quản trị viên", "FR-data-import-001", "import-upload", "P0"),
        ("data-import", 2): ("Quản trị viên", "FR-data-import-001", "import-report", "P0"),
        ("ops-foundation", 1): ("Hệ thống", "FR-ops-foundation-001", "không có màn", "P0"),
        ("ops-foundation", 2): ("Hệ thống", "FR-ops-foundation-002", "không có màn", "P0"),
        ("checkout", 1): ("Thủ thư", "FR-checkout-001", "checkout-review", "P0"),
        ("checkout", 2): ("Thủ thư", "FR-checkout-003", "checkout-review", "P0"),
        ("return-handling", 1): ("Thủ thư", "FR-return-handling-001", "return-result", "P0"),
        ("overdue-fines", 1): ("Hệ thống", "FR-overdue-fines-001", "không có màn", "P0"),
        ("fine-collection-basic", 1): ("Thủ thư", "FR-fine-collection-basic-001", "fine-payment", "P0"),
        ("damage-lifecycle", 1): ("Thủ thư", "FR-damage-lifecycle-001", "damage-report-form", "P0"),
        ("damage-lifecycle", 2): ("Quản trị viên", "FR-damage-lifecycle-001", "damage-report-detail", "P0"),
        ("lost-handling", 1): ("Thủ thư", "FR-lost-handling-001", "lost-record", "P0"),
        ("lost-handling", 2): ("Thủ thư", "FR-lost-handling-002", "found-after-lost", "P1"),
        ("notification-core", 1): ("Hệ thống", "FR-notification-core-001", "notification-status", "P0"),
        ("account-admin", 1): ("Quản trị viên", "FR-account-admin-001", "reader-form", "P0"),
        ("account-admin", 2): ("Quản trị viên", "FR-account-admin-003", "—", "P0"),
        ("account-admin", 3): ("Thủ thư", "FR-account-admin-002", "reader-detail", "P1"),
        ("reader-self-service", 1): ("Người đọc", "FR-reader-self-service-001", "reader-search", "P0"),
        ("reader-self-service", 2): ("Người đọc", "FR-reader-self-service-002", "reader-current-loans", "P0"),
        ("reader-self-service", 3): ("Người đọc", "FR-reader-self-service-004", "reader-qr", "P0"),
        ("reader-self-service", 4): ("Người đọc", "FR-reader-self-service-005", "reader-loan-history", "P0"),
        ("reader-self-service", 5): ("Người đọc", "FR-reader-self-service-003", "reader-my-fines", "P1"),
        ("ops-reports", 1): ("Quản trị viên", "FR-ops-reports-001", "report-dashboard", "P0"),
        ("ops-reports", 2): ("Thủ thư", "FR-ops-reports-002", "overdue-list-staff", "P1"),
        ("renewal", 1): ("Thủ thư", "FR-renewal-001", "renewal-result", "P1"),
        ("reservation", 1): ("Người đọc", "FR-reservation-001", "reservation-queue", "P1"),
        ("reservation", 2): ("Người đọc", "FR-reservation-003", "reservation-form", "P1"),
        ("fine-collection-adv", 1): ("Thủ thư", "FR-fine-collection-adv-001", "fine-receipt", "P1"),
        ("fine-collection-adv", 2): ("Quản trị viên", "FR-fine-collection-adv-002", "fine-adjust", "P1"),
        ("notification-audit-ui", 1): ("Người dùng", "FR-notification-audit-ui-001", "notification-center", "P1"),
        ("notification-audit-ui", 2): ("Quản trị viên", "FR-notification-audit-ui-002", "audit-log", "P1"),
        ("trend-reports", 1): ("Quản trị viên", "FR-trend-reports-001", "trend-dashboard", "P1"),
    }
    for (feat, num), title in titles.items():
        persona, fr, screens, pri = meta[(feat, num)]
        by[feat].append((num, title, persona, fr, screens, pri))
    for feat, rows in by.items():
        rows.sort()
        write_index(feat, rows)


def build_checklists() -> None:
    src = (FEAT / "library-management-platform" / "test" / "checklist" / "checklist-feature.md").read_text(encoding="utf-8")
    items = defaultdict(list)
    for line in src.splitlines():
        m = re.search(r"(CHK-LMP-\d+)", line)
        if not m:
            continue
        old = m.group(1)
        if old not in CHK_FEAT:
            continue
        feat, new = CHK_FEAT[old]
        if feat == "core":
            continue
        newline = remap(line).replace(old, new)
        # remap() already replaced CHK-LMP via ID_MAP if present
        newline = newline.replace("CHK-LMP-", "CHK-PENDING-")
        newline = re.sub(r"CHK-PENDING-\d+", new, newline) if "CHK-PENDING-" in newline else newline
        items[feat].append(newline)
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
        items[k].extend(v)

    for feat, lines in items.items():
        n = len(lines)
        body = f"# Checklist — {feat}\n\n" + "\n".join(lines) + "\n"
        write(FEAT / feat / "test" / "checklist" / "checklist-feature.md", body)
        idx = f"""---
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
"""
        write(FEAT / feat / "test" / "checklist" / f"{feat}-checklist-index.md", idx)
        strat = f"""---
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
"""
        write(FEAT / feat / "test" / "test-strategy.md", strat)


CHANGE_ROWS: list[str] = []


def log(skill: str, path: str, note: str) -> None:
    CHANGE_ROWS.append(f"| {TODAY} | {skill} | {AUTHOR} | `{path.as_posix() if isinstance(path, Path) else path}` | {note} |")


def append_changelog() -> None:
    p = DOCS / "_shared" / "changelog.md"
    text = p.read_text(encoding="utf-8")
    # collect written files
    extra = []
    for feat_dir in FEAT.iterdir():
        if not feat_dir.is_dir() or feat_dir.name in {"library-management-platform", "expansion-candidates"}:
            continue
        uf = feat_dir / "srs" / f"{feat_dir.name}-userflow.md"
        if uf.exists() and feat_dir.name not in {
            "access-control",
            "reader-onboarding",
            "account-admin",
            "catalog-admin",
            "copy-inventory",
            "data-import",
            "policy-config",
        }:
            extra.append(f"| {TODAY} | /user-flow | {AUTHOR} | `{uf.as_posix()}` | user flow {feat_dir.name}, Mobile 375, flow-approved |")
        wf = feat_dir / "html-wireframe" / f"{feat_dir.name}-wireframe.html"
        if wf.exists() and feat_dir.name not in {
            "access-control",
            "reader-onboarding",
            "account-admin",
            "catalog-admin",
            "copy-inventory",
            "data-import",
            "policy-config",
        }:
            extra.append(f"| {TODAY} | /wireframe-html | {AUTHOR} | `{wf.as_posix()}` | Wireframe HTML {feat_dir.name} |")
        idx = feat_dir / "userstories" / f"{feat_dir.name}-story-index.md"
        if idx.exists():
            extra.append(f"| {TODAY} | /userstory | {AUTHOR} | `{idx.as_posix()}` | story index {feat_dir.name} |")
        chk = feat_dir / "test" / "checklist" / "checklist-feature.md"
        if chk.exists():
            extra.append(f"| {TODAY} | /test-checklist | {AUTHOR} | `{chk.as_posix()}` | checklist {feat_dir.name} |")
    if extra:
        if not text.endswith("\n"):
            text += "\n"
        p.write_text(text + "\n".join(extra) + "\n", encoding="utf-8")


def update_prd() -> None:
    p = DOCS / "_product" / "prd.md"
    text = p.read_text(encoding="utf-8")
    text = text.replace("| 🔄 đang chi tiết (1 brainstorm) |", "| ✅ 6 tầng (draft) |")
    # expansion still candidate
    text = text.replace(
        "| 23 | Candidate mở rộng | `expansion-candidates`",
        "| 23 | Candidate mở rộng | `expansion-candidates`",
    )
    text = re.sub(
        r"(\| 23 \| Candidate mở rộng \| `expansion-candidates` \|[^\n]*\| )✅ 6 tầng \(draft\) \|",
        r"\1🔄 brainstorm only — không chi tiết hóa |",
        text,
    )
    p.write_text(text, encoding="utf-8")


def main() -> None:
    parse_crosswalk()
    hashes = build_userflows()
    build_wireframes(hashes)
    build_stories()
    build_checklists()
    append_changelog()
    update_prd()
    print("OK hashes", hashes)


if __name__ == "__main__":
    main()
