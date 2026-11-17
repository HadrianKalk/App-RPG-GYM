#!/usr/bin/env python3
"""Chibi paper-doll generator (28x36) — source of truth for character art.

Style approved Nov/2026: chibi proportions (hair/head ~ half the height),
thick black outlines, 2-3 flat tones per material, cloaks wrapping the body.

Every piece is built on top of a hand-drawn BODY MASK (labels per body part)
so all pieces line up. Output tokens are the existing palette tokens of
`HeroPaperDoll.buildPalette` (pixel_sprite.dart):
  K outline · W/w white/grey · E eye iris · S/s/d skin hi/base/shadow
  H/h/j hair · T/t/u torso · L/l/b leather · P/p/q cloth · C/c/v cape
  M/m/n steel · A gold · R crimson · G aura

Usage:
  python3 tool/art/chibi_gen.py              # writes lib/app/ui/paper_doll/chibi_layers.g.dart
  python3 tool/art/chibi_gen.py --preview out.png   # + PNG gallery (needs Pillow)
"""
import sys
from pathlib import Path

W, H = 28, 36
ROOT = Path(__file__).resolve().parents[2]
OUT_DART = ROOT / 'lib/app/ui/paper_doll/chibi_layers.g.dart'

# Material token triplets: (highlight, base, shadow)
SKIN, HAIR, TORSO, LEATHER, CLOTH, CAPE, STEEL = (
    ('S', 's', 'd'), ('H', 'h', 'j'), ('T', 't', 'u'), ('L', 'l', 'b'),
    ('P', 'p', 'q'), ('C', 'c', 'v'), ('M', 'm', 'n'))
GOLD, RED, AURA = ('A', 'A', 'A'), ('R', 'R', 'R'), ('G', 'G', 'G')


def grid(rows):
    """Validates and pads an ASCII grid to 28x36."""
    out = []
    for i, r in enumerate(rows):
        assert len(r) <= W, f'row {i} too long ({len(r)}): {r!r}'
        out.append(r.ljust(W, '.'))
    while len(out) < H:
        out.append('.' * W)
    return out


# ---------------------------------------------------------------------------
# Body masks. Labels: h head, e ears, n neck, t torso, a/b left/right arm,
# x/y left/right hand, l/r left/right leg, f/g left/right foot.
# ---------------------------------------------------------------------------
# The approved prototype (20 px wide, placed at x+4). Hair and face of the
# hero are taken from it so the in-app art matches what the user approved.
PROTO = [
    ".........K..K.......",
    "......K.KHKKHK.K....",
    "...KK.KHHHHHHHKHK...",
    "...KHKHHHHHHHHHHHKK.",
    "..KHHHHHHHHHHHHHHHK.",
    "..KHHHhHHHHHHHHHHHHK",
    "KKHHWWHHHHHHHHHHHHK.",
    ".KHHWWWHHHHHHHHHHHHK",
    "KHHHHWWHHHHHHhHHHHK.",
    ".KHHHHWWHHHHHHHHHHHK",
    "KHHHHHWWHHHhHHHHHHK.",
    ".KHHHHWSsHHHSsHHHHK.",
    "..KHHKSSSsHSSSSHHK..",
    "..KHKSKKSSSSSKKSHK..",
    "..KKSSWKSSSSSWKSKK..",
    "...KSSSSSSSSSSSSK...",
    "...KKsSSSssSSSSsKK..",
]

