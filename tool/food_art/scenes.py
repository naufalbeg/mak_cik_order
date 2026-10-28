"""Background scenes: one per state (400x220, wide) + home (360x640, tall).
The game draws the stall awning on top and the counter at the bottom, so
the interesting scenery sits in the middle band."""
from prims import *

W, H = 400, 220


def defs_sky(top, bottom, gid='sky'):
    return (f'<defs><linearGradient id="{gid}" x1="0" y1="0" x2="0" y2="1">'
            f'<stop offset="0" stop-color="{top}"/><stop offset="1" stop-color="{bottom}"/></linearGradient></defs>')


def sky(top, bottom, w=W, h=H):
    return defs_sky(top, bottom) + f'<rect x="0" y="0" width="{w}" height="{h}" fill="url(#sky)"/>'


def sun(x, y, r=18, color='#ffd54a'):
    return circ(x, y, r + 8, color, stroke=None, op=0.3) + circ(x, y, r, color, stroke=None)


def moon(x, y, r=14):
    return circ(x, y, r, '#fff6c8', stroke=None) + circ(x + 6, y - 4, r, '#1b2a55', stroke=None)


def stars(n, w=W, h=120, seed=1):
    rnd = random.Random(seed)
    return ''.join(circ(rnd.uniform(0, w), rnd.uniform(0, h), rnd.uniform(0.6, 1.6), '#ffffff', stroke=None, op=rnd.uniform(0.5, 1)) for _ in range(n))


def cloud(x, y, s=1, op=0.95):
    c = ell(0, 0, 22, 10, '#ffffff', stroke=None) + circ(-8, -6, 10, '#ffffff', stroke=None) + circ(8, -8, 12, '#ffffff', stroke=None)
    return g(c, x, y, 0, s, op)


def hills(color, base, amp, seed=1, w=W, h=H, n=5, outline=False):
    rnd = random.Random(seed)
    pts = [(0, base)]
    for i in range(1, n + 1):
        x = w * i / n
        pts.append((x - w / n / 2, base - amp * rnd.uniform(0.5, 1.0)))
        pts.append((x, base - amp * rnd.uniform(0.0, 0.3)))
    d = f'M0 {h} L0 {base} ' + ' '.join(f'Q{pts[i][0]:.1f} {pts[i][1]:.1f} {pts[i+1][0]:.1f} {pts[i+1][1]:.1f}' for i in range(1, len(pts) - 1, 2))
    d += f' L{w} {h} Z'
    return path(d, color, stroke=O if outline else None, sw=2)


def ground(color, y, w=W, h=H):
    return rect(0, y, w, h - y, color, stroke=None)


def palm(x, y, s=1):
    trunk = path('M0 0 C4 -20 2 -40 8 -62', 'none', stroke=O, sw=7) + path('M0 0 C4 -20 2 -40 8 -62', 'none', stroke='#9a6a3a', sw=4)
    leaves = ''
    for a in (-160, -120, -60, -20, -95):
        leaves += g(path('M0 0 C10 -10 28 -8 38 4 C26 -2 12 0 0 0 Z', '#3f9a3a', sw=2), 8, -62, a + 90)
    return g(trunk + leaves + circ(6, -58, 4, '#7a4a1e', sw=1.5) + circ(12, -58, 4, '#7a4a1e', sw=1.5), x, y, 0, s)


def tree(x, y, s=1, color='#3f9a3a', fruit=None, seed=1):
    t = rect(-4, -26, 8, 26, '#8a5a2a', rx=2, sw=2)
    t += circ(0, -40, 22, color, sw=2) + circ(-14, -30, 14, color, sw=2) + circ(14, -30, 14, color, sw=2)
    t += circ(-6, -46, 7, '#ffffff', stroke=None, op=0.2)
    if fruit:
        rnd = random.Random(seed)
        t += ''.join(ell(rnd.uniform(-18, 18), rnd.uniform(-52, -22), 3.5, 4.5, fruit, sw=1.2) for _ in range(7))
    return g(t, x, y, 0, s)


