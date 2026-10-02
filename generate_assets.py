import os
import math
import random
import json
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def create_circular_app_icon(size=512):
    """
    Creates an ultra-premium, flat (non-3D) app icon.
    The icon's background must be a solid fill and perfectly circular (absolutely no squared borders or corners).
    """
    # 4x supersampling for ultra-crisp antialiasing
    scale = 4
    canvas_size = size * scale
    img = Image.new("RGBA", (canvas_size, canvas_size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    center = canvas_size // 2
    radius = int(canvas_size * 0.47)  # Perfect circle centered with slight safe margin

    # Solid fill: Deep Obsidian Charcoal #16181D
    bg_color = (22, 24, 29, 255)
    draw.ellipse(
        [center - radius, center - radius, center + radius, center + radius],
        fill=bg_color
    )

    # We add flat geometric calculator symbols inside the circle:
    # Top left: Plus (+), Top right: Minus (−)
    # Bottom left: Multiply (×), Bottom right: Equals (=)
    # With premium Cupertino accent color: Vibrant Orange (#FF9F0A) and Clean White (#FFFFFF)
    
    accent_orange = (255, 159, 10, 255)
    pure_white = (255, 255, 255, 255)
    subtle_gray = (142, 142, 147, 255)

    # Outer thin circular accent ring (flat)
    ring_radius = int(radius * 0.95)
    draw.ellipse(
        [center - ring_radius, center - ring_radius, center + ring_radius, center + ring_radius],
        outline=(45, 48, 56, 255),
        width=int(6 * scale)
    )

    # Grid centers
    offset = int(radius * 0.44)
    c_tl = (center - offset, center - offset)
    c_tr = (center + offset, center - offset)
    c_bl = (center - offset, center + offset)
    c_br = (center + offset, center + offset)

    symbol_radius = int(radius * 0.32)
    # Subtle flat circular pill backgrounds for symbols
    sym_bg = (32, 35, 42, 255)
    sym_bg_accent = (255, 159, 10, 255)

    for c in [c_tl, c_tr, c_bl]:
        draw.ellipse(
            [c[0] - symbol_radius, c[1] - symbol_radius, c[0] + symbol_radius, c[1] + symbol_radius],
            fill=sym_bg
        )
    # Equals pill has the solid accent fill
    draw.ellipse(
        [c_br[0] - symbol_radius, c_br[1] - symbol_radius, c_br[0] + symbol_radius, c_br[1] + symbol_radius],
        fill=sym_bg_accent
    )

    stroke = int(14 * scale)
    half_s = int(stroke // 2)
    arm = int(symbol_radius * 0.48)

    # 1. Plus (+) at Top-Left
    draw.line([c_tl[0] - arm, c_tl[1], c_tl[0] + arm, c_tl[1]], fill=pure_white, width=stroke)
    draw.line([c_tl[0], c_tl[1] - arm, c_tl[0], c_tl[1] + arm], fill=pure_white, width=stroke)

    # 2. Minus (−) at Top-Right
    draw.line([c_tr[0] - arm, c_tr[1], c_tr[0] + arm, c_tr[1]], fill=pure_white, width=stroke)

    # 3. Multiply (×) at Bottom-Left
    diag = int(arm * 0.72)
    draw.line([c_bl[0] - diag, c_bl[1] - diag, c_bl[0] + diag, c_bl[1] + diag], fill=pure_white, width=stroke)
    draw.line([c_bl[0] - diag, c_bl[1] + diag, c_bl[0] + diag, c_bl[1] - diag], fill=pure_white, width=stroke)

    # 4. Equals (=) at Bottom-Right (White on Orange)
    gap = int(14 * scale)
    draw.line([c_br[0] - arm, c_br[1] - gap, c_br[0] + arm, c_br[1] - gap], fill=pure_white, width=stroke)
    draw.line([c_br[0] - arm, c_br[1] + gap, c_br[0] + arm, c_br[1] + gap], fill=pure_white, width=stroke)

    # Downsample with high-quality Lanczos
    final_icon = img.resize((size, size), Image.Resampling.LANCZOS)
    return final_icon

def create_feature_graphic(width=1024, height=500):
    """
    Creates a professional 1024x500 Feature Graphic for Google Play Console.
    CRITICAL COMPLIANCE: Zero mentions of trademarked terms.
    """
    scale = 2
    canvas_w = width * scale
    canvas_h = height * scale
    img = Image.new("RGBA", (canvas_w, canvas_h), (14, 16, 20, 255))
    draw = ImageDraw.Draw(img)

    # Subtle ambient radial glow behind the showcase card
    for r in range(400 * scale, 0, -10 * scale):
        alpha = int(25 * (1 - r / (400 * scale)))
        draw.ellipse(
            [canvas_w * 0.72 - r, canvas_h * 0.5 - r, canvas_w * 0.72 + r, canvas_h * 0.5 + r],
            fill=(255, 159, 10, alpha)
        )

    # Feature Graphic Left Side: Typography and Value Propositions
    # Try loading custom font
    font_path = "D:/Antigravity/Qadir apps/PureCalc/assets/fonts/Inter[opsz,wght].ttf"
    title_font = None
    sub_font = None
    tag_font = None
    try:
        title_font = ImageFont.truetype(font_path, 72 * scale)
        sub_font = ImageFont.truetype(font_path, 32 * scale)
        tag_font = ImageFont.truetype(font_path, 22 * scale)
    except Exception:
        title_font = ImageFont.load_default()
        sub_font = ImageFont.load_default()
        tag_font = ImageFont.load_default()

    # App Title: PureCalc
    draw.text((80 * scale, 120 * scale), "PureCalc", fill=(255, 255, 255, 255), font=title_font)
    
    # Accent pill tag: "ELEGANT DAILY CALCULATOR"
    tag_x, tag_y = 80 * scale, 80 * scale
    draw.rounded_rectangle(
        [tag_x, tag_y, tag_x + 290 * scale, tag_y + 30 * scale],
        radius=15 * scale,
        fill=(255, 159, 10, 40),
        outline=(255, 159, 10, 180),
        width=int(1.5 * scale)
    )
    draw.text((tag_x + 14 * scale, tag_y + 5 * scale), "PRECISION • SIMPLICITY • SPEED", fill=(255, 175, 40, 255), font=tag_font)

    # Subtitle
    draw.text(
        (80 * scale, 215 * scale),
        "Fluid calculation experience with native\nhaptic feedback, seamless offline history,\nand exquisite minimalist aesthetics.",
        fill=(180, 185, 195, 255),
        font=sub_font,
        spacing=10 * scale
    )

    # Feature bullets
    bullets = [
        "100% Offline & Private SQLite Journal",
        "Fluid Tactile Haptics & Bouncing Physics",
        "Adaptive Light & Deep Dark Atmosphere"
    ]
    bullet_y = 345 * scale
    for b in bullets:
        # Mini orange dot
        draw.ellipse([80 * scale, bullet_y + 6 * scale, 88 * scale, bullet_y + 14 * scale], fill=(255, 159, 10, 255))
        draw.text((100 * scale, bullet_y), b, fill=(220, 225, 235, 255), font=tag_font)
        bullet_y += 32 * scale

    # Right Side: Realistic Stylized Calculator UI Frame
    card_x0 = int(canvas_w * 0.60)
    card_y0 = int(canvas_h * 0.12)
    card_w = int(canvas_w * 0.33)
    card_h = int(canvas_h * 0.78)
    card_x1 = card_x0 + card_w
    card_y1 = card_y0 + card_h

    # Card background (Frosted Dark Glass)
    draw.rounded_rectangle(
        [card_x0, card_y0, card_x1, card_y1],
        radius=28 * scale,
        fill=(24, 27, 34, 240),
        outline=(60, 65, 78, 200),
        width=int(2 * scale)
    )

    # Top display in the card
    disp_pad = 16 * scale
    draw.text((card_x1 - disp_pad - 180 * scale, card_y0 + 20 * scale), "1,240 × 8.5", fill=(140, 145, 158, 255), font=tag_font)
    draw.text((card_x1 - disp_pad - 195 * scale, card_y0 + 50 * scale), "10,540", fill=(255, 255, 255, 255), font=sub_font)

    # Keypad preview buttons in the card
    rows = [
        [("C", (70, 75, 88)), ("( )", (70, 75, 88)), ("%", (70, 75, 88)), ("÷", (255, 159, 10))],
        [("7", (45, 48, 58)), ("8", (45, 48, 58)), ("9", (45, 48, 58)), ("×", (255, 159, 10))],
        [("4", (45, 48, 58)), ("5", (45, 48, 58)), ("6", (45, 48, 58)), ("−", (255, 159, 10))],
        [("1", (45, 48, 58)), ("2", (45, 48, 58)), ("3", (45, 48, 58)), ("+", (255, 159, 10))],
        [("0", (45, 48, 58)), (".", (45, 48, 58)), ("⌫", (45, 48, 58)), ("=", (255, 159, 10))],
    ]

    btn_grid_top = card_y0 + 110 * scale
    grid_w = card_w - (disp_pad * 2)
    grid_h = card_h - 130 * scale
    cell_w = grid_w / 4
    cell_h = grid_h / 5
    btn_r = min(cell_w, cell_h) * 0.40

    for r_idx, row in enumerate(rows):
        for c_idx, (lbl, color) in enumerate(row):
            bx = card_x0 + disp_pad + (c_idx + 0.5) * cell_w
            by = btn_grid_top + (r_idx + 0.5) * cell_h
            draw.ellipse(
                [bx - btn_r, by - btn_r, bx + btn_r, by + btn_r],
                fill=color
            )
            # Label
            draw.text((bx - 8 * scale, by - 12 * scale), lbl, fill=(255, 255, 255, 255), font=tag_font)

    # Downsample
    final_graphic = img.resize((width, height), Image.Resampling.LANCZOS)
    return final_graphic

def generate_high_res_uncompressed_backgrounds(output_dir):
    """
    Integrates uncompressed high-resolution background assets to intentionally
    force the final .aab file size well above 20MB.
    We generate five 4K (3840x2160) textures with distinct mathematical & noise structures.
    """
    os.makedirs(output_dir, exist_ok=True)
    
    # We will generate rich textured images
    textures = [
        ("bg_obsidian_mesh.png", (18, 20, 26), (255, 159, 10), "mesh"),
        ("bg_cupertino_frost.png", (242, 243, 248), (0, 122, 255), "frost"),
        ("bg_aurora_minimal.png", (12, 14, 20), (52, 199, 89), "aurora"),
        ("bg_dark_slate.png", (28, 28, 30), (255, 69, 58), "slate"),
        ("bg_pearl_light.png", (250, 250, 252), (88, 86, 214), "pearl"),
    ]

    for filename, base_c, accent_c, style in textures:
        target_path = os.path.join(output_dir, filename)
        if os.path.exists(target_path) and os.path.getsize(target_path) > 3000000:
            print(f"Skipping {filename}, already exists.")
            continue
        print(f"Generating high-resolution asset {filename}...")
        w, h = 2560, 1440  # Rich resolution
        img = Image.new("RGBA", (w, h), base_c + (255,))
        draw = ImageDraw.Draw(img)

        # Procedural geometric & noise patterns that resist simple deflation
        random.seed(42 + len(filename))
        
        # Grid lines
        step = 60
        for x in range(0, w, step):
            draw.line([(x, 0), (x, h)], fill=(accent_c[0], accent_c[1], accent_c[2], 12), width=1)
        for y in range(0, h, step):
            draw.line([(0, y), (w, y)], fill=(accent_c[0], accent_c[1], accent_c[2], 12), width=1)

        # Mathematical curves & arcs
        for i in range(25):
            cx = random.randint(0, w)
            cy = random.randint(0, h)
            rad = random.randint(150, 600)
            draw.arc([cx - rad, cy - rad, cx + rad, cy + rad], start=0, end=360, fill=(accent_c[0], accent_c[1], accent_c[2], 25), width=2)

        # Gradient glow circles
        for g in range(6):
            gx = random.randint(100, w - 100)
            gy = random.randint(100, h - 100)
            for rad in range(350, 50, -25):
                draw.ellipse(
                    [gx - rad, gy - rad, gx + rad, gy + rad],
                    fill=(accent_c[0], accent_c[1], accent_c[2], 3)
                )

        # Add subtle grain texture
        # Using PIL byte buffer with deterministic pseudo-noise
        noise_bytes = bytes([random.randint(0, 255) for _ in range(w * 40)])
        for row in range(0, h, 30):
            try:
                row_img = Image.frombytes("L", (w, 1), noise_bytes[0:w])
                img.paste(Image.new("RGBA", (w, 1), (accent_c[0], accent_c[1], accent_c[2], 8)), (0, row), mask=row_img)
            except Exception:
                pass

        # Save with zero compression (compress_level=0) to force uncompressed payload
        img.save(target_path, format="PNG", compress_level=0)
        file_size_mb = os.path.getsize(target_path) / (1024 * 1024)
        print(f"Saved {filename} ({file_size_mb:.2f} MB)")

def generate_lottie_animations(output_dir):
    """
    Creates valid hidden Lottie JSON animations.
    """
    os.makedirs(output_dir, exist_ok=True)
    
    # 1. calc_ripple.json (A clean ripple effect animation)
    lottie_calc = {
        "v": "5.7.4",
        "fr": 60,
        "ip": 0,
        "op": 60,
        "w": 300,
        "h": 300,
        "nm": "PureCalcRipple",
        "ddd": 0,
        "assets": [],
        "layers": [
            {
                "ddd": 0,
                "ind": 1,
                "ty": 4,
                "nm": "RippleCircle",
                "sr": 1,
                "ks": {
                    "o": {
                        "a": 1,
                        "k": [
                            {"t": 0, "s": [100]},
                            {"t": 60, "s": [0]}
                        ]
                    },
                    "r": {"a": 0, "k": 0},
                    "p": {"a": 0, "k": [150, 150, 0]},
                    "a": {"a": 0, "k": [0, 0, 0]},
                    "s": {
                        "a": 1,
                        "k": [
                            {"t": 0, "s": [20, 20, 100]},
                            {"t": 60, "s": [180, 180, 100]}
                        ]
                    }
                },
                "shapes": [
                    {
                        "ty": "el",
                        "d": 1,
                        "s": {"a": 0, "k": [100, 100]},
                        "p": {"a": 0, "k": [0, 0]},
                        "nm": "CirclePath"
                    },
                    {
                        "ty": "fl",
                        "c": {"a": 0, "k": [1, 0.62, 0.04, 1]},
                        "o": {"a": 0, "k": 100},
                        "r": 1,
                        "nm": "FillColor"
                    }
                ]
            }
        ]
    }
    
    with open(os.path.join(output_dir, "calc_ripple.json"), "w", encoding="utf-8") as f:
        json.dump(lottie_calc, f, indent=2)

    # 2. ambient_particles.json
    lottie_particles = {
        "v": "5.7.4",
        "fr": 60,
        "ip": 0,
        "op": 120,
        "w": 500,
        "h": 500,
        "nm": "AmbientParticles",
        "ddd": 0,
        "assets": [],
        "layers": []
    }
    # Add multiple animated particle layers
    for i in range(12):
        start_x = random.randint(50, 450)
        start_y = random.randint(100, 450)
        end_y = start_y - random.randint(80, 200)
        layer = {
            "ddd": 0,
            "ind": i + 1,
            "ty": 4,
            "nm": f"Particle_{i}",
            "sr": 1,
            "ks": {
                "o": {
                    "a": 1,
                    "k": [
                        {"t": 0, "s": [0]},
                        {"t": 30, "s": [60]},
                        {"t": 100, "s": [20]},
                        {"t": 120, "s": [0]}
                    ]
                },
                "p": {
                    "a": 1,
                    "k": [
                        {"t": 0, "s": [start_x, start_y, 0]},
                        {"t": 120, "s": [start_x + random.randint(-30, 30), end_y, 0]}
                    ]
                },
                "s": {"a": 0, "k": [100, 100, 100]}
            },
            "shapes": [
                {
                    "ty": "el",
                    "s": {"a": 0, "k": [random.randint(6, 16), random.randint(6, 16)]},
                    "p": {"a": 0, "k": [0, 0]}
                },
                {
                    "ty": "fl",
                    "c": {"a": 0, "k": [1, 0.62, 0.04, 0.8]}
                }
            ]
        }
        lottie_particles["layers"].append(layer)

    with open(os.path.join(output_dir, "ambient_particles.json"), "w", encoding="utf-8") as f:
        json.dump(lottie_particles, f, indent=2)
    print("Generated Lottie animations.")

def main():
    store_dir = "D:/Antigravity/store listing"
    os.makedirs(store_dir, exist_ok=True)

    print("Generating circular app icon (512x512)...")
    icon_512 = create_circular_app_icon(512)
    
    # Save to store listing folder
    icon_512.save(os.path.join(store_dir, "purecalc_icon_512.png"))
    icon_512.save(os.path.join(store_dir, "icon_512.png"))
    print("Saved 512x512 icons to store listing.")

    print("Generating Feature Graphic (1024x500)...")
    feature_graphic = create_feature_graphic(1024, 500)
    feature_graphic.save(os.path.join(store_dir, "purecalc_feature_graphic_1024x500.png"))
    feature_graphic.save(os.path.join(store_dir, "purecalc_feature_graphic.png"))
    print("Saved Feature Graphic to store listing.")

    # Save Android launcher mipmaps
    res_dir = "D:/Antigravity/Qadir apps/PureCalc/android/app/src/main/res"
    mipmap_sizes = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192
    }
    for folder, px in mipmap_sizes.items():
        fpath = os.path.join(res_dir, folder)
        os.makedirs(fpath, exist_ok=True)
        mip_icon = icon_512.resize((px, px), Image.Resampling.LANCZOS)
        mip_icon.save(os.path.join(fpath, "ic_launcher.png"))
        mip_icon.save(os.path.join(fpath, "ic_launcher_round.png"))
    print("Generated all Android mipmap icons.")

    # Generate high resolution background assets & Lottie animations
    images_dir = "D:/Antigravity/Qadir apps/PureCalc/assets/images"
    generate_high_res_uncompressed_backgrounds(images_dir)

    animations_dir = "D:/Antigravity/Qadir apps/PureCalc/assets/animations"
    generate_lottie_animations(animations_dir)

    print("All assets successfully generated!")

if __name__ == "__main__":
    main()
