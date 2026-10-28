"""Shared drawing primitives for the Mak Cik food illustrations.
All art lives on a 200x200 canvas, flat cartoon style with a warm brown outline."""
import math
import random

O = '#4a2c17'   # outline
SW = 3          # outline width


def _a(**kw):
    out = []
    for k, v in kw.items():
        if v is None:
            continue
        out.append(f'{k.replace("_", "-")}="{v}"')
    return ' '.join(out)


def ell(cx, cy, rx, ry, fill, stroke=O, sw=SW, op=None, rot=0):
    t = f' transform="rotate({rot} {cx} {cy})"' if rot else ''
    return f'<ellipse cx="{cx:.1f}" cy="{cy:.1f}" rx="{rx:.1f}" ry="{ry:.1f}" {_a(fill=fill, stroke=stroke if stroke else "none", stroke_width=sw, opacity=op)}{t}/>'


def circ(cx, cy, r, fill, stroke=O, sw=SW, op=None):
    return f'<circle cx="{cx:.1f}" cy="{cy:.1f}" r="{r:.1f}" {_a(fill=fill, stroke=stroke if stroke else "none", stroke_width=sw, opacity=op)}/>'


def path(d, fill, stroke=O, sw=SW, op=None, lj='round', lc='round', extra=''):
    return f'<path d="{d}" {_a(fill=fill, stroke=stroke if stroke else "none", stroke_width=sw, opacity=op, stroke_linejoin=lj, stroke_linecap=lc)} {extra}/>'


def rect(x, y, w, h, fill, rx=0, stroke=O, sw=SW, rot=0, op=None):
    cx, cy = x + w / 2, y + h / 2
    t = f' transform="rotate({rot} {cx} {cy})"' if rot else ''
    return f'<rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" height="{h:.1f}" rx="{rx}" {_a(fill=fill, stroke=stroke if stroke else "none", stroke_width=sw, opacity=op)}{t}/>'


def g(content, tx=0, ty=0, rot=0, s=1, op=None):
    tr = f'translate({tx} {ty}) rotate({rot}) scale({s})'
    o = f' opacity="{op}"' if op is not None else ''
    return f'<g transform="{tr}"{o}>{content}</g>'


def shine(cx, cy, rx, ry, rot=-25, op=0.55):
    return ell(cx, cy, rx, ry, '#ffffff', stroke=None, op=op, rot=rot)


def shadow(cy=180, rx=72, ry=9):
    return ell(100, cy, rx, ry, '#000000', stroke=None, op=0.13)


# ───────────── vessels ─────────────

def plate(cy=138, rx=86, ry=36, fill='#ffffff', inner='#f3ece0', band=None):
    s = shadow(cy + ry - 2, rx - 6, 8)
    s += ell(100, cy + 5, rx, ry, '#d9cdb8')
    s += ell(100, cy, rx, ry, fill)
    s += ell(100, cy + 1, rx * 0.78, ry * 0.68, inner, stroke=None)
    if band:
        s += ell(100, cy, rx - 5, ry - 3, 'none', stroke=band, sw=2.5)
    return s


def bowl(body='#ffffff', broth='#e7a24a', band='#2b6cb0', cy=100, rx=74, depth=66, ry=28):
    """Returns (back, front). Draw contents between them is not needed: the
    broth surface is part of 'back'; toppings go after it."""
    s = shadow(cy + depth + 2, rx * 0.75, 8)
    d = (f'M{100-rx} {cy} C{100-rx} {cy+depth*0.9} {100-rx*0.45} {cy+depth} 100 {cy+depth} '
         f'C{100+rx*0.45} {cy+depth} {100+rx} {cy+depth*0.9} {100+rx} {cy} Z')
    s += path(d, body)
    # band decoration
    if band:
        bd = (f'M{100-rx+5} {cy+18} C{100-rx*0.6} {cy+30} {100+rx*0.6} {cy+30} {100+rx-5} {cy+18}')
        s += path(bd, 'none', stroke=band, sw=5)
        s += path(bd.replace(str(cy + 18), str(cy + 27)).replace(str(cy + 30), str(cy + 39)), 'none', stroke=band, sw=2, op=0.6)
    s += ell(100, cy, rx, ry, body)
    s += ell(100, cy + 1, rx - 7, ry - 5, broth, stroke=O, sw=2)
    return s


