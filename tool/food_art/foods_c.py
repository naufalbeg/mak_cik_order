from prims import *
from foods_b import meat

F = {}


def food(fn):
    F[fn.__name__] = fn
    return fn


# ───────────── PERLIS ─────────────
def mango_slice(cx, cy, rot=0, s=1):
    d = 'M-30 4 C-20 -14 22 -14 32 0 C22 10 -20 14 -30 4 Z'
    return g(path(d, '#f9b233') + path('M-22 2 C-10 -6 12 -6 24 0', 'none', stroke='#fcd06a', sw=3) +
             shine(-8, -6, 8, 2), cx, cy, rot, s)


@food
def pulut_mempelam():
    s = plate(cy=142)
    s += rice_dome(76, 146, 40, 40, fill='#fbf7ee', grain='#ece2cc', seed=3, grains=30)
    s += path('M48 130 C60 120 92 120 104 132', 'none', stroke='#fffaf0', sw=7)
    s += path('M48 130 C60 120 92 120 104 132', 'none', stroke=O, sw=1.5, op=0.4)  # santan drizzle
    for i in range(4):
        s += mango_slice(132, 120 + i * 11, -20 + i * 8, 0.8)
    s += sprinkle(76, 122, 30, 12, '#e8b54a', n=6, r=1.6, seed=2)  # toasted mung
    s += herb(150, 160, 0.8, 20, '#56c15a')
    return s


@food
def harumanis():
    s = shadow(176, 64, 9)
    # whole mango
    s += g(path('M-38 6 C-40 -30 10 -46 36 -22 C52 -6 44 26 14 34 C-10 40 -36 30 -38 6 Z', '#8fbf3a') +
           path('M-20 20 C0 30 30 22 38 6', 'none', stroke='#f2c53a', sw=10, op=0.7) +
           path('M24 -30 C28 -38 34 -40 40 -38', 'none', stroke='#5a3a1a', sw=3.5) +
           herb(46, -40, 1.1, -20, '#3f8a2c') + shine(-14, -20, 10, 4), 74, 120, -10)
    # hedgehog-cut half
    s += g(path('M-30 10 C-34 -18 34 -18 30 10 C20 22 -20 22 -30 10 Z', '#f6a623') +
           ''.join(rect(-24 + c * 12 + (r % 2) * 2, -14 + r * 9, 10, 8, '#fcbf3a', rx=2.5, sw=1.6)
                   for r in range(3) for c in range(4)) +
           path('M-30 10 C-20 24 20 24 30 10 L30 16 C20 30 -20 30 -30 16 Z', '#8fbf3a'), 136, 146, 6)
    return s


@food
def bihun_sup():
    s = bowl(body='#ffffff', broth='#c9a160', band='#dd6b20', cy=98)
    s += noodles(100, 100, 116, 24, '#fbf6ea', n=12, sw=2, seed=4, wav=2)
    for i, x in enumerate([76, 96, 116]):
        s += g(rect(-12, -6, 24, 12, '#8a5a3a', rx=3, sw=2) + rect(-12, -6, 24, 4, '#a8724a', rx=2, stroke=None), x, 94 + (i % 2) * 6, -10 + i * 10)
    s += sprinkle(100, 98, 100, 18, '#3faa4a', n=16, r=2, seed=7)  # spring onion
    s += sprinkle(100, 98, 100, 18, '#b5651d', n=14, r=1.6, seed=8)  # fried shallots
    s += herb(136, 90, 0.8, 30, '#4caf50')
    return s


