"""Chibi characters: Mak Cik and customers. Canvas 200x240, waist-up
(the stall counter hides the lower body). Not auto-cropped, so every
character lines up the same way in the game."""
from prims import *

SKIN = {'light': '#f7d2b0', 'tan': '#e6b48a', 'brown': '#c98d62', 'dark': '#9a6340'}


def face(mood, skin, cheeks=True, glasses=False, brows_color='#3a2414'):
    s = ''
    # eyes
    if mood == 'happy':
        s += path('M74 118 Q82 108 90 118', 'none', sw=4) + path('M110 118 Q118 108 126 118', 'none', sw=4)
    else:
        for x in (82, 118):
            s += ell(x, 116, 5.5, 7, '#2a1a10', stroke=None) + circ(x + 2, 113, 2, '#ffffff', stroke=None)
    # brows
    if mood == 'angry':
        s += path('M72 100 L92 108', 'none', stroke=brows_color, sw=4.5) + path('M128 100 L108 108', 'none', stroke=brows_color, sw=4.5)
    elif mood == 'worried':
        s += path('M72 104 L90 98', 'none', stroke=brows_color, sw=4) + path('M128 104 L110 98', 'none', stroke=brows_color, sw=4)
    else:
        s += path('M73 102 Q82 97 91 101', 'none', stroke=brows_color, sw=3.5) + path('M109 101 Q118 97 127 102', 'none', stroke=brows_color, sw=3.5)
    # nose
    s += path('M98 124 Q101 128 104 125', 'none', stroke='#a0604a', sw=2.5)
    # mouth
    if mood == 'happy':
        s += path('M86 134 Q100 152 114 134 Z', '#7a2a1a', sw=3) + path('M92 142 Q100 148 108 142 Q100 140 92 142 Z', '#f27a7a', stroke=None)
    elif mood == 'angry':
        s += path('M88 144 Q100 134 112 144', 'none', sw=4)
    elif mood == 'worried':
        s += path('M88 142 Q94 136 100 141 Q106 146 112 139', 'none', sw=3.5)
    else:
        s += path('M90 136 Q100 144 110 136', 'none', sw=3.5)
    if cheeks:
        s += ell(70, 132, 8, 5, '#ff8a8a', stroke=None, op=0.45) + ell(130, 132, 8, 5, '#ff8a8a', stroke=None, op=0.45)
    if mood == 'angry':
        s += path('M140 76 l8 -8 M146 82 l10 -4 M136 70 l2 -10', 'none', stroke='#e0322a', sw=3)  # anger marks
    if glasses:
        s += circ(82, 116, 13, 'rgba(255,255,255,0.25)', sw=2.8) + circ(118, 116, 13, 'rgba(255,255,255,0.25)', sw=2.8)
        s += path('M95 115 Q100 111 105 115', 'none', sw=2.8)
    return s


def torso(shirt, collar=None, accent=None, sleeves=True):
    s = path('M34 240 C34 196 58 174 100 174 C142 174 166 196 166 240 Z', shirt)
    if sleeves:
        s += path('M36 240 C34 214 40 196 52 188', 'none', stroke=fade_dark(shirt), sw=3, op=0.6)
        s += path('M164 240 C166 214 160 196 148 188', 'none', stroke=fade_dark(shirt), sw=3, op=0.6)
    if collar == 'melayu':
        s += path('M86 174 L86 186 Q100 192 114 186 L114 174', 'none', sw=3) + path('M100 188 L100 230', 'none', sw=2.5)
        s += ''.join(circ(100, y, 2.6, accent or '#f2c53a', sw=1.4) for y in (198, 212, 226))
    elif collar == 'tie':
        s += path('M80 174 L100 194 L120 174', '#ffffff') + path('M96 194 L104 194 L108 232 L100 240 L92 232 Z', accent or '#c0392b')
    elif collar == 'round':
        s += path('M84 176 Q100 192 116 176', 'none', sw=3)
    elif collar == 'v':
        s += path('M84 176 L100 198 L116 176', 'none', sw=3)
    elif collar == 'pinafore':
        s += path('M70 240 L72 196 L128 196 L130 240 Z', accent or '#2c5282') + path('M84 176 Q100 190 116 176', 'none', sw=3)
    elif collar == 'floral':
        s += path('M84 176 Q100 190 116 176', 'none', sw=3)
        for (x, y) in [(60, 214), (138, 220), (104, 228), (76, 236), (150, 200), (52, 200)]:
            s += ''.join(circ(x + math.cos(a) * 4, y + math.sin(a) * 4, 3.2, accent or '#ffd1dc', stroke=None) for a in (0, 1.26, 2.5, 3.8, 5.0))
            s += circ(x, y, 2, '#f2c53a', stroke=None)
    return s