def banana_leaf(cy=132, rx=92, ry=36, rot=-8, color='#4f9a3c', light='#6dbb52'):
    s = shadow(cy + ry - 4, rx - 10, 8)
    d = (f'M{100-rx} {cy} C{100-rx*0.6} {cy-ry} {100+rx*0.6} {cy-ry*1.05} {100+rx} {cy-4} '
         f'C{100+rx*0.6} {cy+ry} {100-rx*0.6} {cy+ry*1.05} {100-rx} {cy} Z')
    # rotate around centre
    inner = (path(d, color) +
             path(f'M{100-rx+8} {cy} C{100-rx*0.3} {cy-6} {100+rx*0.3} {cy-6} {100+rx-6} {cy-4}', 'none', stroke=light, sw=3) +
             ''.join(path(f'M{100-rx*0.7+i*rx*0.28:.1f} {cy-4} l8 {-ry*0.55:.1f}', 'none', stroke=light, sw=1.6, op=0.8) +
                     path(f'M{100-rx*0.7+i*rx*0.28:.1f} {cy-2} l8 {ry*0.55:.1f}', 'none', stroke=light, sw=1.6, op=0.8)
                     for i in range(6)))
    s += f'<g transform="rotate({rot} 100 {cy})">{inner}</g>'
    return s


def glass(x=62, y=46, w=76, h=118, fill='rgba(220,240,255,0.55)'):
    d = f'M{x} {y} L{x+w} {y} L{x+w-8} {y+h} Q{x+w/2} {y+h+6} {x+8} {y+h} Z'
    return d


# ───────────── food bits ─────────────

def rice_dome(cx, cy, r, h, fill='#fbf7ee', grain='#e6dcc6', seed=1, grains=26):
    rnd = random.Random(seed)
    d = f'M{cx-r} {cy} C{cx-r} {cy-h*1.33} {cx+r} {cy-h*1.33} {cx+r} {cy} Q{cx} {cy+r*0.18} {cx-r} {cy} Z'
    s = path(d, fill)
    for _ in range(grains):
        a = rnd.uniform(0.15, 0.85) * math.pi
        rr = rnd.uniform(0.1, 0.92)
        x = cx - math.cos(a) * r * rr
        y = cy - math.sin(a) * h * rr * 0.95 + 2
        s += ell(x, y, 3.2, 1.6, grain, stroke=None, rot=rnd.uniform(-60, 60))
    s += shine(cx - r * 0.35, cy - h * 0.62, r * 0.22, h * 0.12, op=0.6)
    return s


def egg_half(cx, cy, s=1, rot=0, yolk='#f7b52c'):
    return g(ell(0, 0, 17, 12, '#ffffff') + ell(1, 0, 8.5, 7, yolk, sw=2) + shine(-6, -5, 4, 2), cx, cy, rot, s)


def fried_egg(cx, cy, s=1):
    d = 'M-24 0 C-26 -14 -8 -20 4 -17 C18 -20 28 -8 24 4 C26 16 6 20 -6 17 C-20 18 -24 10 -24 0 Z'
    return g(path(d, '#ffffff') + circ(2, -1, 9, '#f7a81b', sw=2) + shine(-1, -4, 3.5, 2), cx, cy, 0, s)


def prawn(cx, cy, s=1, rot=0, color='#f26b3a', light='#ffa274'):
    d = 'M-18 -6 C-14 -20 10 -22 18 -8 C24 4 16 16 4 16 C10 10 12 2 6 -4 C0 -10 -10 -8 -12 0 Z'
    tail = 'M-12 0 L-24 -2 L-20 8 Z'
    seg = ''.join(path(f'M{x} {-14+abs(x)*0.1} q4 6 2 12', 'none', stroke=O, sw=1.6) for x in (-4, 3, 10))
    return g(path(tail, color) + path(d, color) + seg + shine(-2, -14, 6, 2.5, rot=-10, op=0.5) +
             circ(14, -6, 1.8, O, stroke=None), cx, cy, rot, s)


def chilli(cx, cy, s=1, rot=0, color='#e0322a'):
    d = 'M-22 -2 C-10 -8 10 -6 22 4 C12 4 -6 6 -20 4 Z'
    stem = 'M-22 -2 C-26 -4 -28 -8 -27 -12'
    return g(path(d, color) + path(stem, 'none', stroke='#3f8a2c', sw=3.5) + shine(-6, -4, 7, 1.4, rot=0, op=0.5), cx, cy, rot, s)


def chilli_ring(cx, cy, r=4, color='#e0322a'):
    return circ(cx, cy, r, color, sw=1.6) + circ(cx, cy, r * 0.45, '#ffd7a8', stroke=None)


def herb(cx, cy, s=1, rot=0, color='#4caf50', vein='#2e7d32'):
    d = 'M-10 0 C-5 -7 5 -7 10 0 C5 7 -5 7 -10 0 Z'
    return g(path(d, color, sw=1.8) + path('M-9 0 L9 0', 'none', stroke=vein, sw=1.2), cx, cy, rot, s)