_HEAD = [
    '............................',
    '............................',
    '............................',
    '..........hhhhhhhh..........',
    '........hhhhhhhhhhhh........',
    '.......hhhhhhhhhhhhhh.......',
    '......hhhhhhhhhhhhhhhh......',
    '......hhhhhhhhhhhhhhhh......',
    '.....hhhhhhhhhhhhhhhhhh.....',
    '.....hhhhhhhhhhhhhhhhhh.....',
    '.....hhhhhhhhhhhhhhhhhh.....',
    '.....hhhhhhhhhhhhhhhhhh.....',
    '....ehhhhhhhhhhhhhhhhhhe....',
    '....ehhhhhhhhhhhhhhhhhhe....',
    '.....hhhhhhhhhhhhhhhhhh.....',
    '......hhhhhhhhhhhhhhhh......',
    '.......hhhhhhhhhhhhhh.......',
    '.........nnnnnnnnnn.........',
]
_LEGS = [
    '.......llllll..rrrrrr.......',  # 29
    '.......llllll..rrrrrr.......',
    '.......llllll..rrrrrr.......',
    '......fffffff..ggggggg......',  # 32
    '......fffffff..ggggggg......',
    '......fffffff..ggggggg......',
    '......fffffff..ggggggg......',
]
MASK = {
    'idle': grid(_HEAD + [
        '.......tttttttttttttt.......',  # 18
        '....aaatttttttttttttttbbb....'[:28],
        '....aaattttttttttttttbbb....',
        '....aaattttttttttttttbbb....',
        '....aaattttttttttttttbbb....',
        '....aaattttttttttttttbbb....',
        '....aaattttttttttttttbbb....',
        '...xxxxttttttttttttttyyyy...',  # 25
        '...xxxxttttttttttttttyyyy...',
        '....xx.tttttttttttttt.yy....',
        '.......tttttttttttttt.......',  # 28
    ] + _LEGS),
    'flex': grid([
        '............................',
        '............................',
        '............................',
        '..........hhhhhhhh..........',
        'xxxx....hhhhhhhhhhhh....yyyy',
        'xxxx...hhhhhhhhhhhhhh...yyyy',
        'xxxx..hhhhhhhhhhhhhhhh..yyyy',
        'aaaa..hhhhhhhhhhhhhhhh..bbbb',
        'aaaa.hhhhhhhhhhhhhhhhhh.bbbb',
        'aaaa.hhhhhhhhhhhhhhhhhh.bbbb',
        'aaaa.hhhhhhhhhhhhhhhhhh.bbbb',
        'aaaa.hhhhhhhhhhhhhhhhhh.bbbb',
        'aaaaehhhhhhhhhhhhhhhhhhebbbb',
        'aaaaehhhhhhhhhhhhhhhhhhebbbb',
        'aaaa.hhhhhhhhhhhhhhhhhh.bbbb',
        'aaaaa.hhhhhhhhhhhhhhhh.bbbbb',
        '.aaaaa.hhhhhhhhhhhhhh.bbbbb.',
        '..aaaaa..nnnnnnnnnn..bbbbb..',
        '...aaaatttttttttttttttbbbb...'[:28],
        '.......tttttttttttttt.......',
        '.......tttttttttttttt.......',
        '.......tttttttttttttt.......',
        '.......tttttttttttttt.......',
        '.......tttttttttttttt.......',
        '.......tttttttttttttt.......',
        '.......tttttttttttttt.......',
        '.......tttttttttttttt.......',
        '.......tttttttttttttt.......',
        '.......tttttttttttttt.......',
    ] + _LEGS),
}

ARMS = 'abxy'


def cells(pose, labels):
    m = MASK[pose]
    return {(x, y) for y in range(H) for x in range(W) if m[y][x] in labels}


class Layer:
    def __init__(self):
        self.g = [['.'] * W for _ in range(H)]

    def fill(self, region, mat, outline=True, shade=True):
        """Fills a set of cells with a material: black outline on the region
        edge, highlight on the left-most interior pixel of each row and shadow
        on the right third (simple cylindrical light from the left)."""
        region = {(x, y) for (x, y) in region if 0 <= x < W and 0 <= y < H}
        hi, base, sh = mat
        rows = {}
        for (x, y) in region:
            rows.setdefault(y, []).append(x)
        for (x, y) in region:
            edge = any((x + dx, y + dy) not in region for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))
            if outline and edge:
                self.g[y][x] = 'K'
                continue
            xs = [v for v in rows[y] if not any((v + dx, y + dy) not in region for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))]
            lo, hi_x = (min(xs), max(xs)) if xs else (x, x)
            t = base
            if shade and xs:
                if x == lo and hi_x - lo >= 2:
                    t = hi
                elif x > lo + (hi_x - lo) * 0.62:
                    t = sh
            self.g[y][x] = t
        return self

    def stamp(self, x0, y0, rows):
        """Overlays ASCII art ('.' = keep what is below)."""
        for dy, row in enumerate(rows):
            for dx, ch in enumerate(row):
                x, y = x0 + dx, y0 + dy
                if ch != '.' and 0 <= x < W and 0 <= y < H:
                    self.g[y][x] = ch
        return self

    def put(self, token, pts):
        for x, y in pts:
            if 0 <= x < W and 0 <= y < H:
                self.g[y][x] = token
        return self

    def erase(self, pts):
        return self.put('.', pts)

    def rows(self):
        return [''.join(r) for r in self.g]