def fade_dark(hex_color):
    h = hex_color.lstrip('#')
    r, g_, b = int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)
    return '#%02x%02x%02x' % (int(r * 0.7), int(g_ * 0.7), int(b * 0.7))


def head(skin):
    return (circ(52, 118, 8, skin) + circ(148, 118, 8, skin) +
            rect(88, 150, 24, 30, skin, rx=8) + circ(100, 114, 47, skin))


def tudung(color, pattern=None):
    back = path('M48 118 C44 54 156 54 152 118 C156 160 150 196 100 200 C50 196 44 160 48 118 Z', color)
    chest = path('M56 170 C60 200 140 200 144 170 L156 214 C130 228 70 228 44 214 Z', color)
    face_hole = ell(100, 120, 40, 44, 'none', stroke=None)
    front = path('M56 112 C54 64 146 64 144 112 C132 88 68 88 56 112 Z', color)
    band = path('M60 104 C74 86 126 86 140 104', 'none', stroke=fade_dark(color), sw=3, op=0.7)
    pat = ''
    if pattern:
        rnd = random.Random(3)
        for _ in range(12):
            x, y = rnd.uniform(56, 144), rnd.uniform(180, 212)
            pat += circ(x, y, 2.4, pattern, stroke=None, op=0.8)
    return back, chest + pat, front + band, face_hole


