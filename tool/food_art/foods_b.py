from prims import *

F = {}


def food(fn):
    F[fn.__name__] = fn
    return fn


def okra(cx, cy, r=7):
    pts = ' '.join(f'{cx+math.cos(i*math.pi/2.5)*r:.1f},{cy+math.sin(i*math.pi/2.5)*r*0.8:.1f}' for i in range(5))
    return (f'<polygon points="{pts}" fill="#5fa83a" stroke="{O}" stroke-width="2" stroke-linejoin="round"/>' +
            circ(cx, cy, r * 0.45, '#d9f2b4', stroke=None) + circ(cx, cy, 1.4, '#7cbf4a', stroke=None))


def meat(cx, cy, s=1, rot=0, color='#6b3a1e', light='#8a5230', seed=0):
    rnd = random.Random(seed)
    pts = []
    for i in range(8):
        a = i * math.pi / 4
        r = rnd.uniform(9, 13)
        pts.append((math.cos(a) * r * 1.2, math.sin(a) * r))
    d = 'M' + ' '.join(f'{x:.1f} {y:.1f}' for x, y in pts) + ' Z'
    return g(path(d, color, sw=2.2) + ell(-3, -3, 5, 3, light, stroke=None), cx, cy, rot, s)


# ───────────── MELAKA ─────────────
@food
def kuih_keria():
    s = plate(cy=142)
    for (x, y) in [(70, 136), (130, 136), (100, 114)]:
        s += ell(x, y, 26, 17, '#a8622a') + ell(x, y - 2, 9, 5, '#f3ece0', sw=2.5)
        s += sprinkle(x, y - 2, 44, 26, '#fff4dc', n=26, r=1.5, seed=x + y)  # sugar crust
        s += sprinkle(x, y - 2, 44, 26, '#d4893e', n=10, r=1.8, seed=x * 3)
        s += shine(x - 12, y - 8, 6, 2.5)
    return s


@food
def asam_pedas():
    s = bowl(body='#ffffff', broth='#d23a1f', band='#9b2c2c', cy=98)
    s += g(path('M-30 -4 C-18 -16 18 -16 30 -4 C18 10 -18 10 -30 -4 Z', '#d9d2c4', sw=2.5) +
           path('M-22 -4 C-10 -10 10 -10 22 -4', 'none', stroke='#8a8070', sw=2) +
           path('M-30 -4 L-34 -12 L-36 4 Z', '#cfc6b4', sw=2), 98, 96, -4)
    s += okra(64, 100) + okra(136, 98) + okra(120, 110, 6)
    s += g(path('M-8 0 A8 6 0 0 1 8 0 Z', '#f2553a', sw=2), 76, 112)  # tomato wedge
    s += herb(130, 86, 0.9, 30, '#3f8a2c') + herb(70, 88, 0.8, -30, '#3f8a2c')  # daun kesum
    s += bubbles(100, 100, 100, 20, '#ff9a7a', n=5)
    return s


@food
def chicken_rice_ball():
    s = plate(cy=142)
    for (x, y) in [(64, 132), (88, 124), (76, 146), (100, 142)]:
        s += circ(x, y, 15, '#fbf7ee') + sprinkle(x, y, 22, 22, '#e6dcc6', n=8, r=1.4, seed=x) + shine(x - 5, y - 6, 4, 2)
    for i in range(4):  # sliced chicken
        x = 120 + i * 8
        s += g(rect(-7, -16, 14, 32, '#f6e3b8', rx=4) + rect(-7, -16, 14, 7, '#e9b45a', rx=3, stroke=None), x, 132 + i * 2, 18)
    s += herb(140, 112, 0.8, -10, '#5fbf4a')
    s += ell(150, 156, 13, 6, '#ffffff', sw=2) + ell(150, 156, 9, 3.5, '#e0322a', stroke=None)
    return s


