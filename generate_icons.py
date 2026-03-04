#!/usr/bin/env python3
import subprocess
import os


def create_water_drop_svg(size):
    svg_content = f'''<?xml version="1.0" encoding="UTF-8"?>
<svg width="{size}" height="{size}" viewBox="0 0 {size} {size}" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#5DADE2;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#3498DB;stop-opacity:1" />
    </linearGradient>
  </defs>
  <path d="M{size // 2},{size * 0.1} 
           C{size * 0.2},{size * 0.4} {size * 0.1},{size * 0.6} {size * 0.1},{size * 0.7}
           C{size * 0.1},{size * 0.85} {size * 0.3},{size * 0.95} {size // 2},{size * 0.95}
           C{size * 0.7},{size * 0.95} {size * 0.9},{size * 0.85} {size * 0.9},{size * 0.7}
           C{size * 0.9},{size * 0.6} {size * 0.8},{size * 0.4} {size // 2},{size * 0.1}Z" 
        fill="url(#grad1)" />
  <ellipse cx="{size * 0.35}" cy="{size * 0.35}" rx="{size * 0.08}" ry="{size * 0.12}" 
           fill="rgba(255,255,255,0.6)" />
</svg>'''
    return svg_content


def main():
    # Check if sips is available (macOS built-in)
    try:
        result = subprocess.run(
            ["which", "sips"], check=True, capture_output=True, text=True
        )
        use_sips = True
    except:
        use_sips = False
        print("⚠ sips not found, creating SVG only")

    sizes = [16, 32, 128, 256, 512, 1024]

    for size in sizes:
        # Create SVG
        svg_path = (
            f"HydrationHelper/Assets.xcassets/AppIcon.appiconset/icon_{size}x{size}.svg"
        )
        with open(svg_path, "w") as f:
            f.write(create_water_drop_svg(size))

        # Convert to PNG if sips available
        if use_sips:
            png_path = f"HydrationHelper/Assets.xcassets/AppIcon.appiconset/icon_{size}x{size}.png"
            subprocess.run(
                ["sips", "-s", "format", "png", svg_path, "--out", png_path],
                capture_output=True,
                text=True,
            )

            # Create @2x version
            if size < 1024:
                png_2x_path = f"HydrationHelper/Assets.xcassets/AppIcon.appiconset/icon_{size}x{size}@2x.png"
                subprocess.run(
                    [
                        "sips",
                        "-s",
                        "format",
                        "png",
                        svg_path,
                        "-z",
                        str(size * 2),
                        str(size * 2),
                        "--out",
                        png_2x_path,
                    ],
                    capture_output=True,
                    text=True,
                )

    print("✓ Icons generated successfully")


if __name__ == "__main__":
    main()
