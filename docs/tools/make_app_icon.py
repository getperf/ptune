# tools/make_app_icon.py
from PIL import Image
from pathlib import Path

SRC = Path("assets/icon/icon_ios.png")
DST = Path("windows/runner/resources/app_icon.ico")

DST.parent.mkdir(parents=True, exist_ok=True)

img = Image.open(SRC).convert("RGBA")

# Windows推奨サイズ（必須）
sizes = [(16, 16), (32, 32), (48, 48), (256, 256)]

img.save(
    DST,
    format="ICO",
    sizes=sizes
)

print(f"Generated: {DST}")
