from prims import *

F = {}


def food(fn):
    F[fn.__name__] = fn
    return fn


# ───────────── KELANTAN ─────────────
@food
def akok():
    s = plate(cy=140)
    for (x, y) in [(66, 128), (134, 128), (100, 146), (100, 112)]:
        # fluted golden cake with dark caramel top
        petals = ''.join(circ(x + math.cos(a) * 15, y + math.sin(a) * 9, 6, '#c47a2c', sw=2)
                         for a in [i * math.pi / 4 for i in range(8)])
        s += petals + ell(x, y, 19, 12, '#c47a2c', stroke=None)
        s += ell(x, y - 3, 14, 8, '#7a3d12', sw=2) + ell(x - 2, y - 5, 7, 3, '#a85a24', stroke=None)
        s += shine(x - 6, y - 6, 3, 1.5)
    return s


@food
def jala_mas():
    s = plate(cy=142)
    for (cx, cy) in [(70, 134), (130, 134), (100, 112)]:
        s += ell(cx, cy + 2, 27, 15, '#c9800c', stroke=O, sw=2.5)
        rnd = random.Random(cx * 7 + cy)
        for i in range(26):
            a0 = rnd.uniform(0, 2 * math.pi)
            r = rnd.uniform(6, 23)
            d = (f'M{cx+math.cos(a0)*r:.1f} {cy+math.sin(a0)*r*0.55:.1f} '
                 f'Q{cx+math.cos(a0+1.2)*r*1.25:.1f} {cy-10+math.sin(a0+1.2)*r*0.6:.1f} '
                 f'{cx+math.cos(a0+2.4)*r:.1f} {cy+math.sin(a0+2.4)*r*0.55:.1f}')
            s += path(d, 'none', stroke=['#ffd23a', '#ffe680', '#f2b01a'][i % 3], sw=1.8)
        s += shine(cx - 9, cy - 6, 5, 2)
    return s


@food
def nasi_kerabu():
    s = plate(cy=140)
    s += rice_dome(84, 140, 44, 46, fill='#4f7fe0', grain='#7ea4f2', seed=3)
    # ulam herbs
    s += herb(132, 120, 1.1, -30, '#6fbf3b') + herb(146, 132, 1.0, 20, '#4caf50') + herb(126, 136, 0.9, 60, '#8bd04a')
    for i in range(6):
        s += path(f'M{118+i*6} 146 l8 -8', 'none', stroke='#9ad35a', sw=2.4)
    # salted egg half
    s += egg_half(140, 154, 1.0, -8, yolk='#f08a1a')
    # fried fish
    s += g(path('M-20 0 C-10 -10 12 -10 20 0 C12 10 -10 10 -20 0 Z M20 0 L28 -7 L28 7 Z', '#b8641f') +
           circ(-12, -2, 1.6, O, stroke=None), 66, 158, 6)
    s += sprinkle(84, 122, 40, 18, '#c9945a', n=14, r=1.6, seed=4)  # kerisik
    s += circ(112, 160, 7, '#c8281f', sw=2)  # sambal
    return s


@food
def solok_lada():
    s = plate(cy=140)
    s += ell(100, 140, 66, 20, '#f3d37a', stroke=None)  # coconut gravy
    for i, (x, y, r) in enumerate([(78, 126, -12), (112, 136, 8), (84, 150, -4), (126, 152, 14)]):
        body = 'M-28 0 C-20 -12 22 -12 28 -2 C22 10 -20 12 -28 0 Z'
        slit = 'M-18 -1 C-6 -6 10 -6 20 -2 C10 4 -6 4 -18 -1 Z'
        s += g(path(body, '#3f9a3a') + path(slit, '#f7ecd2', sw=1.8) +
               sprinkle(0, -2, 30, 4, '#d8b072', n=6, r=1.2, seed=i) +
               path('M28 -2 C33 -3 36 -6 36 -11', 'none', stroke='#2e6b22', sw=3.5) + shine(-10, -6, 7, 1.6), x, y, r)
    s += sprinkle(100, 142, 110, 30, '#e0322a', n=6, r=2, seed=8)
    return s


@food
def nekbat():
    s = bowl(body='#ffffff', broth='#f2c66b', band='#c47a2c', cy=104, depth=62)
    for (x, y) in [(70, 100), (92, 96), (114, 98), (134, 102), (80, 110), (104, 110), (126, 112), (100, 88)]:
        s += ell(x, y, 11, 9, '#f8b934', sw=2.2) + shine(x - 3, y - 3, 3.5, 2)
    s += shine(60, 110, 8, 2, op=0.4)
    return s