def kampung_house(x, y, s=1, wall='#c98a4a', roof='#7a4a2a'):
    h = ''.join(rect(-30 + i * 18, -10, 4, 14, '#6b4226', sw=1.5) for i in range(4))  # stilts
    h += rect(-36, -44, 72, 34, wall, sw=2.5)
    h += ''.join(path(f'M{-36} {-44+i*7} L36 {-44+i*7}', 'none', stroke='#a86a32', sw=1.2) for i in range(1, 5))
    h += path('M-46 -42 L0 -74 L46 -42 Z', roof, sw=2.5)
    h += rect(-26, -36, 12, 14, '#5a3a1e', sw=1.8) + rect(10, -36, 12, 14, '#5a3a1e', sw=1.8)
    h += path('M-20 -36 L-20 -22 M16 -36 L16 -22', 'none', stroke='#c9a46a', sw=1.5)
    h += path('M-10 4 L-10 -10 L4 -10 L4 4', 'none', stroke='#6b4226', sw=2)  # stairs
    return g(h, x, y, 0, s)


def wau(x, y, s=1, rot=-10, c1='#e53e3e', c2='#f2c53a'):
    k = path('M0 -30 C14 -28 30 -14 34 -2 C24 -8 14 -6 8 0 C14 4 18 14 16 24 C10 16 4 14 0 16 C-4 14 -10 16 -16 24 C-18 14 -14 4 -8 0 C-14 -6 -24 -8 -34 -2 C-30 -14 -14 -28 0 -30 Z', c1, sw=2)
    k += path('M0 -24 C8 -20 18 -12 22 -4 M0 -24 C-8 -20 -18 -12 -22 -4', 'none', stroke=c2, sw=3)
    k += path('M0 -30 L0 16', 'none', stroke=O, sw=1.5) + circ(0, -6, 4, c2, sw=1.5)
    k += path('M0 16 C-6 30 6 40 -2 56', 'none', stroke=O, sw=1, op=0.6)
    return g(k, x, y, rot, s)


def boat(x, y, s=1, hull='#2b6cb0', stripe='#f2c53a'):
    b = path('M-34 0 C-30 12 30 12 36 -2 L44 -14 L32 -6 L-32 -6 L-42 -16 Z', hull, sw=2)
    b += path('M-32 -2 C-20 4 20 4 34 -2', 'none', stroke=stripe, sw=3)
    b += path('M0 -6 L0 -40', 'none', stroke=O, sw=2) + path('M2 -38 L22 -14 L2 -14 Z', '#ffffff', sw=1.5)
    return g(b, x, y, 0, s)


def shophouse(x, y, w, h, color, shutter='#4a7a4a'):
    s = rect(x, y - h, w, h, color, sw=2)
    s += rect(x - 3, y - h - 6, w + 6, 8, '#b84a3a', sw=2)  # roof tiles edge
    for i in range(2):
        s += rect(x + 6 + i * (w / 2), y - h + 8, w / 2 - 12, 18, shutter, sw=1.5)
        s += path(f'M{x+6+i*(w/2)+(w/2-12)/2} {y-h+8} l0 18', 'none', stroke=O, sw=1)
    s += path(f'M{x+4} {y-h/2+2} C{x+w/4} {y-h/2-8} {x+w*3/4} {y-h/2-8} {x+w-4} {y-h/2+2}', 'none', stroke=O, sw=1.5)  # arch
    s += rect(x + w / 2 - 7, y - 20, 14, 20, '#6b4226', sw=1.5)
    return s


def lantern(x, y, color='#e53e3e'):
    return path(f'M{x} {y-8} l0 -6', 'none', stroke=O, sw=1.2) + ell(x, y, 6, 7, color, sw=1.5) + rect(x - 3, y + 6, 6, 3, '#f2c53a', stroke=None)


def fairy_lights(x0, x1, y, sag=10, n=12, seed=1):
    rnd = random.Random(seed)
    d = f'M{x0} {y} Q{(x0+x1)/2} {y+sag*2} {x1} {y}'
    s = path(d, 'none', stroke='#3a2a1a', sw=1.2)
    cols = ['#ffd54a', '#ff7aa8', '#7ae0ff', '#a6f27a']
    for i in range(1, n):
        t = i / n
        bx = (1 - t) ** 2 * x0 + 2 * (1 - t) * t * (x0 + x1) / 2 + t ** 2 * x1
        by = (1 - t) ** 2 * y + 2 * (1 - t) * t * (y + sag * 2) + t ** 2 * y
        c = cols[i % 4]
        s += circ(bx, by + 3, 4.5, c, stroke=None, op=0.35) + circ(bx, by + 3, 2.2, c, stroke=None)
    return s