def rect(x0, y0, x1, y1):
    return {(x, y) for y in range(y0, y1 + 1) for x in range(x0, x1 + 1)}


# ---------------------------------------------------------------------------
# Body (skin) — head, ears, neck, torso, arms, hands, legs, feet
# ---------------------------------------------------------------------------
def body(pose):
    l = Layer()
    for part in ('h', 'n', 't', 'a', 'b', 'x', 'y', 'l', 'r', 'f', 'g'):
        l.fill(cells(pose, part), SKIN, shade=part not in 'h')
    l.fill(cells(pose, 'h') | cells(pose, 'e'), SKIN, shade=False)  # head + ears as one
    # Face shading copied from the prototype (cheeks + mouth).
    for y in range(14, 17):
        for x, ch in enumerate(PROTO[y]):
            if ch == 's' and MASK[pose][y][x + 4] == 'h':
                l.g[y][x + 4] = 'd'
    l.put('d', [(13, 16), (14, 16)])
    return l


# ---------------------------------------------------------------------------
# Torso styles
# ---------------------------------------------------------------------------
def sleeves(l, pose, mat, upper_only=False):
    for side in 'ab':
        c = cells(pose, side)
        if upper_only:
            ys = sorted({y for _, y in c})
            if pose == 'idle':
                c = {(x, y) for x, y in c if y <= ys[0] + 2}
            else:
                c = {(x, y) for x, y in c if y >= 17}
        l.fill(c, mat)


def bracers(l, pose, mat):
    if pose == 'idle':
        l.fill(rect(4, 22, 6, 24), mat).fill(rect(21, 22, 23, 24), mat)
    else:
        l.fill(rect(0, 8, 3, 10), mat).fill(rect(24, 8, 27, 10), mat)


def pauldrons(l, pose, mat, big=False):
    if pose == 'idle':
        a = rect(3, 17, 9, 20) - {(3, 17), (9, 17)}
        b = rect(18, 17, 24, 20) - {(18, 17), (24, 17)}
        if big:
            a |= rect(2, 18, 9, 21) - {(2, 18)}
            b |= rect(18, 18, 25, 21) - {(25, 18)}
    else:
        a = rect(2, 16, 8, 19) - {(2, 16), (8, 16)}
        b = rect(19, 16, 25, 19) - {(19, 16), (25, 16)}
    l.fill(a, mat).fill(b, mat)
    hl = mat[0]
    l.put(hl, [(5, 18), (6, 18)] if pose == 'idle' else [(4, 17), (5, 17)])
    l.put(hl, [(20, 18), (21, 18)] if pose == 'idle' else [(21, 17), (22, 17)])