@food
def satay_celup():
    s = shadow(178, 66, 9)
    # pot
    s += path('M30 100 C30 160 50 176 100 176 C150 176 170 160 170 100 Z', '#4a4a4a')
    s += ell(100, 100, 70, 24, '#5c5c5c') + ell(100, 101, 62, 19, '#e8892e', stroke=O, sw=2)
    s += bubbles(100, 102, 100, 22, '#ffd29a', n=8, seed=5)
    s += sprinkle(100, 102, 100, 24, '#b5541c', n=12, r=2, seed=7)
    items = [('#f26b3a', 56, -20), ('#5fa83a', 76, -8), ('#f2d58a', 98, 2), ('#c9a46a', 118, 10), ('#f26b3a', 138, 22)]
    for col, x, rot in items:
        s += g(skewer(0, 0, 0, -78, '#d8b98a') +
               rect(-7, -54, 14, 18, col, rx=5) + rect(-6, -74, 12, 14, col, rx=5), x, 104, rot)
    s += rect(36, 112, 128, 6, '#333333', rx=3, stroke=None, op=0.3)
    return s


# ───────────── NEGERI SEMBILAN ─────────────
@food
def masak_lemak_cili_api():
    s = bowl(body='#ffffff', broth='#f5c22b', band='#6b4226', cy=98)
    for i, (x, y) in enumerate([(78, 96), (104, 92), (124, 104), (90, 108)]):
        s += meat(x, y, 0.9, i * 30, '#5a3a24', '#7a5236', seed=i)
    for i, (x, y, r) in enumerate([(66, 92, -30), (136, 92, 30), (112, 112, 10), (70, 110, 60)]):
        s += chilli(x, y, 0.55, r, '#2f9a2a' if i % 2 else '#e0322a')
    s += bubbles(100, 98, 100, 18, '#fff3b0', n=6)
    return s


@food
def apam_johol():
    s = plate(cy=142)
    for (x, y) in [(70, 132), (130, 132), (100, 118), (100, 146)]:
        s += path(f'M{x-20} {y+8} L{x-16} {y-6} C{x-12} {y-20} {x+12} {y-20} {x+16} {y-6} L{x+20} {y+8} Q{x} {y+14} {x-20} {y+8} Z', '#fbf3e1')
        s += path(f'M{x-8} {y-12} L{x} {y-4} L{x+8} {y-12} M{x} {y-4} L{x} {y-16}', 'none', stroke='#d9c39a', sw=2)  # cracked top
        s += shine(x - 9, y - 4, 4, 2)
        s += path(f'M{x-18} {y+6} Q{x} {y+11} {x+18} {y+6}', 'none', stroke='#e9d9b8', sw=2)
    return s


@food
def lemang():
    s = banana_leaf(cy=144, rx=88, ry=30, rot=-4)
    # bamboo tube
    s += g(rect(-62, -15, 124, 30, '#c9b25a', rx=12) + rect(-62, -15, 124, 9, '#e3d07e', rx=6, stroke=None) +
           path('M-20 -15 L-20 15 M30 -15 L30 15', 'none', stroke='#8a7a30', sw=3) +
           ell(-62, 0, 9, 15, '#2b2018') + path('M-62 -8 l-14 -6 M-62 4 l-16 2', 'none', stroke='#5a4a20', sw=2.5),
           104, 104, -12)
    for (x, y) in [(64, 146), (100, 152), (136, 146)]:
        s += ell(x, y, 15, 15, '#4f9a3c') + ell(x, y, 12, 12, '#fbf7ee', sw=2) + sprinkle(x, y, 18, 18, '#e6dcc6', n=8, r=1.2, seed=x)
        s += ell(x + 15, y, 4, 14, '#4f9a3c', stroke=None)
    return s


# ───────────── JOHOR ─────────────
@food
def laksa_johor():
    s = plate(cy=142)
    s += ell(100, 140, 64, 26, '#b8742f', stroke=O, sw=2)  # gravy
    s += noodles(100, 136, 104, 30, '#f2dca0', n=8, sw=3.6, seed=2, wav=3, curly=True)
    rnd = random.Random(9)
    for i in range(14):
        x, y = rnd.uniform(66, 134), rnd.uniform(118, 150)
        s += path(f'M{x:.1f} {y:.1f} l9 {rnd.uniform(-3,3):.1f}', 'none', stroke=['#9fd36a', '#f5d0e6', '#3faa4a'][i % 3], sw=2.8)
    s += herb(80, 118, 0.9, -20, '#3faa4a') + herb(118, 118, 0.9, 20, '#3faa4a')
    s += circ(100, 128, 7, '#d6372b', sw=2)  # sambal
    s += lime(146, 120, 9)
    return s