def city(seed, base, n=10, w=W, night=True, hmin=40, hmax=110):
    rnd = random.Random(seed)
    s = ''
    x = -10
    while x < w:
        bw = rnd.uniform(26, 46)
        bh = rnd.uniform(hmin, hmax)
        col = rnd.choice(['#2a3a6a', '#33447a', '#26335e']) if night else rnd.choice(['#9fb3c8', '#b6c6d6', '#8aa0b6'])
        s += rect(x, base - bh, bw, bh, col, stroke=O if not night else '#121a33', sw=1.5)
        for wy in range(int(base - bh + 8), int(base - 6), 10):
            for wx in range(int(x + 5), int(x + bw - 6), 9):
                if rnd.random() < (0.55 if night else 0.8):
                    s += rect(wx, wy, 5, 5, '#ffe28a' if night else '#e6f2fb', stroke=None, op=0.9 if night else 0.8)
        x += bw + rnd.uniform(2, 8)
    return s


def karst(color, base, seed=1, w=W):
    rnd = random.Random(seed)
    s = ''
    x = -20
    while x < w + 20:
        bw = rnd.uniform(50, 90)
        bh = rnd.uniform(60, 110)
        d = f'M{x} {base} C{x} {base-bh*0.9} {x+bw*0.15} {base-bh} {x+bw*0.4} {base-bh} C{x+bw*0.7} {base-bh} {x+bw} {base-bh*0.7} {x+bw} {base} Z'
        s += path(d, color, stroke=None)
        s += path(f'M{x+bw*0.3} {base-bh+10} l-4 30 M{x+bw*0.6} {base-bh+16} l3 26', 'none', stroke='#ffffff', sw=2, op=0.15)
        x += bw * 0.75
    return s


def paddy(y0, y1, color='#e8c547', line='#c9a227', w=W):
    s = rect(0, y0, w, y1 - y0, color, stroke=None)
    for i in range(8):
        yy = y0 + (y1 - y0) * (i + 1) / 9
        s += path(f'M0 {yy:.1f} Q{w/2} {yy-4:.1f} {w} {yy:.1f}', 'none', stroke=line, sw=1.5, op=0.8)
    rnd = random.Random(4)
    for _ in range(60):
        x, y = rnd.uniform(0, w), rnd.uniform(y0 + 4, y1)
        s += path(f'M{x:.1f} {y:.1f} l-2 -6 M{x:.1f} {y:.1f} l2 -6', 'none', stroke=line, sw=1.2)
    return s


def river(y, h, color='#4aa3c9', w=W):
    s = path(f'M0 {y} C{w*0.3} {y-6} {w*0.6} {y+6} {w} {y} L{w} {y+h} L0 {y+h} Z', color, stroke=None)
    for i in range(6):
        x = 20 + i * 66
        s += path(f'M{x} {y+h*0.45} q8 -4 16 0', 'none', stroke='#ffffff', sw=2, op=0.6)
    return s


def hornbill(x, y, s=1):
    b = path('M-20 0 C-10 -12 12 -12 18 -2 C10 6 -10 8 -20 0 Z', '#1e1e24', sw=1.5)
    b += path('M14 -6 C26 -10 36 -6 40 0 C30 0 22 2 16 0 Z', '#f2c53a', sw=1.5) + path('M16 -8 C24 -14 32 -12 34 -8 Z', '#e8742c', sw=1.2)
    b += path('M-8 -4 C-20 -26 -40 -24 -48 -18 C-36 -12 -22 -6 -8 -2 Z', '#2a2a30', sw=1.5)
    b += path('M-20 2 L-34 10 L-30 2 Z', '#ffffff', sw=1.2) + circ(12, -5, 1.6, '#ffffff', stroke=None)
    return g(b, x, y, 0, s)


# ───────────── per-state scenes ─────────────

def kelantan():
    s = sky('#7ec8f2', '#d9f0ff') + sun(330, 40) + cloud(80, 40) + cloud(250, 30, 0.8)
    s += hills('#7cbf5a', 150, 50, seed=2) + hills('#5fa83a', 168, 30, seed=5)
    s += kampung_house(200, 160, 1.1) + palm(110, 168, 1.1) + palm(300, 170, 0.95)
    s += wau(80, 80, 0.9, -15) + wau(290, 70, 0.7, 12, '#2b6cb0', '#f2c53a')
    s += ground('#6fb04a', 168)
    return s


