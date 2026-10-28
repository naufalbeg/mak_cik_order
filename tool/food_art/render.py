"""Render all food illustrations to PNG + a contact sheet.
usage: python render.py OUT_DIR SHEET_PNG [names...]"""
import sys, os, importlib, base64
sys.path.insert(0, os.path.dirname(__file__))
from prims import svg
from playwright.sync_api import sync_playwright

F = {}
for mod in ('foods_a', 'foods_b', 'foods_c'):
    try:
        F.update(importlib.import_module(mod).F)
    except ModuleNotFoundError:
        pass

out, sheet = sys.argv[1], sys.argv[2]
names = sys.argv[3:] or list(F)
os.makedirs(out, exist_ok=True)
SIZE = 192  # css px, rendered at 2x => 384px PNG

with sync_playwright() as p:
    b = p.chromium.launch()
    pg = b.new_page(device_scale_factor=2, viewport={'width': SIZE, 'height': SIZE})
    for n in names:
        pg.set_content(f'<html><body style="margin:0;background:transparent">{svg(F[n](), SIZE)}</body></html>')
        pg.screenshot(path=os.path.join(out, f'{n}.png'), omit_background=True,
                      clip={'x': 0, 'y': 0, 'width': SIZE, 'height': SIZE})
    from PIL import Image
    for n in names:
        fp = os.path.join(out, f'{n}.png')
        im = Image.open(fp).convert('RGBA')
        bb = im.getchannel('A').point(lambda a: 255 if a > 8 else 0).getbbox()
        if bb:
            im = im.crop(bb)
            side = int(max(im.size) * 1.06)
            sq = Image.new('RGBA', (side, side), (0, 0, 0, 0))
            sq.paste(im, ((side - im.width) // 2, (side - im.height) // 2))
            im = sq.resize((256, 256), Image.LANCZOS)
        im.save(fp, optimize=True)
    # contact sheet
    cells = ''.join(
        f'<div class="c"><img src="data:image/png;base64,{base64.b64encode(open(os.path.join(out, n + ".png"),"rb").read()).decode()}"><span>{n}</span></div>'
        for n in names)
    cols = 6
    w = cols * 170
    pg2 = b.new_page(viewport={'width': w, 'height': 800}, device_scale_factor=1)
    pg2.set_content(f'''<html><body style="margin:0;background:#fff6e5;font-family:sans-serif">
      <style>.g{{display:grid;grid-template-columns:repeat({cols},170px)}}
      .c{{display:flex;flex-direction:column;align-items:center;padding:6px}}
      .c img{{width:150px;height:150px}} .c span{{font-size:12px;color:#5c3a1b;font-weight:700}}</style>
      <div class="g">{cells}</div></body></html>''')
    pg2.wait_for_timeout(300)
    pg2.screenshot(path=sheet, full_page=True)
    b.close()
print('rendered', len(names))