@food
def kacang_pool():
    s = plate(cy=146, rx=88)
    # bowl of pool on plate
    s += path('M48 116 C48 152 70 160 98 160 C126 160 148 152 148 116 Z', '#ffffff')
    s += ell(98, 116, 50, 18, '#ffffff') + ell(98, 117, 44, 14, '#6b3f1f', stroke=O, sw=2)
    s += fried_egg(98, 112, 0.85)
    s += sprinkle(98, 118, 80, 18, '#c66bb0', n=10, r=1.8, seed=3) + sprinkle(98, 118, 80, 18, '#3faa4a', n=8, r=1.6, seed=5)
    s += chilli_ring(70, 116) + chilli_ring(126, 118) + lime(136, 104, 7)
    # toasted bread
    for i, x in enumerate([150, 162]):
        s += g(rect(-12, -12, 24, 24, '#e2a35a', rx=4) + rect(-8, -8, 16, 16, '#f6d9a6', rx=3, stroke=None), x, 146 - i * 8, 15 + i * 10)
    return s


@food
def otak_otak():
    s = plate(cy=142)
    for i, (x, y, r) in enumerate([(100, 112, -8), (98, 132, -4), (102, 152, -10)]):
        s += g(rect(-52, -9, 104, 18, '#6f9a3c', rx=5) + rect(-52, -9, 104, 6, '#8fb85a', rx=3, stroke=None) +
               path('M-30 -9 L-30 9 M30 -9 L30 9', 'none', stroke='#c9c9c9', sw=3) +  # staples/lidi
               ''.join(path(f'M{x2} -8 l4 16', 'none', stroke='#3f5f20', sw=2.2, op=0.6) for x2 in (-40, -14, 10, 38)), x, y, r)
    # one opened showing orange fish paste
    s += g(rect(-28, -8, 56, 16, '#6f9a3c', rx=5) + rect(-24, -5, 48, 10, '#f07a3a', rx=4, sw=2) +
           sprinkle(0, 0, 40, 6, '#c8461e', n=8, r=1.3, seed=1), 140, 162, 8)
    return s


@food
def mee_rebus():
    s = bowl(body='#ffffff', broth='#c97a2c', band='#2c5282', cy=98)
    s += noodles(100, 102, 118, 22, '#f5c84a', n=6, sw=4.5, seed=8, wav=3)
    s += ell(100, 96, 54, 14, '#d4842f', stroke=None, op=0.75)  # thick gravy on top
    s += egg_half(84, 94, 0.85, -10)
    s += rect(108, 88, 14, 12, '#e9c46a', rx=3, rot=10) + rect(122, 98, 13, 11, '#e9c46a', rx=3, rot=-8)  # tofu
    s += lime(132, 86, 8)
    s += chilli(66, 104, 0.5, 20, '#3f9a3a') + sprinkle(100, 96, 70, 16, '#7a4a1e', n=8, r=1.6, seed=4)
    s += sprinkle(100, 96, 70, 16, '#3faa4a', n=8, r=1.6, seed=6)
    return s


# ───────────── PERAK ─────────────
@food
def rendang_tok():
    s = plate(cy=142)
    s += ell(100, 140, 58, 22, '#4a2a14', stroke=None, op=0.7)
    for i, (x, y) in enumerate([(74, 132), (100, 124), (126, 132), (88, 146), (114, 148), (100, 138)]):
        s += meat(x, y, 1.05, i * 37, '#4a2410', '#6e3a1c', seed=i + 4)
        s += sprinkle(x, y, 16, 10, '#9a6a3a', n=4, r=1.4, seed=i)
    s += path('M58 152 L84 116', 'none', stroke=O, sw=7) + path('M58 152 L84 116', 'none', stroke='#d8d9a2', sw=4)  # lemongrass
    s += herb(140, 116, 0.9, 30, '#3f8a2c')
    s += sprinkle(100, 136, 90, 30, '#c0392b', n=6, r=2, seed=8)
    return s