def cucumber(cx, cy, r=9, rot=0):
    return g(ell(0, 0, r, r * 0.8, '#3f8f3a', sw=2) + ell(0, 0, r * 0.78, r * 0.6, '#d9f2b4', stroke=None) +
             ''.join(ell(math.cos(a) * r * 0.35, math.sin(a) * r * 0.28, 1.4, 0.9, '#a7cf7c', stroke=None)
                     for a in [i * math.pi / 3 for i in range(6)]), cx, cy, rot)


def lime(cx, cy, r=10):
    s = circ(cx, cy, r, '#7cc142', sw=2) + circ(cx, cy, r * 0.78, '#d6f09b', stroke=None)
    for i in range(6):
        a = i * math.pi / 3
        s += path(f'M{cx} {cy} L{cx+math.cos(a)*r*0.75:.1f} {cy+math.sin(a)*r*0.75:.1f}', 'none', stroke='#9fd35f', sw=1.4)
    return s


def noodles(cx, cy, w, h, color, n=12, sw=4.5, seed=3, wav=5, dark=None, curly=False):
    rnd = random.Random(seed)
    s = ''
    for i in range(n):
        y = cy - h / 2 + h * (i + 0.5) / n + rnd.uniform(-2, 2)
        frac = 1 - abs((y - cy) / (h / 2 + 0.01)) ** 2
        half = w / 2 * max(0.25, math.sqrt(max(frac, 0)))
        x0, x1 = cx - half + rnd.uniform(0, 6), cx + half - rnd.uniform(0, 6)
        pts = []
        steps = 7 if not curly else 12
        for k in range(steps + 1):
            x = x0 + (x1 - x0) * k / steps
            amp = wav * (1.6 if curly else 1)
            yy = y + math.sin(k * (2.6 if curly else 1.4) + i) * amp * rnd.uniform(0.6, 1.0)
            pts.append((x, yy))
        d = f'M{pts[0][0]:.1f} {pts[0][1]:.1f} ' + ' '.join(f'L{x:.1f} {yy:.1f}' for x, yy in pts[1:])
        s += path(d, 'none', stroke=dark or O, sw=sw + 2.4)
        s += path(d, 'none', stroke=color, sw=sw)
    return s


def flat_noodles(cx, cy, w, h, color, n=9, seed=5, dark=None):
    """Wide ribbon noodles (kuey teow, laksam rolls)."""
    rnd = random.Random(seed)
    s = ''
    for i in range(n):
        x = cx + rnd.uniform(-w / 2, w / 2) * 0.8
        y = cy + rnd.uniform(-h / 2, h / 2) * 0.8
        L = rnd.uniform(26, 40)
        a = rnd.uniform(-35, 35)
        d = f'M{-L/2:.1f} 0 C{-L/6:.1f} -8 {L/6:.1f} 8 {L/2:.1f} 0'
        s += g(path(d, 'none', stroke=dark or O, sw=11) + path(d, 'none', stroke=color, sw=8), x, y, a)
    return s


def skewer(x0, y0, x1, y1, color='#c9a46a'):
    return path(f'M{x0} {y0} L{x1} {y1}', 'none', stroke=O, sw=5.5) + path(f'M{x0} {y0} L{x1} {y1}', 'none', stroke=color, sw=3)


def sprinkle(cx, cy, w, h, color, n=20, r=1.8, seed=9, shape='dot'):
    rnd = random.Random(seed)
    s = ''
    for _ in range(n):
        a = rnd.uniform(0, 2 * math.pi)
        rr = math.sqrt(rnd.uniform(0, 1))
        x, y = cx + math.cos(a) * w / 2 * rr, cy + math.sin(a) * h / 2 * rr
        if shape == 'dot':
            s += circ(x, y, r * rnd.uniform(0.7, 1.2), color, stroke=None)
        else:
            s += ell(x, y, r * 2, r * 0.7, color, stroke=None, rot=rnd.uniform(0, 180))
    return s


def steam(x, y, n=3, gap=16):
    s = ''
    for i in range(n):
        xx = x + (i - (n - 1) / 2) * gap
        d = f'M{xx} {y} c-6 -8 6 -12 0 -20 c-6 -8 6 -12 0 -18'
        s += path(d, 'none', stroke='#ffffff', sw=4, op=0.75)
    return s


def bubbles(cx, cy, w, h, color='#ffffff', n=6, seed=2):
    rnd = random.Random(seed)
    return ''.join(circ(cx + rnd.uniform(-w / 2, w / 2), cy + rnd.uniform(-h / 2, h / 2), rnd.uniform(2, 4.5), 'none',
                        stroke=color, sw=1.5, op=0.7) for _ in range(n))


def svg(content, size=200):
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200" width="{size}" height="{size}">'
            f'{content}</svg>')