def torso(style, pose):
    l = Layer()
    t = cells(pose, 't')
    if style == 'mercenaryArmor':
        sleeves(l, pose, CLOTH)
        l.fill(t, TORSO)
        l.put('b', [(9 + i, 19 + i) for i in range(7)] + [(10 + i, 19 + i) for i in range(7)])  # strap
        l.fill(rect(7, 26, 20, 27), LEATHER).put('A', [(13, 26), (14, 26)])
        l.put('R', [(10 + i, 18) for i in range(8)])  # scarf
        l.put('u', [(x, 23) for x in range(9, 19)])
        bracers(l, pose, LEATHER)
        pauldrons(l, pose, TORSO)
    elif style == 'trainingTunic':
        l.fill(t, TORSO)
        sleeves(l, pose, TORSO, upper_only=True)
        l.put('s', [(12, 19), (13, 19), (14, 19), (15, 19), (13, 20), (14, 20)])  # v-neck
        l.put('u', [(11, 19), (16, 19), (12, 20), (15, 20), (13, 21), (14, 21)])
        l.fill(rect(7, 25, 20, 26), LEATHER)
    elif style == 'bareChestWraps':
        l.put('d', [(x, 21) for x in range(9, 13)] + [(x, 21) for x in range(15, 19)])  # pecs
        l.put('d', [(13, y) for y in range(21, 26)])
        l.put('d', [(10, 23), (11, 23), (16, 23), (17, 23)])  # abs
        l.put('S', [(9, 19), (10, 19), (15, 19), (16, 19)])
        l.fill(rect(7, 26, 20, 27), RED)
        bracers(l, pose, LEATHER)
    elif style == 'crimsonBrigandine':
        sleeves(l, pose, CLOTH)
        l.fill(t, TORSO)
        l.put('A', [(x, y) for y in (20, 23) for x in range(9, 20, 3)] + [(x, y) for y in (21, 24) for x in range(10, 19, 3)])
        l.fill(rect(9, 17, 18, 19), LEATHER)  # high collar
        l.fill(rect(7, 26, 20, 27), LEATHER).put('A', [(13, 26), (14, 26)])
        bracers(l, pose, LEATHER)
    elif style == 'arcaneRobes':
        sleeves(l, pose, CAPE)
        l.fill(t | rect(7, 29, 20, 32) - {(7, 32), (20, 32)}, CAPE)  # long robe over the legs
        l.put('v', [(13, y) for y in range(27, 33)] + [(14, y) for y in range(27, 33)])
        l.put('A', [(13, y) for y in range(18, 27)] + [(14, y) for y in range(18, 27)])
        l.put('A', [(x, 25) for x in range(8, 20)])
        if pose == 'idle':
            l.put('A', [(4, 24), (5, 24), (22, 24), (23, 24)])
    elif style == 'royalPlate':
        sleeves(l, pose, TORSO)
        l.fill(t, TORSO)
        l.put('A', [(13, y) for y in range(19, 25)] + [(14, y) for y in range(19, 25)])
        l.put('u', [(x, 23) for x in range(8, 13)] + [(x, 23) for x in range(15, 20)])
        l.fill(rect(7, 26, 20, 27), GOLD)
        pauldrons(l, pose, TORSO, big=True)
        l.put('A', [(3, 21), (4, 21), (23, 21), (24, 21)] if pose == 'idle' else [])
    return l


# ---------------------------------------------------------------------------
# Legs (y 29..32) and boots (y 32..35)
# ---------------------------------------------------------------------------
def legs(style):
    l = Layer()
    lc, rc = cells('idle', 'l'), cells('idle', 'r')
    if style in ('darkBreeches', 'trainingPants', 'platedGreaves', 'crimsonCuisses'):
        l.fill(lc, CLOTH).fill(rc, CLOTH)
    if style == 'trainingPants':
        l.put('P', [(9, 30), (17, 30)])
    elif style == 'platedGreaves':
        l.fill(rect(7, 29, 12, 31), TORSO).fill(rect(15, 29, 20, 31), TORSO)
    elif style == 'crimsonCuisses':
        l.fill(rect(7, 29, 12, 30), RED).fill(rect(15, 29, 20, 30), RED)
    elif style == 'monkWraps':
        l.fill(rect(7, 29, 12, 30), CLOTH).fill(rect(15, 29, 20, 30), CLOTH)
        l.put('l', [(x, 31) for x in range(8, 12)] + [(x, 31) for x in range(16, 20)])
    elif style == 'scholarTunic':
        l.fill(rect(7, 28, 20, 31) - {(7, 31), (20, 31)}, CLOTH)
        l.put('q', [(13, y) for y in range(29, 32)] + [(14, y) for y in range(29, 32)])
    return l


def boots(style):
    l = Layer()
    f, g = cells('idle', 'f'), cells('idle', 'g')
    shin_l, shin_r = rect(7, 30, 12, 31), rect(15, 30, 20, 31)
    if style == 'cuffedMercenaryBoots':
        l.fill(f, LEATHER).fill(g, LEATHER)
        l.fill(shin_l, LEATHER).fill(shin_r, LEATHER)
        l.put('L', [(8, 31), (9, 31), (16, 31), (17, 31)])
    elif style == 'ironSabaton':
        l.fill(f, STEEL).fill(g, STEEL).fill(shin_l, STEEL).fill(shin_r, STEEL)
    elif style == 'strappedSandals':
        l.put('l', [(x, 33) for x in range(7, 12)] + [(x, 33) for x in range(16, 21)])
        l.put('l', [(x, 35) for x in range(6, 13)] + [(x, 35) for x in range(15, 22)])
    elif style == 'shadowBoots':
        l.fill(f | shin_l, CAPE).fill(g | shin_r, CAPE)
    elif style == 'crimsonGreaves':
        l.fill(f | shin_l, RED).fill(g | shin_r, RED).put('A', [(x, 32) for x in range(8, 12)] + [(x, 32) for x in range(16, 20)])
    elif style == 'gildedBoots':
        l.fill(f | shin_l, LEATHER).fill(g | shin_r, LEATHER)
        l.put('A', [(x, 31) for x in range(8, 12)] + [(x, 31) for x in range(16, 20)] + [(7, 34), (20, 34)])
    return l