@food
def ayam_tauge():
    s = plate(cy=142)
    # bean sprouts heap
    rnd = random.Random(12)
    for i in range(22):
        x, y = rnd.uniform(110, 156), rnd.uniform(118, 156)
        d = f'M{x:.1f} {y:.1f} q7 -7 15 -3'
        s += path(d, 'none', stroke=O, sw=7) + path(d, 'none', stroke='#fbf6e2', sw=5) + circ(x, y, 3, '#f2d58a', sw=1.4)
    # chicken slices with soy
    for i in range(5):
        x = 52 + i * 12
        s += g(rect(-8, -18, 16, 36, '#fbefd4', rx=5) + rect(-8, -18, 16, 6, '#f2d58a', rx=3, stroke=None), x, 136, 20)
    s += path('M46 140 C60 132 80 148 102 136', 'none', stroke='#5a3214', sw=4, op=0.8)
    s += sprinkle(76, 128, 50, 14, '#3faa4a', n=8, r=1.7, seed=3)
    s += circ(126, 104, 1, 'none', stroke=None)
    return s


@food
def kuih_bahulu():
    s = plate(cy=142)
    for (x, y) in [(68, 134), (100, 120), (132, 134), (84, 152), (116, 152)]:
        petals = ''.join(circ(x + math.cos(a) * 9, y + math.sin(a) * 6.5, 6.5, '#e6a043', sw=2)
                         for a in [i * math.pi / 3 for i in range(6)])
        s += petals + ell(x, y, 12, 8, '#e6a043', stroke=None)
        s += ell(x, y - 1, 6, 4, '#c97a2a', stroke=None) + shine(x - 4, y - 4, 3, 1.5)
    return s


@food
def mee_udang():
    s = bowl(body='#ffffff', broth='#e2552c', band='#4a5568', cy=98)
    s += noodles(100, 102, 118, 22, '#f5c84a', n=6, sw=4.5, seed=11, wav=3)
    s += prawn(80, 90, 1.25, 10) + prawn(122, 92, 1.25, -170)
    s += sprinkle(100, 100, 100, 18, '#3faa4a', n=10, r=1.8, seed=2)
    s += egg_half(100, 108, 0.6, 0)
    return s


# ───────────── PAHANG ─────────────
@food
def puding_diraja():
    s = shadow(176, 64, 8)
    s += path('M30 112 C34 156 60 168 100 168 C140 168 166 156 170 112 Z', 'rgba(210,235,250,0.7)')
    s += ell(100, 112, 70, 24, 'rgba(210,235,250,0.7)')
    s += ell(100, 114, 62, 19, '#f6d77a', stroke=O, sw=2)  # custard
    s += path('M38 124 C60 136 140 136 162 124 L160 140 C140 152 60 152 40 140 Z', '#f4e4a6', stroke=None, op=0.9)
    s += path('M40 140 C60 152 140 152 160 140 L156 152 C130 162 70 162 44 152 Z', '#c99a4a', stroke=None, op=0.8)  # banana layer
    # jala emas on top
    rnd = random.Random(3)
    for i in range(18):
        x, y = rnd.uniform(56, 144), rnd.uniform(104, 122)
        s += path(f'M{x:.1f} {y:.1f} q6 -8 12 0', 'none', stroke='#f2b01a', sw=1.8)
    for (x, y) in [(70, 112), (124, 108)]:
        s += circ(x, y, 7, '#d0182c', sw=2) + shine(x - 2, y - 3, 2, 1.2)  # cherries
    for (x, y) in [(96, 110), (146, 116)]:
        s += ell(x, y, 8, 6, '#3d1b28', sw=2)  # prunes
    s += circ(110, 120, 6, '#d0182c', sw=2)
    s += path('M36 120 L40 150', 'none', stroke='#ffffff', sw=4, op=0.6)
    return s