# ───────────── SELANGOR ─────────────
@food
def satay():
    s = plate(cy=146, rx=90)
    for i in range(4):
        y = 108 + i * 13
        s += skewer(40, y + 14, 150, y - 8, '#d8b98a')
        for k in range(4):
            x = 62 + k * 20
            yy = y + 10 - k * 4
            s += g(rect(-9, -7, 18, 14, '#a6521f', rx=5) + rect(-9, -7, 18, 5, '#d4843a', rx=3, stroke=None) +
                   path('M-5 -6 L-3 6 M3 -6 L5 6', 'none', stroke='#5a2a0e', sw=1.6, op=0.7), x, yy, -10)
    # peanut sauce
    s += ell(150, 150, 20, 9, '#ffffff') + ell(150, 150, 15, 6, '#c8662a', sw=2) + sprinkle(150, 150, 22, 8, '#8a3f14', n=6, r=1.3, seed=1)
    s += cucumber(60, 160, 7) + cucumber(76, 166, 7)
    s += ell(96, 168, 6, 4, '#c66bb0', sw=1.6)  # onion
    # ketupat
    s += g(rect(-11, -11, 22, 22, '#9fc35a', rx=3) + path('M-11 -11 L11 11 M11 -11 L-11 11 M0 -11 L0 11 M-11 0 L11 0', 'none', stroke='#6a8f2a', sw=1.6), 124, 168, 45, 0.9)
    return s


@food
def lontong():
    s = bowl(body='#ffffff', broth='#f2b43a', band='#553c9a', cy=98)
    for (x, y) in [(74, 94), (96, 90), (84, 106), (110, 104)]:
        s += g(rect(-9, -8, 18, 16, '#fbf7ee', rx=3, sw=2) + rect(-9, -8, 18, 4, '#d9efb0', rx=2, stroke=None), x, y, 8)
    rnd = random.Random(4)
    for i in range(8):
        x, y = rnd.uniform(110, 140), rnd.uniform(86, 108)
        s += path(f'M{x:.1f} {y:.1f} l10 {rnd.uniform(-4,4):.1f}', 'none', stroke=['#5fa83a', '#f08a3a'][i % 2], sw=3.5)
    s += egg_half(128, 96, 0.7, 10)
    s += sprinkle(100, 98, 100, 18, '#c8281f', n=6, r=2.3, seed=2)
    s += sprinkle(100, 98, 100, 18, '#d9a24a', n=8, r=1.6, seed=9)  # serunding
    return s


@food
def nasi_lemak():
    s = banana_leaf(cy=140, rx=92, ry=40, rot=-6)
    s += rice_dome(92, 146, 44, 46, fill='#fbf7ee', grain='#e6dcc6', seed=2)
    s += path('M108 112 C126 102 150 110 150 126 C150 140 128 146 112 138 Z', '#c8281f')  # sambal
    s += sprinkle(130, 126, 30, 18, '#7a1414', n=8, r=1.6, seed=5)
    s += sprinkle(130, 124, 30, 18, '#f26b3a', n=5, r=1.8, seed=6)
    s += egg_half(140, 156, 1.0, 10)
    s += cucumber(62, 156, 8) + cucumber(74, 164, 8)
    # anchovies & peanuts
    rnd = random.Random(3)
    for i in range(7):
        x, y = rnd.uniform(102, 124), rnd.uniform(148, 166)
        s += g(path('M-6 0 C-3 -2 3 -2 6 0 C3 2 -3 2 -6 0 Z', '#d9a24a', sw=1.4), x, y, rnd.uniform(-40, 40))
    for i in range(5):
        x, y = rnd.uniform(102, 124), rnd.uniform(150, 168)
        s += ell(x, y, 3.2, 2.4, '#c4703a', sw=1.2)
    return s


@food
def teh_tarik():
    s = shadow(178, 46, 8)
    # glass mug
    s += path('M60 70 L140 70 L134 170 Q100 176 66 170 Z', '#c98e5a')
    s += path('M60 70 L140 70 L139 86 L61 86 Z', '#f3e2c8', stroke=None)  # foam
    s += ell(100, 70, 40, 10, '#fbf2e2')
    s += sprinkle(100, 70, 60, 10, '#e8d2b0', n=10, r=2, seed=3)
    s += path('M140 92 C166 92 166 140 136 140', 'none', stroke=O, sw=9) + path('M140 92 C166 92 166 140 136 140', 'none', stroke='#e9f3f8', sw=5)
    s += path('M72 92 L70 160', 'none', stroke='#ffffff', sw=5, op=0.5)
    # the "pull" stream from above
    return s