# ---------------------------------------------------------------------------
# Face: eyes (left eye x9-10, right eye x17-18) and beard
# ---------------------------------------------------------------------------
def eyes(style):
    l = Layer()
    if style == 'determined':
        l.stamp(9, 12, ['.KK....KK.'])               # brows
        l.stamp(10, 13, ['KK.....KK', 'WE.....WE'])
    elif style == 'focused':
        l.stamp(9, 12, ['KK......KK'])
        l.stamp(10, 13, ['.......', 'KE.....EK'])
    elif style == 'glowing':
        l.stamp(10, 13, ['EE.....EE', 'WE.....EW'])
    elif style == 'serene':
        l.stamp(9, 14, ['KKK.....KKK'])
    elif style == 'scarredOneEye':
        l.stamp(17, 13, ['KK', 'WK'])               # open right eye (prototype)
        l.stamp(9, 14, ['KKK'])                      # closed left eye
        l.put('d', [(11, 12), (10, 13), (10, 15)])  # scar
    return l


def beard(style):
    l = Layer()
    if style == 'stubble':
        l.put('j', [(x, y) for y in (15, 16) for x in range(8, 20) if (x + y) % 2 == 0 and x not in (12, 13, 14, 15)])
    elif style == 'shortBeard':
        l.fill(rect(7, 15, 20, 18) - {(7, 15), (20, 15), (7, 18), (20, 18)}, HAIR)
        l.put('d', [(12, 16), (13, 16), (14, 16), (15, 16)])
    elif style == 'warlordBeard':
        l.fill(rect(7, 15, 20, 18) | rect(9, 19, 18, 20) | rect(11, 21, 16, 21), HAIR)
        l.put('d', [(12, 16), (13, 16), (14, 16), (15, 16)])
        l.put('H', [(9, 17), (11, 19), (13, 20)])
    elif style == 'goatee':
        l.fill(rect(11, 16, 16, 19) - {(11, 19), (16, 19)}, HAIR)
        l.put('d', [(13, 16), (14, 16)])
    return l


