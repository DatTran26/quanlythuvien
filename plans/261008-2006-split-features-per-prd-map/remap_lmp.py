from pathlib import Path
import re

ROOT = Path(r"D:/Projects/QuanLyThuVIen")
text = (ROOT / "docs/_shared/id-crosswalk-lmp.md").read_text(encoding="utf-8")
idmap = {}
old_rx = re.compile(r"((?:FR|NFR|BR|E|SC|CHK)-LMP-\d+)")
new_rx = re.compile(r"`((?:FR|NFR|BR|E|SC|CHK)-[a-z0-9-]+-\d+)`")
for line in text.splitlines():
    om = old_rx.search(line)
    news = new_rx.findall(line)
    if om and news:
        idmap.setdefault(om.group(1), news[-1])
idmap.update(
    {
        "OQ-LMP-005": "OQ-fine-collection-adv-001",
        "OQ-LMP-006": "OQ-reader-self-service-004",
        "OQ-LMP-007": "OQ-access-control-001",
        "OQ-LMP-009": "OQ-fine-collection-adv-002",
        "OQ-LMP-010": "OQ-policy-config-001",
        "OQ-LMP-013": "OQ-damage-lifecycle-001",
        "OQ-LMP-014": "OQ-account-admin-001",
        "OQ-LMP-015": "OQ-reader-self-service-001",
        "OQ-LMP-016": "OQ-reader-self-service-002",
        "OQ-LMP-018": "OQ-data-import-002",
        "OQ-LMP-002": "OQ-data-import-001",
        "OQ-LMP-004": "OQ-return-handling-001",
        "OQ-LMP-008": "OQ-notification-core-001",
        "OQ-LMP-011": "OQ-return-handling-001",
        "OQ-LMP-012": "OQ-access-control-001",
        "OQ-LMP-017": "OQ-ops-reports-001",
    }
)
keys = sorted(idmap, key=len, reverse=True)

def remap_text(s: str) -> str:
    def combo(m):
        a = f"{m.group(1)}-{m.group(2)}"
        b = f"{m.group(1)}-{m.group(3)}"
        return f"{idmap.get(a, a)}/{idmap.get(b, b)}"

    s = re.sub(r"((?:FR|NFR|BR|E|SC)-LMP)-(\d+)/(\d+)", combo, s)
    for k in keys:
        s = s.replace(k, idmap[k])
    return s

nfiles = 0
for p in (ROOT / "docs/features").rglob("*"):
    if not p.is_file() or "library-management-platform" in p.parts:
        continue
    if p.suffix.lower() not in {".md", ".html"}:
        continue
    s = p.read_text(encoding="utf-8")
    orig = s
    s = remap_text(s)
    if s != orig:
        p.write_text(s, encoding="utf-8")
        nfiles += 1
print("updated", nfiles, "mapsize", len(idmap))
left = []
rx = re.compile(r"(FR|NFR|BR|E|OQ|CHK)-LMP-")
for p in (ROOT / "docs/features").rglob("*"):
    if not p.is_file() or "library-management-platform" in p.parts:
        continue
    if p.suffix.lower() not in {".md", ".html"}:
        continue
    t = p.read_text(encoding="utf-8")
    if rx.search(t):
        left.append(str(p))
print("still", len(left))
for x in left[:30]:
    print(x)