def terengganu():
    s = sky('#8fd3f4', '#e8f8ff') + sun(70, 44, 16) + cloud(260, 34) + cloud(340, 50, 0.7)
    s += rect(0, 110, W, 50, '#2f8fc4', stroke=None) + rect(0, 110, W, 8, '#57b4e0', stroke=None)
    for i in range(7):
        s += path(f'M{20+i*60} 128 q8 -4 16 0', 'none', stroke='#ffffff', sw=2, op=0.6)
    s += boat(150, 136, 0.9, '#e53e3e', '#2b6cb0') + boat(260, 128, 0.7, '#2f855a', '#f2c53a') + boat(340, 140, 0.8, '#2b6cb0', '#f2c53a')
    s += path(f'M0 160 Q200 146 400 158 L400 220 L0 220 Z', '#f2dca0', stroke=None)
    s += palm(40, 172, 1.1) + palm(370, 170, 1.0)
    return s


def penang():
    s = sky('#ffd6a0', '#fff2dc') + cloud(320, 30, 0.8)
    cols = ['#f6b6c8', '#9fd6c8', '#f6e08a', '#b6c8f2', '#f2a07a', '#c8e6a0']
    for i in range(7):
        s += shophouse(-10 + i * 60, 172, 56, 96, cols[i % 6], ['#3f7a5a', '#2b6cb0', '#9b2c2c'][i % 3])
    s += ''.join(lantern(30 + i * 56, 64 + (i % 2) * 6) for i in range(7))
    s += path('M0 58 Q200 70 400 58', 'none', stroke=O, sw=1.2)
    s += ground('#cdb79a', 172)
    return s


def melaka():
    s = sky('#a6dcf6', '#eaf7ff') + sun(340, 36, 15) + cloud(70, 36)
    # red colonial building with clock tower
    s += rect(120, 86, 170, 86, '#b8352a', sw=2.5)
    s += rect(176, 42, 44, 50, '#b8352a', sw=2.5) + path('M170 44 L198 20 L226 44 Z', '#7a1f18', sw=2.5)
    s += circ(198, 62, 11, '#fff6e5', sw=2) + path('M198 62 L198 55 M198 62 L204 64', 'none', sw=1.8)
    s += path('M114 88 L296 88 L284 76 L126 76 Z', '#7a1f18', sw=2.5)
    for i in range(6):
        s += path(f'M{132+i*26} 172 L{132+i*26} 130 C{132+i*26} 118 {150+i*26} 118 {150+i*26} 130 L{150+i*26} 172', '#fff6e5', sw=2)
    s += tree(70, 172, 1.0) + tree(340, 172, 1.1, '#4caf50')
    # trishaw
    s += g(circ(-14, 0, 9, 'none', sw=2.5) + circ(14, 0, 9, 'none', sw=2.5) + path('M-20 -8 L20 -8 L14 -26 L-16 -26 Z', '#ff7aa8', sw=2) +
           circ(-6, -30, 5, '#f2c53a', sw=1.5) + circ(6, -32, 5, '#7ae0ff', sw=1.5), 330, 176, 0, 0.9)
    s += ground('#d9c39a', 176)
    return s


def negeri_sembilan():
    s = sky('#9fd8f2', '#e6f6ff') + cloud(320, 40) + cloud(60, 30, 0.8)
    s += hills('#7cbf5a', 150, 40, seed=7)
    # Minangkabau-style house with horned roof
    hs = rect(-60, -50, 120, 50, '#a8703a', sw=2.5)
    hs += ''.join(rect(-50 + i * 34, -38, 18, 22, '#5a3a1e', sw=1.8) for i in range(4))
    hs += path('M-80 -48 C-70 -60 -60 -100 -50 -110 C-40 -84 -20 -70 0 -66 C20 -70 40 -84 50 -110 C60 -100 70 -60 80 -48 Z', '#4a3020', sw=2.5)
    hs += path('M-50 -110 l-2 -10 M50 -110 l2 -10', 'none', sw=2.5)
    hs += ''.join(rect(-56 + i * 30, 0, 5, 12, '#5a3a1e', sw=1.5) for i in range(5))
    s += g(hs, 200, 160)
    s += paddy(168, 220, '#8fcf5a', '#5fa83a')
    s += palm(70, 170, 1.0) + tree(340, 170, 1.0)
    return s


def johor():
    s = sky('#9ad7f5', '#eaf8ff') + sun(60, 40, 15) + cloud(200, 28) + cloud(330, 44, 0.8)
    s += city(5, 120, night=False, hmin=20, hmax=60)
    s += hills('#6fb04a', 140, 20, seed=3)
    s += rect(0, 140, W, 80, '#7cbf5a', stroke=None)
    for row in range(3):
        for i in range(12):
            x, y = 14 + i * 34 + (row % 2) * 17, 150 + row * 14
            s += ell(x, y, 5, 6, '#e8a33a', sw=1.4) + path(f'M{x-4} {y-6} l4 -8 l4 8', '#3f8a2c', sw=1.2)
    return s