def character(kind, mood):
    s = ''
    if kind == 'makcik':
        skin = SKIN['tan']
        back, chest, front, _ = tudung('#8e3b6e', '#f6b6d6')
        s += torso('#f4a259', collar='floral', accent='#fff1c8')
        s += back + chest
        s += circ(100, 120, 43, skin)
        s += front
        s += face(mood, skin)
        # little ladle in hand for happy
        if mood == 'happy':
            s += path('M162 200 L182 150', 'none', stroke=O, sw=6) + path('M162 200 L182 150', 'none', stroke='#c9a46a', sw=3)
            s += ell(184, 144, 10, 7, '#b0b7bf', rot=-30)
            s += circ(160, 204, 9, skin)
        return s

    spec = CUSTOMERS[kind]
    skin = SKIN[spec['skin']]
    s += torso(spec['shirt'], spec.get('collar'), spec.get('accent'))
    hw = spec.get('head')
    if hw == 'tudung':
        back, chest, front, _ = tudung(spec['hcolor'], spec.get('pattern'))
        s += back + chest + circ(100, 120, 43, skin) + front
    else:
        if hw == 'ponytail':
            s += ell(150, 100, 16, 30, spec['hcolor'], rot=20)
        if hw == 'bun':
            s += circ(100, 56, 18, spec['hcolor'])
        if hw == 'long':
            s += path('M50 110 C46 60 154 60 150 110 L156 190 L44 190 Z', spec['hcolor'])
        s += head(skin)
        if hw in ('short', 'ponytail', 'bun', 'long', 'songkok', 'cap', 'spiky'):
            s += path('M53 112 C48 56 152 56 147 112 C140 92 120 84 100 92 C84 84 62 90 53 112 Z', spec['hcolor'])
        if hw == 'spiky':
            s += path('M56 90 L62 62 L76 80 L86 54 L98 76 L112 52 L120 78 L136 60 L140 88 Z', spec['hcolor'])
        if hw == 'bald':
            s += path('M52 120 C50 100 60 92 66 96 L64 124 Z', spec['hcolor']) + path('M148 120 C150 100 140 92 134 96 L136 124 Z', spec['hcolor'])
            s += shine(84, 80, 12, 5, op=0.45)
        if hw == 'songkok':
            s += path('M60 84 L62 58 C80 50 120 50 138 58 L140 84 C120 78 80 78 60 84 Z', '#1e1e24')
            s += path('M64 70 C84 64 116 64 136 70', 'none', stroke='#3a3a44', sw=2)
        if hw == 'cap':
            s += path('M54 92 C54 50 146 50 146 92 Z', spec['accent2']) + path('M138 90 L176 98 C178 104 150 104 136 98 Z', spec['accent2'])
            s += circ(100, 56, 4, '#ffffff', stroke=None)
        if hw == 'helmet':
            s += path('M46 116 C40 40 160 40 154 116 L146 118 C146 76 54 76 54 118 Z', spec['accent2'])
            s += path('M58 96 C70 82 130 82 142 96', 'none', stroke='#ffffff', sw=4, op=0.6)
    if spec.get('moustache'):
        s += path('M86 132 Q93 126 100 131 Q107 126 114 132 Q107 136 100 133 Q93 136 86 132 Z', spec.get('mcolor', '#3a2414'), sw=1.5)
    s += face(mood, skin, glasses=spec.get('glasses', False), brows_color=spec.get('brows', '#3a2414'))
    if spec.get('earrings'):
        s += circ(54, 134, 4, '#f2c53a', sw=1.5) + circ(146, 134, 4, '#f2c53a', sw=1.5)
    return s


CUSTOMERS = {
    'pakcik': dict(skin='brown', shirt='#2b6cb0', collar='melayu', accent='#f2c53a', head='songkok', hcolor='#bfbfbf',
                   moustache=True, mcolor='#d9d9d9', brows='#9a9a9a'),
    'makcik_glasses': dict(skin='light', shirt='#8e5bd8', collar='v', head='tudung', hcolor='#f28ab2', pattern='#ffffff', glasses=True),
    'uncle': dict(skin='light', shirt='#ffffff', collar='round', head='bald', hcolor='#9a9a9a', glasses=True, brows='#777777'),
    'auntie': dict(skin='dark', shirt='#e8742c', collar='round', head='bun', hcolor='#1e1410', earrings=True),
    'student': dict(skin='tan', shirt='#ffffff', collar='pinafore', accent='#2c5282', head='tudung', hcolor='#f6f6f6'),
    'boy': dict(skin='tan', shirt='#e53e3e', collar='round', head='cap', hcolor='#2a1a10', accent2='#2f855a'),
    'office': dict(skin='light', shirt='#bee3f8', collar='tie', accent='#1f3c88', head='short', hcolor='#1e1410'),
    'girl': dict(skin='brown', shirt='#f6e05e', collar='round', head='ponytail', hcolor='#3a2414'),
    'rider': dict(skin='dark', shirt='#38a169', collar='v', head='helmet', accent2='#38a169', hcolor='#1e1410'),
    'teen': dict(skin='light', shirt='#553c9a', collar='round', head='spiky', hcolor='#2a1a10'),
}


def all_characters():
    out = {}
    for m in ('neutral', 'happy', 'worried'):
        out[f'makcik_{m}'] = lambda m=m: character('makcik', m)
    for k in CUSTOMERS:
        for m in ('neutral', 'happy', 'angry'):
            out[f'{k}_{m}'] = lambda k=k, m=m: character(k, m)
    return out