@food
def ayam_percik():
    s = plate(cy=142)
    s += ell(100, 144, 60, 18, '#e2672c', stroke=None, op=0.7)
    leg = 'M40 136 C34 108 70 92 104 98 C132 102 146 122 132 140 C120 154 70 158 40 136 Z'
    s += path(leg, '#c8521f')
    s += path('M50 128 C70 112 110 108 128 122', 'none', stroke='#f08a3a', sw=6, op=0.8)  # gravy smear
    for i in range(4):
        s += path(f'M{64+i*16} {112+i*2} l14 22', 'none', stroke='#6b2a0e', sw=3, op=0.7)  # grill marks
    s += path('M132 138 L162 152', 'none', stroke=O, sw=12) + path('M132 138 L162 152', 'none', stroke='#f3e3c4', sw=7)
    s += circ(166, 152, 7, '#f3e3c4') + circ(162, 160, 6, '#f3e3c4')
    s += shine(80, 108, 10, 3)
    s += herb(56, 154, 0.9, 10, '#4caf50')
    return s


# ───────────── TERENGGANU ─────────────
@food
def keropok_lekor():
    s = plate(cy=142)
    for i, (x, y, r) in enumerate([(84, 120, -18), (100, 134, -10), (116, 148, -4)]):
        s += g(rect(-40, -9, 80, 18, '#b9813e', rx=9) + path('M-34 -3 L34 -3', 'none', stroke='#d9a45e', sw=3) +
               ''.join(path(f'M{x2} -8 l3 16', 'none', stroke='#8a5420', sw=1.5, op=0.6) for x2 in (-20, 0, 20)), x, y, r)
    # sliced rounds
    for (x, y) in [(58, 150), (70, 158)]:
        s += ell(x, y, 9, 7, '#b9813e', sw=2) + ell(x, y, 6, 4.5, '#e9d4b0', stroke=None)
    # chilli dip bowl
    s += ell(148, 116, 20, 9, '#ffffff') + ell(148, 116, 15, 6, '#d6372b', sw=2) + shine(143, 114, 4, 1.4)
    return s


@food
def sata():
    s = shadow(176, 64, 8)
    for i, y in enumerate([66, 104, 142]):
        s += skewer(30, y + 18, 172, y - 6, '#d8b98a')
    for row, y in enumerate([66, 104, 142]):
        for k in range(3):
            x = 62 + k * 38
            yy = y + 12 - k * 6
            tri = f'M{x-18} {yy+12} L{x+18} {yy+10} L{x} {yy-16} Z'
            s += path(tri, '#6f9a3c' if (row + k) % 2 else '#5f8a33')
            s += path(f'M{x-12} {yy+6} L{x+12} {yy+5}', 'none', stroke='#3f5f20', sw=2.5, op=0.7)  # char
            s += path(f'M{x-6} {yy-4} L{x+6} {yy-5}', 'none', stroke='#3f5f20', sw=2, op=0.6)
            s += ell(x + 2, yy + 9, 6, 2, '#f08a3a', stroke=None, op=0.85)  # peeking fish
    return s


@food
def nasi_dagang():
    s = plate(cy=142)
    s += rice_dome(80, 144, 46, 44, fill='#f1e2c4', grain='#c79a5d', seed=7, grains=34)
    s += sprinkle(80, 124, 50, 26, '#7a4a1e', n=16, r=1.3, seed=2)  # fenugreek
    # tuna curry
    s += ell(134, 140, 34, 16, '#d9772a', stroke=O, sw=2.5)
    s += g(path('M-16 -8 C-4 -14 14 -10 16 0 C14 10 -6 12 -16 6 Z', '#8a4b23') + shine(-6, -6, 5, 1.8), 134, 136, -10)
    s += sprinkle(134, 142, 50, 18, '#f5b04a', n=6, r=2.4, seed=5)
    # acar
    s += cucumber(108, 164, 7) + ell(124, 164, 6, 4, '#f39c3a', sw=1.6)
    s += egg_half(58, 162, 0.75, 6)
    return s


@food
def laksam():
    s = bowl(body='#ffffff', broth='#f2ead4', band='#0e8a9e', cy=100)
    for (x, y) in [(70, 98), (96, 94), (124, 98), (84, 108), (112, 108)]:
        s += g(ell(0, 0, 13, 9, '#ffffff', sw=2.2) + path('M-8 0 C-8 -6 6 -6 6 0 C6 4 -4 4 -3 0', 'none', stroke='#cdbf9e', sw=1.8),
               x, y)
    s += herb(140, 90, 0.8, 30, '#4caf50') + herb(60, 90, 0.8, -20, '#6fbf3b')
    s += sprinkle(100, 102, 90, 18, '#e0322a', n=5, r=1.8, seed=3)
    s += path('M58 108 C80 104 120 104 142 110', 'none', stroke='#e9c97a', sw=2.5, op=0.8)
    return s


