#!/bin/bash
# Rebuild index.json by scanning horizontal/ and vertical/ folders.
set -e
cd "$(dirname "$0")"

python3 <<'PY'
import json, os, re, pathlib

ROOT = pathlib.Path(__file__).parent if "__file__" in dir() else pathlib.Path(".")
ROOT = pathlib.Path("/Users/jeetesh.shah/Desktop/Claude/assets")

def parse_name(filename):
    stem = pathlib.Path(filename).stem
    # strip trailing "-thumbnail--..." and dimension suffixes
    name = re.sub(r"-thumbnail--.*$", "", stem)
    name = re.sub(r"--?cover.*$", "", name)
    name = re.sub(r"--?gamehero.*$", "", name)
    name = re.sub(r"-\d+x\d+$", "", name)
    return name.replace("-", " ").replace("_", ":").strip()

def slug(filename):
    stem = pathlib.Path(filename).stem
    return re.sub(r"-thumbnail--.*$", "", stem)

entries = {}
for orientation, dims in [("horizontal", "1920x1080"), ("vertical", "720x1080"), ("hero", "1920x1080")]:
    folder = ROOT / orientation
    for f in sorted(os.listdir(folder)):
        if f.startswith("."): continue
        path = folder / f
        if not path.is_file(): continue
        key = slug(f)
        e = entries.setdefault(key, {"name": parse_name(f), "slug": key})
        e[orientation] = str(path)
        e[f"{orientation}_dimensions"] = dims

index = sorted(entries.values(), key=lambda x: x["slug"])

fonts = []
font_dir = ROOT / "font"
if font_dir.exists():
    for f in sorted(os.listdir(font_dir)):
        if f.lower().endswith((".ttf", ".otf", ".woff", ".woff2")):
            stem = pathlib.Path(f).stem
            family, _, weight = stem.partition("-")
            fonts.append({
                "file": f,
                "family": family,
                "weight": weight or "Regular",
                "path": str(font_dir / f),
            })

logos = []
logo_dir = ROOT / "logos"
if logo_dir.exists():
    for f in sorted(os.listdir(logo_dir)):
        if f.startswith("."): continue
        if f.lower().endswith((".svg", ".png", ".jpg", ".jpeg", ".webp")):
            logos.append({
                "file": f,
                "name": pathlib.Path(f).stem,
                "path": str(logo_dir / f),
            })

out = ROOT / "index.json"
out.write_text(json.dumps({
    "root": str(ROOT),
    "count": len(index),
    "items": index,
    "fonts": fonts,
    "logos": logos,
}, indent=2))
print(f"Indexed {len(index)} games, {len(fonts)} fonts, {len(logos)} logos -> {out}")
PY