# ───────────── KUALA LUMPUR ─────────────
@food
def roti_canai():
    s = plate(cy=142, rx=90)
    # flaky round flatbread (slightly crumpled)
    s += ell(92, 136, 62, 26, '#e9b45a')
    for i, r in enumerate([50, 38, 26, 14]):
        s += path(f'M{92-r} {136} C{92-r} {136-r*0.5} {92+r} {136-r*0.5} {92+r} {136-2}', 'none',
                  stroke='#c9842e' if i % 2 else '#f6d58f', sw=3)
    s += sprinkle(92, 136, 110, 44, '#a85f1e', n=16, r=2.4, seed=4, shape='oval')  # crispy spots
    s += shine(66, 124, 10, 3)
    # dhal bowl
    s += path('M128 150 C128 170 140 176 154 176 C168 176 180 170 180 150 Z', '#ffffff')
    s += ell(154, 150, 26, 10, '#ffffff') + ell(154, 151, 21, 7, '#f2b43a', stroke=O, sw=2)
    s += sprinkle(154, 151, 30, 8, '#c8281f', n=5, r=1.4, seed=2)
    return s


@food
def hokkien_mee():
    s = plate(cy=142)
    s += ell(100, 138, 62, 24, '#2a1a10', stroke=None, op=0.6)
    s += noodles(100, 134, 112, 36, '#3d2614', n=11, sw=6.5, seed=6, wav=4, dark='#140a04')
    s += shine(80, 124, 18, 3, op=0.35) + shine(118, 140, 14, 2.5, op=0.3)
    s += prawn(76, 126, 0.85, 20) + prawn(124, 140, 0.85, -170)
    for (x, y, r) in [(104, 120, 20), (66, 146, -10), (138, 124, 40)]:
        s += g(path('M-12 0 C-6 -10 8 -10 12 0 C6 8 -6 8 -12 0 Z', '#7fbf4a', sw=2) + path('M-10 0 L10 0', 'none', stroke='#d9f2b4', sw=2), x, y, r)
    s += sprinkle(100, 132, 90, 28, '#d9a24a', n=8, r=2.4, seed=2)  # crispy lard/garlic
    return s


@food
def pan_mee():
    s = bowl(body='#ffffff', broth='#e9dcc0', band='#1f3c88', cy=98)
    s += flat_noodles(100, 100, 100, 18, '#f2e6c8', n=9, seed=4)
    s += ell(84, 96, 16, 8, '#7a4a2a', sw=2) + sprinkle(84, 96, 26, 10, '#5a3218', n=8, r=1.6, seed=1)  # minced meat
    # anchovies
    rnd = random.Random(8)
    for i in range(7):
        x, y = rnd.uniform(110, 134), rnd.uniform(86, 100)
        s += g(path('M-7 0 C-3 -2 3 -2 7 0 C3 2 -3 2 -7 0 Z', '#e0a548', sw=1.4), x, y, rnd.uniform(-40, 40))
    s += fried_egg(104, 108, 0.55)
    s += sprinkle(68, 104, 18, 10, '#8a1a10', n=10, r=2, seed=5)  # chilli flakes
    s += herb(130, 106, 0.9, 10, '#3f8a2c') + herb(60, 92, 0.7, -10, '#3f8a2c')
    return s


@food
def apam_balik():
    s = plate(cy=146)
    # folded half-moon pancake
    s += path('M40 140 C40 92 160 92 160 140 Z', '#c9852e')
    s += path('M48 136 C50 102 150 102 152 136', 'none', stroke='#e9a548', sw=5)
    s += sprinkle(100, 116, 100, 26, '#8a4a14', n=14, r=2, seed=4)  # honeycomb holes
    s += path('M40 140 L160 140 L156 148 L44 148 Z', '#f2d58a', sw=2.5)  # filling edge
    s += sprinkle(100, 144, 110, 4, '#a8622a', n=14, r=2, seed=5)  # peanuts
    s += sprinkle(100, 144, 110, 4, '#ffd23a', n=8, r=2, seed=6)  # corn
    s += shine(76, 112, 12, 3, op=0.4)
    # cut wedge in front
    s += g(path('M-18 10 C-18 -12 18 -12 18 10 Z', '#c9852e') + path('M-18 10 L18 10 L16 15 L-16 15 Z', '#f2d58a', sw=2), 140, 162, 8, 0.8)
    return s


