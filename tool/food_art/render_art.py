"""Render characters and scenes.
usage:
  python render_art.py characters OUT_DIR [SHEET.png]
  python render_art.py scenes     OUT_DIR [SHEET.png]
"""
import sys, os, base64
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from playwright.sync_api import sync_playwright

kind, out = sys.argv[1], sys.argv[2]
sheet = sys.argv[3] if len(sys.argv) > 3 else None
os.makedirs(out, exist_ok=True)

if kind == 'characters':
    from characters import all_characters
    items = {k: (fn, 200, 240, 400, 480) for k, fn in all_characters().items()}
else:
    from scenes import all_scenes
    items = all_scenes()  # name -> (fn, vbw, vbh, pxw, pxh)

with sync_playwright() as p:
    b = p.chromium.launch()
    for name, (fn, vw, vh, pw, ph) in items.items():
        pg = b.new_page(device_scale_factor=1, viewport={'width': pw, 'height': ph})
        body = (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {vw} {vh}" width="{pw}" height="{ph}" '
                f'preserveAspectRatio="xMidYMid slice">{fn()}</svg>')
        pg.set_content(f'<html><body style="margin:0;background:transparent">{body}</body></html>')
        ext = 'png'
        pg.screenshot(path=os.path.join(out, f'{name}.{ext}'), omit_background=True,
                      clip={'x': 0, 'y': 0, 'width': pw, 'height': ph})
        pg.close()
    if sheet:
        cells = ''.join(
            f'<div class="c"><img src="data:image/png;base64,{base64.b64encode(open(os.path.join(out, n + ".png"), "rb").read()).decode()}">'
            f'<span>{n}</span></div>' for n in items)
        w = 1100
        pg = b.new_page(viewport={'width': w, 'height': 800})
        size = '120px' if kind == 'characters' else '260px'
        pg.set_content(f'''<html><body style="margin:0;background:#fff6e5;font-family:sans-serif">
          <style>.g{{display:flex;flex-wrap:wrap}} .c{{display:flex;flex-direction:column;align-items:center;padding:6px}}
          .c img{{height:{size}}} .c span{{font-size:11px;color:#5c3a1b;font-weight:700}}</style>
          <div class="g">{cells}</div></body></html>''')
        pg.wait_for_timeout(300)
        pg.screenshot(path=sheet, full_page=True)
    b.close()
print('rendered', len(items))
