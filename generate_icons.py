#!/usr/bin/env python3
"""
Run this once to generate your PWA icons.
pip install cairosvg pillow
python3 generate_icons.py

OR — just use any 512x512 PNG image you want as your icon and rename it to:
  icon-192.png  (192x192)
  icon-512.png  (512x512)

Place both in the same folder as index.html.
"""

SVG = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
  <rect width="512" height="512" rx="80" fill="#1a2e1a"/>
  <text x="256" y="200" font-family="Georgia,serif" font-size="180" font-weight="bold"
    fill="#f4efe6" text-anchor="middle" dominant-baseline="middle">F</text>
  <text x="256" y="340" font-family="Georgia,serif" font-size="56" font-style="italic"
    fill="#6b8f6b" text-anchor="middle">Property</text>
</svg>'''

try:
    import cairosvg
    cairosvg.svg2png(bytestring=SVG.encode(), write_to='icon-192.png', output_width=192, output_height=192)
    cairosvg.svg2png(bytestring=SVG.encode(), write_to='icon-512.png', output_width=512, output_height=512)
    print("Icons generated: icon-192.png, icon-512.png")
except ImportError:
    # Write the SVG so they can convert manually
    with open('icon.svg', 'w') as f:
        f.write(SVG)
    print("cairosvg not available.")
    print("icon.svg written — convert it to PNG at:")
    print("  https://svgtopng.com/")
    print("Save as icon-192.png (192x192) and icon-512.png (512x512)")
    print("Then place both in the same folder as index.html")