# ───────────── SABAH ─────────────
@food
def kuih_cincin():
    s = plate(cy=144)
    for (x, y, r) in [(70, 140, -10), (130, 140, 12), (100, 124, 0), (100, 152, 4)]:
        s += g(ell(0, 0, 24, 14, '#6a3412', sw=2.5) +
               ''.join(ell(math.cos(a) * 12, math.sin(a) * 7, 8, 6, 'none', stroke='#9a5420', sw=2.5) for a in (0, 2.1, 4.2)) +
               ell(0, 0, 6, 3.5, '#f3ece0', sw=2) + shine(-8, -6, 4, 1.5, op=0.4), x, y, r)
    return s


@food
def amplang():
    s = plate(cy=146)
    rnd = random.Random(21)
    pts = sorted([(rnd.uniform(48, 152), rnd.uniform(106, 156)) for _ in range(22)], key=lambda p: p[1])
    for x, y in pts:
        if abs(x - 100) / 54 + abs(y - 134) / 34 > 1.25:
            continue
        s += g(rect(-11, -6, 22, 12, '#f2dcae', rx=6, sw=2) + path('M-6 -5 Q-2 0 -6 5 M2 -5 Q6 0 2 5', 'none', stroke='#d9b67a', sw=1.6),
               x, y, rnd.uniform(-40, 40))
    return s


@food
def hinava():
    s = bowl(body='#ffffff', broth='#f5f1e4', band='#2b6cb0', cy=98)
    rnd = random.Random(6)
    for i in range(11):
        x, y = rnd.uniform(64, 134), rnd.uniform(86, 108)
        s += g(rect(-11, -3.5, 22, 7, '#f9f4ea', rx=3, sw=1.8) + rect(-11, -3.5, 22, 2.2, '#c9ccd0', rx=1, stroke=None),
               x, y, rnd.uniform(-30, 30))
    for (x, y) in [(76, 92), (112, 88), (130, 104), (92, 108)]:
        s += chilli_ring(x, y, 4.5)
    for i in range(6):
        x, y = rnd.uniform(66, 134), rnd.uniform(86, 108)
        s += path(f'M{x:.1f} {y:.1f} l8 2', 'none', stroke='#f2d07a', sw=2.4)  # ginger
    s += sprinkle(100, 98, 90, 18, '#c66bb0', n=6, r=1.8, seed=2)
    s += lime(140, 86, 8) + herb(62, 92, 0.7, -20, '#3faa4a')
    return s


@food
def tuaran_mee():
    s = plate(cy=142)
    s += noodles(100, 134, 112, 36, '#f2b33a', n=11, sw=4, seed=9, wav=4, curly=True)
    for (x, y, r) in [(70, 120, 10), (132, 128, -20), (104, 150, 30)]:
        s += g(path('M-14 0 C-8 -8 8 -8 14 0 C8 6 -8 6 -14 0 Z', '#3f8f3a', sw=2) + path('M-12 0 L12 0', 'none', stroke='#9ad35a', sw=2), x, y, r)
    for (x, y) in [(96, 118), (116, 112)]:  # egg roll slices
        s += ell(x, y, 9, 6, '#f7d24a', sw=2) + ell(x, y, 5, 3, '#e8b030', stroke=None)
    for i in range(3):  # meat slices
        s += g(rect(-10, -5, 20, 10, '#c9452c', rx=3, sw=2) + rect(-10, -5, 20, 3, '#8a2a1a', rx=1, stroke=None), 78 + i * 12, 144 - i * 4, -10)
    return s