def perak():
    s = sky('#b6e0f2', '#f0f9ff') + cloud(90, 30) + cloud(300, 40, 0.7)
    s += karst('#7a9a8a', 150, seed=4) + karst('#5f8070', 160, seed=9)
    cols = ['#f6f2de', '#e6e0c8', '#f2e6c8', '#ffffff', '#ece4cc']
    for i in range(7):
        s += shophouse(-10 + i * 60, 176, 56, 70, cols[i % 5], '#3f6a5a')
    s += ground('#cdb79a', 176)
    return s


def pahang():
    s = sky('#ffb36b', '#ffe6b8') + sun(200, 96, 24, '#ffef9a')
    s += hills('#2f7a4a', 126, 50, seed=8) + hills('#245f3a', 140, 30, seed=11)
    s += river(140, 40, '#5aaed0')
    s += g(path('M-36 0 C-28 10 28 10 36 0 L30 -6 L-30 -6 Z', '#8a5a2a', sw=2) + path('M-10 -6 L-10 -26 L10 -18 Z', '#f6f2de', sw=1.5), 130, 160, 0, 0.9)
    s += tree(40, 180, 1.1, '#2f855a') + tree(360, 180, 1.2, '#38a169') + palm(300, 182, 0.9)
    s += ground('#4f9a3c', 178)
    return s


def kedah():
    s = sky('#a6dcf6', '#f0faff') + cloud(70, 30) + cloud(300, 26, 0.8)
    s += path('M120 120 C160 40 220 36 300 120 Z', '#6a8fae', stroke=None)  # Gunung Jerai
    s += path('M190 50 C200 44 214 46 222 54 L212 58 L204 52 L196 58 Z', '#ffffff', stroke=None, op=0.6)
    s += hills('#8fbf5a', 128, 14, seed=2)
    s += paddy(128, 220)
    s += g(path('M-20 0 L-20 -20 L20 -20 L20 0 Z', '#a8703a', sw=2) + path('M-28 -18 L0 -36 L28 -18 Z', '#7a4a2a', sw=2) +
           ''.join(rect(-16 + i * 12, 0, 3, 8, '#6b4226', sw=1) for i in range(4)), 320, 150, 0, 0.8)
    s += palm(40, 160, 0.9)
    return s


def perlis():
    s = sky('#9fd8f2', '#effaff') + sun(340, 38, 14) + cloud(140, 34)
    s += karst('#8aa69a', 140, seed=12)
    s += rect(0, 140, W, 80, '#8fcf5a', stroke=None)
    for i, x in enumerate([40, 110, 180, 250, 320, 390]):
        s += tree(x, 172 - (i % 2) * 6, 1.0 + (i % 3) * 0.1, '#3f9a3a', fruit='#f2b03a', seed=i)
    return s


def selangor():
    s = sky('#1b2a55', '#5a4a8a') + stars(40, seed=2) + moon(330, 36)
    s += city(3, 172, night=True)
    s += fairy_lights(0, 200, 40, 12, seed=1) + fairy_lights(200, 400, 40, 12, seed=2)
    s += ground('#3a3550', 172)
    for i in range(4):  # market umbrellas
        x = 40 + i * 106
        s += path(f'M{x-34} 160 Q{x} 126 {x+34} 160 Z', ['#e53e3e', '#f2c53a', '#38a169', '#3182ce'][i], sw=2) + path(f'M{x} 160 l0 16', 'none', sw=2)
    return s


