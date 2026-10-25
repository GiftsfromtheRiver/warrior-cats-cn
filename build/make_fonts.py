# Regenerate the 10 CJK .ufont overrides from Noto Sans SC (SIL OFL 1.1).
#
# Requirements:
#   1) Download the variable font:
#      https://github.com/google/fonts/raw/main/ofl/notosanssc/NotoSansSC%5Bwght%5D.ttf
#      -> tools/fonts/NotoSansSC-VF.ttf
#   2) pip install fonttools
#
# Usage (from repo root): python build/make_fonts.py
#
# Output: assets/fonts/Wrc/Content/Art/UXD/Fonts/...  (10 files)
# .ufont format (reverse engineered from UE5 source, FFontFaceData::Serialize):
#   int32 payloadSize | raw TTF | int32 preprocessedGeometryCount(=0)
import os, struct, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
VF = os.path.join(REPO, "tools", "fonts", "NotoSansSC-VF.ttf")
CSV = os.path.join(REPO, "assets", "strings", "Strings_EN.zh.csv")
OUT = os.path.join(REPO, "assets", "fonts", "Wrc", "Content", "Art", "UXD", "Fonts")

FONT_MAP = {
    "Catamaran/Catamaran-Regular.ufont": 400,
    "Catamaran/Catamaran-Medium.ufont": 400,
    "Catamaran/Catamaran-SemiBold.ufont": 700,
    "Catamaran/Catamaran-Bold.ufont": 700,
    "Amarante/Amarante-Regular.ufont": 700,
    "Noto/NotoSans-Regular.ufont": 400,
    "Noto/NotoSans-Bold.ufont": 700,
    "Noto/NotoSans-SemiBold.ufont": 700,
    "Noto/NotoSans-Black.ufont": 700,
    "Noto/NotoSans-Italic.ufont": 400,
}
BASE_CHARS = "".join(chr(c) for c in range(0x20, 0x7F)) + "，。！？：；“”‘’、《》…—·（）【】「」『』～￥±×÷°№①②③④⑤⑥⑦⑧⑨⑩"
EXTRA_CHARS = "·•–‑―‰′″€£¥©®™←→↑↓★☆♥♦♣♠✓✔✕✖⚠"


def main():
    if not os.path.exists(VF):
        sys.exit(f"missing variable font: {VF}\nsee docs/BUILD.md")
    from fontTools.ttLib import TTFont
    from fontTools.varLib.instancer import instantiateVariableFont
    from fontTools.subset import Subsetter, Options

    text = open(CSV, "rb").read().decode("utf-8")
    chars = set(text) | set(BASE_CHARS) | set(EXTRA_CHARS)
    charset = "".join(sorted(c for c in chars if not c.isspace() or c == " "))
    cache = {}
    for rel, weight in FONT_MAP.items():
        if weight not in cache:
            font = TTFont(VF)
            inst = instantiateVariableFont(font, {"wght": weight}, inplace=True)
            opts = Options()
            opts.layout_features = ["*"]
            opts.notdef_outline = True
            opts.drop_tables += ["DSIG"]
            opts.hinting = False
            sub = Subsetter(options=opts)
            sub.populate(text=charset)
            sub.subset(inst)
            cache[weight] = inst
        out_path = os.path.join(OUT, rel.replace("/", os.sep))
        os.makedirs(os.path.dirname(out_path), exist_ok=True)
        tmp = out_path + ".ttf"
        cache[weight].save(tmp)
        payload = open(tmp, "rb").read()
        os.remove(tmp)
        data = struct.pack("<i", len(payload)) + payload + struct.pack("<i", 0)
        open(out_path, "wb").write(data)
        print(f"{rel}: {len(data):,} bytes")
    print("done")


if __name__ == "__main__":
    main()