# ───────────── PENANG ─────────────
@food
def pasembur():
    s = plate(cy=142)
    # cucumber & jicama shreds
    rnd = random.Random(11)
    for i in range(22):
        x, y = rnd.uniform(52, 148), rnd.uniform(118, 152)
        s += path(f'M{x:.1f} {y:.1f} l{rnd.uniform(8,14):.1f} {rnd.uniform(-4,4):.1f}', 'none',
                  stroke='#9fd36a' if i % 2 else '#f6f2de', sw=3.2)
    # fritters
    for (x, y, r) in [(74, 118, -10), (124, 116, 15), (98, 130, 0)]:
        s += g(path('M-16 -8 C-6 -16 12 -12 16 -4 C18 8 4 12 -10 10 C-18 6 -20 -2 -16 -8 Z', '#c98a3a') +
               sprinkle(0, 0, 24, 14, '#8a5420', n=6, r=1.4, seed=x), x, y, r)
    s += rect(56, 132, 18, 14, '#f2d58a', rx=3, rot=-10) + rect(128, 132, 18, 14, '#f2d58a', rx=3, rot=12)  # tofu
    s += egg_half(100, 106, 0.9, -5)
    # peanut sauce drizzle
    s += path('M54 126 C70 138 84 118 100 132 C116 146 130 122 148 134', 'none', stroke=O, sw=9, op=0.9)
    s += path('M54 126 C70 138 84 118 100 132 C116 146 130 122 148 134', 'none', stroke='#e0672a', sw=6)
    s += sprinkle(100, 128, 80, 20, '#f4c27a', n=10, r=1.6, seed=6)
    return s


@food
def char_kuey_teow():
    s = plate(cy=142)
    s += ell(100, 136, 62, 22, '#8a5326', stroke=None, op=0.5)
    s += flat_noodles(100, 132, 104, 36, '#b5733a', n=14, seed=8)
    # bean sprouts
    rnd = random.Random(4)
    for i in range(10):
        x, y = rnd.uniform(60, 140), rnd.uniform(116, 150)
        s += path(f'M{x:.1f} {y:.1f} q6 -6 12 -2', 'none', stroke=O, sw=4.5) + path(f'M{x:.1f} {y:.1f} q6 -6 12 -2', 'none', stroke='#fbf6e2', sw=2.6)
    s += prawn(78, 118, 0.85, 10) + prawn(126, 126, 0.85, -160)
    # chives
    for i in range(6):
        x = 66 + i * 14
        s += path(f'M{x} {148-i%2*20} l14 -4', 'none', stroke='#2f8a2a', sw=3.2)
    s += sprinkle(100, 130, 90, 30, '#f2c94c', n=8, r=3, seed=3)  # egg bits
    return s


@food
def asam_laksa():
    s = bowl(body='#ffffff', broth='#b8532c', band='#c0392b', cy=100)
    s += noodles(100, 102, 120, 22, '#f4ead2', n=6, sw=5, seed=4, wav=3)
    # shreds: cucumber, onion, pineapple
    rnd = random.Random(2)
    for i in range(12):
        x, y = rnd.uniform(62, 138), rnd.uniform(88, 106)
        col = ['#9fd36a', '#f5d0e6', '#f7d23a'][i % 3]
        s += path(f'M{x:.1f} {y:.1f} l10 {rnd.uniform(-3,3):.1f}', 'none', stroke=col, sw=3)
    s += herb(80, 86, 0.9, -20, '#3faa4a') + herb(118, 86, 0.9, 25, '#3faa4a') + herb(100, 82, 0.8, 80, '#56c15a')
    # torch ginger flower
    s += path('M128 92 C132 82 146 82 146 92 C146 100 132 102 128 92 Z', '#e8538a', sw=2)
    s += path('M78 98 C88 92 98 104 108 96', 'none', stroke='#3a1f0e', sw=4)  # petis
    return s


@food
def cendol():
    s = shadow(178, 52, 8)
    d = glass(60, 64, 80, 108)
    s += path(d, '#fff8ec')
    # layers inside glass
    s += path('M66 150 L134 150 L132 166 Q100 172 68 166 Z', '#f3e7cc', stroke=None)  # coconut milk
    s += path('M64 120 L136 120 L134 150 L66 150 Z', '#8a5326', stroke=None, op=0.85)  # gula melaka
    rnd = random.Random(5)
    for i in range(14):
        x, y = rnd.uniform(70, 128), rnd.uniform(124, 162)
        s += path(f'M{x:.1f} {y:.1f} q4 -4 9 0', 'none', stroke='#2f7a22', sw=5.5) + path(f'M{x:.1f} {y:.1f} q4 -4 9 0', 'none', stroke='#6fcf4a', sw=3.5)
    s += path(d, 'none')
    # shaved ice dome
    s += path('M56 66 C56 22 144 22 144 66 Z', '#f4fbff')
    s += path('M70 46 C86 56 104 36 120 50 C128 56 136 48 140 58', 'none', stroke='#8a4a20', sw=6)
    s += path('M70 46 C86 56 104 36 120 50 C128 56 136 48 140 58', 'none', stroke='#b56a2c', sw=3.5)
    for i in range(5):
        x = 72 + i * 14
        s += path(f'M{x} {58-i%2*8} q4 -5 9 0', 'none', stroke='#2f7a22', sw=5) + path(f'M{x} {58-i%2*8} q4 -5 9 0', 'none', stroke='#6fcf4a', sw=3)
    s += shine(80, 36, 10, 3, op=0.7)
    s += path('M70 76 L68 160', 'none', stroke='#ffffff', sw=4, op=0.6)
    return s