def kuala_lumpur():
    s = sky('#141f45', '#3d3a7a') + stars(50, seed=5) + moon(60, 40, 12)
    s += city(8, 180, night=True, hmin=30, hmax=80)
    # twin towers
    for dx in (-22, 22):
        x = 200 + dx
        tw = ''
        for k, (w_, h_) in enumerate([(30, 70), (24, 40), (18, 30), (12, 20)]):
            yb = 180 - sum(hh for _, hh in [(30, 70), (24, 40), (18, 30), (12, 20)][:k])
            tw += rect(x - w_ / 2, yb - h_, w_, h_, '#aab7c9', stroke='#121a33', sw=1.5)
            tw += ''.join(rect(x - w_ / 2 + 3, yy, w_ - 6, 2, '#ffe9a8', stroke=None, op=0.8) for yy in range(int(yb - h_ + 4), int(yb - 2), 6))
        tw += path(f'M{x} 20 L{x} 0', 'none', stroke='#dfe6ef', sw=2.5)
        s += tw
    s += rect(186, 116, 28, 5, '#aab7c9', stroke='#121a33', sw=1.2)  # skybridge
    # KL tower
    s += path('M330 180 L334 70 L338 180 Z', '#aab7c9', stroke='#121a33', sw=1.5) + ell(334, 72, 12, 7, '#c9d4e2', stroke='#121a33', sw=1.5) + path('M334 64 L334 34', 'none', stroke='#dfe6ef', sw=2)
    s += fairy_lights(0, 400, 30, 10, n=20, seed=4)
    s += ground('#2a2a44', 180)
    return s


def sabah():
    s = sky('#8fd0f2', '#eaf8ff') + cloud(80, 28) + cloud(320, 40, 0.7)
    s += path('M60 150 L130 94 L160 70 L176 48 L188 62 L198 40 L210 58 L222 44 L236 66 L260 84 L340 150 Z', '#5a6f8a', stroke=None)  # Kinabalu
    s += path('M160 70 L176 48 L188 62 L198 40 L210 58 L222 44 L236 66 L222 70 L210 64 L198 70 L186 68 L174 74 Z', '#e6eef6', stroke=None)
    s += hills('#4f9a3c', 156, 30, seed=6)
    for i in range(4):  # tamu tents
        x = 50 + i * 100
        s += path(f'M{x-36} 172 L{x} 140 L{x+36} 172 Z', ['#f2c53a', '#e53e3e', '#3182ce', '#38a169'][i], sw=2)
        s += path(f'M{x-36} 172 L{x} 140 L{x+36} 172', 'none', stroke='#ffffff', sw=1.5, op=0.6)
    s += ground('#c9a46a', 172)
    return s


def sarawak():
    s = sky('#9fd8c8', '#e6fff6') + cloud(300, 30, 0.8)
    s += hills('#2f7a4a', 120, 40, seed=13) + hills('#256b3c', 134, 26, seed=14)
    # longhouse
    lh = rect(-150, -34, 300, 34, '#a8703a', sw=2.5)
    lh += path('M-162 -32 L-140 -58 L140 -58 L162 -32 Z', '#6b4226', sw=2.5)
    lh += ''.join(rect(-140 + i * 36, -26, 14, 16, '#5a3a1e', sw=1.5) for i in range(9))
    lh += ''.join(rect(-146 + i * 30, 0, 4, 14, '#5a3a1e', sw=1.2) for i in range(11))
    lh += path('M-150 -16 L150 -16', 'none', stroke='#f2c53a', sw=2, op=0.8)
    s += g(lh, 200, 154)
    s += hornbill(90, 56, 1.0) + river(168, 40, '#4aa3a0')
    s += tree(20, 176, 1.0, '#2f855a') + palm(380, 178, 0.9)
    return s


def home():
    w, h = 360, 640
    s = sky('#ffb36b', '#ffe8c2', w, h)
    s += sun(270, 190, 46, '#fff1a8')
    s += cloud(70, 90, 1.3) + cloud(300, 70, 1.0) + cloud(180, 130, 0.8, op=0.8)
    s += wau(70, 200, 1.2, -18) + wau(300, 120, 0.9, 14, '#2b6cb0', '#f2c53a') + wau(220, 260, 0.6, -6, '#38a169', '#ffffff')
    s += hills('#7cbf5a', 420, 90, seed=3, w=w, h=h) + hills('#5fa83a', 460, 60, seed=8, w=w, h=h)
    s += kampung_house(250, 470, 1.3) + palm(60, 480, 1.6) + palm(330, 500, 1.2)
    s += rect(0, 480, w, 160, '#6fb04a', stroke=None)
    s += path(f'M0 520 Q{w/2} 500 {w} 520 L{w} {h} L0 {h} Z', '#5fa83a', stroke=None)
    return s


def all_scenes():
    out = {}
    for fn in (kelantan, terengganu, penang, melaka, negeri_sembilan, johor, perak, pahang, kedah, perlis,
               selangor, kuala_lumpur, sabah, sarawak):
        out[f'bg_{fn.__name__}'] = (fn, W, H, 1080, 594)
    out['bg_home'] = (home, 360, 640, 720, 1280)
    return out