# ---------------------------------------------------------------------------
# Hair (rows 0..14). Spiky hair = the approved prototype.
# ---------------------------------------------------------------------------
def _proto_hair(with_streak):
    """Hair pixels of the approved prototype (+ outlines touching hair)."""
    tok = {'H': 'h', 'h': 'H', 'W': 'W' if with_streak else 'h', 'w': 'w' if with_streak else 'j'}
    rows = [['.'] * W for _ in range(H)]
    for y, row in enumerate(PROTO):
        for x, ch in enumerate(row):
            if ch in tok:
                rows[y][x + 4] = tok[ch]
    for y, row in enumerate(PROTO):
        for x, ch in enumerate(row):
            if ch == 'K' and any(0 <= y + dy < len(PROTO) and 0 <= x + dx < 20 and PROTO[y + dy][x + dx] in 'HhWw'
                                 for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                # skip outlines that belong to the eyes/face
                if y >= 12 and any(0 <= x + dx < 20 and PROTO[y][x + dx] == 'S' for dx in (-1, 1)):
                    continue
                rows[y][x + 4] = 'K'
    return [''.join(r) for r in rows]


def hair(style):
    l = Layer()
    if style in ('spikyBerserk', 'spikyWhiteStreak'):
        l.stamp(0, 0, _proto_hair(style == 'spikyWhiteStreak'))
    elif style == 'shortCrop':
        l.stamp(0, 2, [
            '..........KKKKKKKK..........',
            '........KKhhhhhhhhKK........',
            '.......KhhhHHhhhhhhhK.......',
            '......KhhhhhhhhhhhhhhK......',
            '......KhhhhhhhhhhhhhhK......',
            '.....KhhhhhhhhhhhhhhhhK.....',
            '.....KhhKhhhhKhhhhKhhhK.....',
            '.....KhK.KhhK.KhhK.KhhK.....',
            '.....KK...KK...KK...KKK.....',
        ])
    elif style == 'longFlowing':
        l.stamp(0, 2, [
            '..........KKKKKKKK..........',
            '........KKhhhhhhhhKK........',
            '.......KhhHhhhhhhhhhK.......',
            '......KhhhhhhhhhhhhhhK......',
            '.....KhhhhhhhhhhhhhhhhK.....',
            '.....KhhhhhhhhhhhhhhhhK.....',
            '....KhhhhKKhhhhhhKKhhhhK....',
            '....KhhhK..KhhhhK..KhhhK....',
            '....KhhK....KKKK....KhhK....',
            '....KhhK............KhhK....',
            '....KhhK............KhhK....',
            '....KhhK............KhhK....',
            '...KhhhK............KhhhK...',
            '...KhhhK............KhhhK...',
            '...KhhjK............KjhhK...',
            '...KhhjK............KjhhK...',
            '...KhjjK............KjjhK...',
            '....KjK..............KjK....',
            '.....K................K.....',
        ])
    elif style == 'topknot':
        l.stamp(0, 0, [
            '............KKKK............',
            '...........KhhhhK...........',
            '...........KhHhhK...........',
            '..........KKlllKKK..........',
            '........KKhhhhhhhhKK........',
            '.......KhhhHhhhhhhhhK.......',
            '......KhhhhhhhhhhhhhhK......',
            '......KhhhhhhhhhhhhhhK......',
            '.....KhhhhhhhhhhhhhhhhK.....',
            '.....KhhK..........KhhK.....',
            '.....KhK............KhK.....',
            '.....KK..............KK.....',
        ])
    elif style == 'hooded':
        l.stamp(0, 1, [
            '..........KKKKKKKK..........',
            '........KKccccccccKK........',
            '.......KcCcccccccccvK.......',
            '......KcCccccccccccvvK......',
            '.....KcCcccccccccccccvK.....',
            '.....KcCcKKKKKKKKKKccvK.....',
            '....KcCcK..........KcvvK....',
            '....KcCK............KcvK....',
            '....KcCK............KcvK....',
            '....KcCK............KcvK....',
            '....KcCK............KcvK....',
            '....KcCcK..........KccvK....',
            '....KccccK........KcccvK....',
            '...KcccccK........KccccvK...',
            '...KccccccKKKKKKKKcccccvK...',
            '...KcccccccccccccccccccvK...',
            '....KKKKKKKKKKKKKKKKKKKK....',
        ])
    elif style == 'ironHelm':
        l.stamp(0, 0, [
            '.............KK.............',
            '............KRRK............',
            '..........KKKRRKKK..........',
            '........KKtTtttttuKK........',
            '.......KtTtttttttttuK.......',
            '......KtTtttttttttttuK......',
            '......KtTtttttttttttuK......',
            '.....KtTttttttttttttuuK.....',
            '.....KtTttttttttttttuuK.....',
            '.....KtTttttttttttttuuK.....',
            '.....KtKKKKKKKKKKKKKKuK.....',
            '.....KtKKEKKKKKKKKEKKuK.....',
            '....KKtTtttttttttttttuKK....',
            '....KutTtttttKKttttttuuK....',
            '.....KutttttK..KttttuuK.....',
            '......KKKKKK....KKKKKK......',
        ])
    return l


# ---------------------------------------------------------------------------
# Back gear (behind the body) + front mantle (over the torso)
# ---------------------------------------------------------------------------
CAPE_BACK = rect(4, 18, 23, 34) - {(4, 34), (23, 34), (6, 34), (9, 34), (12, 34), (15, 34), (18, 34), (21, 34)}


def back(style):
    l = Layer()
    if style == 'none':
        return l
    if style in ('dragonslayerCape', 'tatteredCloak', 'runicStaffCape', 'paladinWingedMantle'):
        l.fill(CAPE_BACK, CAPE)
    if style == 'dragonslayerCape':
        # Huge sword on the back: hilt above the right shoulder.
        l.stamp(19, 1, [
            '....KK',
            '...KmMK',
            '..KKmKK',
            '.KlbK..',
            'KlbK...',
            'KbK....',
        ])
    elif style == 'runicStaffCape':
        l.fill(rect(23, 3, 24, 33), LEATHER)
        l.stamp(21, 0, ['.KKK.', 'KEWEK', 'KEEEK', '.KAK.'])
    elif style == 'twinDaggersCloak':
        l.fill(rect(5, 18, 22, 28), CAPE)
        l.stamp(2, 15, ['KK', 'KMK', '.KlK'])
        l.stamp(23, 15, ['.KK', 'KMK', 'KlK.'])
    elif style == 'paladinWingedMantle':
        l.stamp(0, 12, [
            'KK..................KK',
        ])
        wing = ['KK', 'KMK', 'KMMK', 'KMMMK', 'KMMMMK', '.KMMMK', '..KMMK', '...KK']
        l.stamp(0, 12, wing)
        l.stamp(22, 12, [r[::-1].rjust(6, '.') for r in wing])
    return l


def back_front(style):
    """Mantle wrapping the shoulders, drawn over the torso (approved look)."""
    l = Layer()
    if style == 'dragonslayerCape':
        # Long brown cloak wrapping both sides of the body, open in the middle.
        l.fill(rect(3, 17, 10, 30) - {(3, 17), (3, 30), (10, 30)} | rect(17, 17, 24, 30) - {(24, 17), (24, 30), (17, 30)}, CAPE)
        l.fill(rect(7, 16, 20, 19) - {(7, 16), (20, 16)}, CAPE)
        l.put('v', [(5 + i % 3, 21 + i * 3 // 2) for i in range(6)] + [(21 - i % 3, 21 + i * 3 // 2) for i in range(6)])
        # Blade peeking out of the cloak (left), like the reference.
        l.stamp(4, 22, ['KK', 'KMK', 'KmMK', '.KmMK', '..KmK', '...K'])
    elif style == 'tatteredCloak':
        l.fill(rect(4, 16, 23, 20) - {(4, 16), (23, 16)}, CAPE)
        l.put('v', [(8, 19), (12, 19), (16, 19), (20, 19)])
    elif style == 'runicStaffCape':
        l.fill(rect(5, 16, 22, 19) - {(5, 16), (22, 16)}, CAPE).put('A', [(13, 18), (14, 18)])
    elif style == 'paladinWingedMantle':
        l.fill(rect(4, 16, 23, 19) - {(4, 16), (23, 16)}, CAPE)
        l.put('A', [(x, 19) for x in range(5, 23)])
    return l


# ---------------------------------------------------------------------------
# Weapons in hand (attack poses), drawn over the idle body
# ---------------------------------------------------------------------------
def weapon(kind):
    l = Layer()
    if kind == 'greatsword':
        blade = set()
        for i in range(22):
            y = 24 - i
            x = 21 + i // 4
            blade |= {(x, y), (x + 1, y), (x + 2, y), (x + 3, y)}
        l.fill(blade, STEEL)
        l.fill(rect(19, 24, 26, 25), GOLD).fill(rect(22, 26, 24, 29), LEATHER)
    elif kind == 'staff':
        l.fill(rect(23, 4, 25, 34), LEATHER)
        l.fill(rect(21, 0, 27, 5) - {(21, 0), (27, 0), (21, 5), (27, 5)}, ('E', 'E', 'E')).put('W', [(23, 2), (24, 2)])
    elif kind == 'daggers':
        l.fill(rect(23, 19, 25, 25), STEEL).fill(rect(22, 25, 26, 26), GOLD)
        l.fill(rect(2, 28, 4, 34), STEEL).fill(rect(1, 27, 5, 28), GOLD)
    elif kind == 'bow':
        l.stamp(22, 12, [
            '.KK...', 'KlbK..', 'KlK.K.', 'KlK.KW', 'KlK..W', 'KlK..W', 'KlK..W', 'KlK..W',
            'KlK..W', 'KlK..W', 'KlK..W', 'KlK..W', 'KlK.KW', 'KlK.K.', 'KlbK..', '.KK...'])
    elif kind == 'martial':
        l.fill(rect(20, 23, 27, 30) - {(20, 23), (27, 23), (20, 30), (27, 30)}, AURA)
        l.fill(rect(22, 25, 25, 28), SKIN).fill(rect(22, 28, 25, 29), LEATHER)
    elif kind == 'holyBlade':
        l.fill(rect(22, 3, 24, 23), STEEL).put('W', [(23, y) for y in range(5, 21, 3)])
        l.fill(rect(19, 23, 27, 24), GOLD).fill(rect(22, 25, 24, 28), LEATHER)
        l.put('G', [(20, 6), (26, 9), (20, 13), (26, 16)])
    elif kind == 'shield':
        sh = rect(1, 18, 11, 29) | rect(3, 30, 9, 31) | rect(5, 32, 7, 33)
        l.fill(sh, TORSO)
        l.fill(rect(5, 20, 7, 31), GOLD).fill(rect(3, 23, 9, 25), GOLD)
    return l


def aura():
    l = Layer()
    for x, y in [(2, 2), (25, 3), (1, 15), (26, 17), (2, 30), (25, 32)]:
        l.put('G', [(x, y)])
    return l


# ---------------------------------------------------------------------------
# Catalog -> Dart
# ---------------------------------------------------------------------------
TORSOS = ['mercenaryArmor', 'trainingTunic', 'bareChestWraps', 'crimsonBrigandine', 'arcaneRobes', 'royalPlate']
LEGS = ['darkBreeches', 'trainingPants', 'platedGreaves', 'monkWraps', 'scholarTunic', 'crimsonCuisses']
BOOTS = ['cuffedMercenaryBoots', 'ironSabaton', 'strappedSandals', 'shadowBoots', 'crimsonGreaves', 'gildedBoots']
EYES = ['scarredOneEye', 'determined', 'focused', 'glowing', 'serene']
BEARDS = ['none', 'stubble', 'shortBeard', 'warlordBeard', 'goatee']
HAIRS = ['spikyBerserk', 'spikyWhiteStreak', 'shortCrop', 'longFlowing', 'topknot', 'hooded', 'ironHelm', 'bald']
BACKS = ['dragonslayerCape', 'tatteredCloak', 'runicStaffCape', 'twinDaggersCloak', 'paladinWingedMantle', 'none']
WEAPONS = ['greatsword', 'staff', 'daggers', 'bow', 'martial', 'holyBlade', 'shield']


def catalog():
    c = {}
    for p in ('idle', 'flex'):
        c[f'body.{p}'] = body(p)
        for t in TORSOS:
            c[f'torso.{t}.{p}'] = torso(t, p)
    for s in LEGS: c[f'legs.{s}'] = legs(s)
    for s in BOOTS: c[f'boots.{s}'] = boots(s)
    for s in EYES: c[f'eyes.{s}'] = eyes(s)
    for s in BEARDS: c[f'beard.{s}'] = beard(s)
    for s in HAIRS: c[f'hair.{s}'] = hair(s)
    for s in BACKS:
        c[f'back.{s}'] = back(s)
        c[f'backFront.{s}'] = back_front(s)
    c['back.drawnCloak'] = back('tatteredCloak')
    for s in WEAPONS: c[f'weapon.{s}'] = weapon(s)
    c['aura'] = aura()
    return c


def write_dart(cat):
    lines = [
        '// GENERATED by tool/art/chibi_gen.py — do not edit by hand.',
        '// Edit the generator and run: python3 tool/art/chibi_gen.py',
        '',
        'const Map<String, List<String>> chibiLayers = {',
    ]
    for key, layer in cat.items():
        rows = layer.rows()
        # Trim fully transparent rows at the bottom to keep the file small.
        while rows and set(rows[-1]) == {'.'}:
            rows.pop()
        if not rows:
            lines.append(f"  '{key}': [],")
            continue
        lines.append(f"  '{key}': [")
        lines += [f"    '{r}'," for r in rows]
        lines.append('  ],')
    lines.append('};')
    OUT_DART.parent.mkdir(parents=True, exist_ok=True)
    OUT_DART.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    print('wrote', OUT_DART.relative_to(ROOT), len(cat), 'layers')


if __name__ == '__main__':
    cat = catalog()
    write_dart(cat)
    if '--preview' in sys.argv:
        sys.path.insert(0, str(Path(__file__).parent))
        from chibi_preview import render_gallery
        render_gallery(cat, sys.argv[sys.argv.index('--preview') + 1])