# ───────────── SARAWAK ─────────────
@food
def kek_lapis():
    s = plate(cy=150, rx=80)
    # big slice in perspective: top face + front face with stripes / checks
    x0, y0, w, h = 52, 92, 96, 52
    s += path(f'M{x0} {y0} L{x0+w} {y0} L{x0+w+14} {y0-14} L{x0+14} {y0-14} Z', '#7a3a1a')  # top
    s += path(f'M{x0+w} {y0} L{x0+w+14} {y0-14} L{x0+w+14} {y0+h-14} L{x0+w} {y0+h} Z', '#c94a5a')  # side
    cols = ['#d9405e', '#f2c53a', '#3f9a5a', '#f6f2de']
    cell = w / 6
    for r in range(4):
        for c in range(6):
            s += rect(x0 + c * cell, y0 + r * h / 4, cell, h / 4, cols[(r + c) % 4], stroke=None)
    s += rect(x0, y0, w, h, 'none')
    for r in range(1, 4):
        s += path(f'M{x0} {y0+r*h/4} L{x0+w} {y0+r*h/4}', 'none', stroke='#3d1b10', sw=1.4, op=0.6)
    s += shine(x0 + 30, y0 - 7, 16, 2.5, rot=0, op=0.35)
    return s


@food
def laksa_sarawak():
    s = bowl(body='#ffffff', broth='#c8692e', band='#1a202c', cy=98)
    s += noodles(100, 100, 116, 24, '#fbf6ea', n=12, sw=2, seed=7, wav=2)
    s += prawn(76, 92, 0.95, 10) + prawn(116, 90, 0.95, -170)
    for i, x in enumerate([92, 102, 112]):
        s += rect(x - 3, 100, 6, 16, '#f7d24a', rx=2, sw=1.6, rot=20)  # omelette strips
    for i, x in enumerate([66, 74]):
        s += rect(x - 3, 98, 6, 14, '#f6e3c4', rx=2, sw=1.6, rot=-20)  # chicken strips
    s += lime(138, 102, 8) + herb(130, 86, 0.8, 20, '#3faa4a') + herb(58, 92, 0.7, -20, '#3faa4a')
    s += circ(126, 110, 5, '#8a1a10', sw=1.6)  # sambal belacan
    return s


@food
def manok_pansoh():
    s = banana_leaf(cy=148, rx=88, ry=30, rot=-4)
    # bamboo tube lying diagonally, open end showing chicken and leaves
    s += g(rect(-70, -20, 120, 40, '#7fa83a', rx=14) + rect(-70, -20, 120, 12, '#a6c95a', rx=8, stroke=None) +
           path('M-30 -20 L-30 20 M10 -20 L10 20', 'none', stroke='#4f7a20', sw=3) +
           path('M-60 -12 L-40 -12', 'none', stroke='#2b2018', sw=4, op=0.4), 92, 112, -16)
    s += g(ell(0, 0, 14, 20, '#3f5f20') + ell(0, 0, 10, 16, '#f2d58a', sw=2), 140, 98, -16)
    for i, (x, y) in enumerate([(150, 132), (126, 144), (156, 152)]):
        s += meat(x, y, 0.8, i * 40, '#e2b06a', '#f2cf8f', seed=i + 20)
    s += herb(110, 156, 1.2, -10, '#2f7a22') + herb(170, 130, 1.0, 40, '#2f7a22')
    s += path('M60 160 L96 144', 'none', stroke=O, sw=7) + path('M60 160 L96 144', 'none', stroke='#d8d9a2', sw=4)  # lemongrass
    return s


@food
def kolo_mee():
    s = plate(cy=142)
    s += noodles(100, 134, 110, 36, '#f6dc96', n=12, sw=3.6, seed=15, wav=5, curly=True)
    s += sprinkle(84, 126, 30, 14, '#7a4a2a', n=14, r=2.2, seed=1)  # minced meat
    for i in range(4):  # char siu style red slices
        s += g(rect(-10, -5, 20, 10, '#d1442c', rx=3, sw=2) + rect(-10, -5, 20, 3, '#8a1a10', rx=1, stroke=None),
               112 + i * 9, 126 + i * 5, -15)
    s += sprinkle(100, 132, 90, 30, '#3faa4a', n=14, r=2, seed=3)
    s += sprinkle(100, 132, 90, 30, '#e8b05a', n=8, r=2, seed=4)  # fried shallots
    s += g(path('M-14 0 C-8 -8 8 -8 14 0 C8 6 -8 6 -14 0 Z', '#3f8f3a', sw=2), 60, 146, 20)
    return s