@food
def patin_tempoyak():
    s = bowl(body='#ffffff', broth='#f2b43a', band='#276749', cy=98)
    s += g(path('M-32 -2 C-20 -16 20 -16 32 -2 C20 10 -20 10 -32 -2 Z', '#8a8f96', sw=2.5) +
           path('M-24 -4 C-10 -10 10 -10 24 -4', 'none', stroke='#c9ccd0', sw=3) +
           path('M-24 2 C-10 6 10 6 24 2', 'none', stroke='#f6e9d4', sw=3), 100, 96, -4)
    s += chilli(68, 104, 0.55, 20) + chilli(132, 104, 0.55, -20)
    s += sprinkle(100, 100, 100, 18, '#fff1b8', n=8, r=2.2, seed=5)
    s += herb(124, 86, 0.8, 30, '#3f8a2c')
    return s


@food
def nasi_kebuli():
    s = plate(cy=142)
    s += rice_dome(96, 146, 54, 48, fill='#e7a65a', grain='#c97a2a', seed=5, grains=40)
    s += sprinkle(96, 122, 70, 30, '#5a2a14', n=12, r=2.2, seed=2, shape='oval')  # raisins
    s += sprinkle(96, 122, 70, 30, '#fff1c8', n=8, r=2, seed=7, shape='oval')  # almonds
    s += meat(140, 150, 1.1, 20, '#7a3a1a', '#a0582a', seed=9)
    s += sprinkle(96, 108, 40, 14, '#c0392b', n=4, r=1.8, seed=4)
    s += herb(62, 154, 0.8, 0, '#3faa4a')
    return s


# ───────────── KEDAH ─────────────
@food
def laksa_kedah():
    s = bowl(body='#ffffff', broth='#9a5a35', band='#2f855a', cy=98)
    s += noodles(100, 102, 118, 22, '#f4ead2', n=6, sw=5, seed=13, wav=3)
    s += egg_half(122, 94, 0.9, 10)
    rnd = random.Random(5)
    for i in range(10):
        x, y = rnd.uniform(62, 110), rnd.uniform(86, 106)
        s += path(f'M{x:.1f} {y:.1f} l9 {rnd.uniform(-3,3):.1f}', 'none', stroke=['#9fd36a', '#f5d0e6'][i % 2], sw=3)
    s += herb(80, 86, 0.9, -20, '#3faa4a') + herb(98, 84, 0.8, 30, '#56c15a')
    s += lime(144, 104, 7) + chilli_ring(70, 104)
    return s


@food
def peknga():
    s = plate(cy=142)
    # round cake with a slice pulled out
    s += path('M40 128 L40 144 C40 160 160 160 160 144 L160 128', '#e0a54a')
    s += ell(100, 128, 60, 20, '#7a3f14')  # dark baked top
    s += ell(100, 128, 48, 14, '#94501c', stroke=None)
    s += path('M100 128 L148 140 L148 156 L100 144 Z', '#f6d58f', sw=2.5)  # cut face
    s += sprinkle(124, 146, 30, 10, '#e0a54a', n=10, r=1.2, seed=3)
    s += shine(74, 122, 10, 3, op=0.35)
    # loose slice
    s += g(path('M0 0 L44 -10 L44 6 L0 16 Z', '#f6d58f') + path('M0 0 L44 -10 L40 -16 L-2 -6 Z', '#7a3f14', sw=2.5), 128, 160, -10, 0.7)
    return s


@food
def nasi_ulam():
    s = plate(cy=142)
    s += rice_dome(100, 146, 56, 46, fill='#f8f4e6', grain='#e6dcc6', seed=9, grains=20)
    s += sprinkle(100, 126, 86, 40, '#3e9a3a', n=30, r=2.2, seed=1, shape='oval')
    s += sprinkle(100, 126, 86, 40, '#7cc142', n=22, r=2, seed=2, shape='oval')
    s += sprinkle(100, 126, 86, 40, '#b77a3a', n=14, r=1.6, seed=3)  # fish & kerisik
    s += sprinkle(100, 126, 86, 40, '#c66bb0', n=8, r=1.6, seed=4)  # shallots
    s += herb(148, 150, 1.0, 20, '#3faa4a') + herb(54, 150, 1.0, -20, '#56c15a')
    return s
