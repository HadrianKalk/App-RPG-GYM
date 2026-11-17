#!/usr/bin/env python3
"""Paper-doll layer generator for the hero/opponent sprites (64x72).

Source of truth for the character art. Each layer is drawn with simple shapes
using FLAT material tokens; the app shades them at compose time
(see lib/app/ui/paper_doll/paper_doll_shader.dart), so every combination of
layers gets consistent 3-tone shading and outlines.

Input tokens (what layers contain):
  Region materials (auto-shaded): S skin, H hair, T torso/armor, L leather,
    P pants/cloth, C cape, M steel (weapons), A gold/accent, G aura, R crimson
  Forced shadow (hand-placed lines): same letters lowercase (s h t l p c m a g r)
  Forced highlight (hand-placed glints): 1..0 -> S H T L P C M A G R
  Fixed: K outline/black, W white, E eye iris  ('.' = transparent)

Usage:
  python3 tool/art/paper_doll_gen.py            # writes the Dart layers file
  python3 tool/art/paper_doll_gen.py --preview  # also renders a PNG gallery
"""
import sys
from pathlib import Path
from PIL import Image, ImageDraw

W, H = 64, 72
ROOT = Path(__file__).resolve().parents[2]
OUT_DART = ROOT / 'lib/app/ui/paper_doll/paper_doll_layers.g.dart'


class Layer:
    """64x72 grid of tokens drawn with PIL primitives (same rasterizer as the
    approved prototypes)."""

    def __init__(self):
        self.img = Image.new('L', (W, H), 0)
        self.d = ImageDraw.Draw(self.img)

    def poly(self, t, pts):
        self.d.polygon(pts, fill=ord(t))
        return self

    def ell(self, t, box):
        self.d.ellipse(box, fill=ord(t))
        return self

    def rect(self, t, box):
        self.d.rectangle(box, fill=ord(t))
        return self

    def line(self, t, pts, w=1):
        self.d.line(pts, fill=ord(t), width=w)
        return self

    def px(self, t, pts):
        for x, y in pts:
            if 0 <= x < W and 0 <= y < H:
                self.img.putpixel((x, y), ord(t))
        return self

    def only_where(self, t, pts):
        """Paints pixels only where this layer already has something."""
        for x, y in pts:
            if 0 <= x < W and 0 <= y < H and self.img.getpixel((x, y)):
                self.img.putpixel((x, y), ord(t))
        return self

    def rows(self):
        p = self.img.load()
        return [''.join(chr(p[x, y]) if p[x, y] else '.' for x in range(W)) for y in range(H)]


# ---------------------------------------------------------------------------
# Body geometry (approved "V" hero, shifted into the 64x72 frame)
# ---------------------------------------------------------------------------
HEAD = [23, 14, 41, 31]
NECK = [(27, 27), (37, 27), (37, 31), (27, 31)]
TORSO_V = [(16, 32), (48, 32), (43, 39), (39, 46), (25, 46), (21, 39)]
TRAPS = [(20, 31), (27, 27), (37, 27), (44, 31)]
LEG_L = [(24, 46), (31, 46), (30, 62), (21, 62)]
LEG_R = [(33, 46), (40, 46), (44, 62), (35, 62)]
FOOT_L = [(20, 62), (30, 62), (30, 70), (17, 70), (17, 67)]
FOOT_R = [(35, 62), (44, 62), (47, 67), (47, 70), (35, 70)]
WAIST = (25, 41, 39, 44)

# Arms per pose: dict side -> (upper, forearm, fist box)
ARMS = {
    'idle': {
        'L': ([(11, 36), (20, 36), (20, 40), (19, 44), (12, 44)],
              [(12, 44), (19, 44), (19, 50), (12, 51)],
              [11, 50, 18, 57]),
        'R': ([(44, 36), (53, 36), (53, 44), (46, 44), (45, 40)],
              [(46, 44), (53, 44), (53, 50), (46, 51)],
              [46, 50, 53, 57]),
    },
    'flex': {  # double-biceps: upper arms out, forearms up
        'L': ([(14, 33), (19, 33), (19, 40), (6, 41), (4, 36)],
              [(4, 37), (10, 37), (11, 26), (6, 25)],
              [3, 18, 12, 27]),
        'R': ([(45, 33), (50, 33), (60, 36), (58, 41), (45, 40)],
              [(54, 37), (60, 37), (58, 25), (53, 26)],
              [52, 18, 61, 27]),
    },
    'action': {  # right arm thrust forward/up holding a weapon; left arm idle
        'L': None,
        'R': ([(47, 36), (55, 35), (58, 37), (54, 42), (47, 41)],
              [(53, 35), (59, 36), (61, 27), (56, 26)],
              [55, 19, 63, 27]),
    },
}
ARMS['action']['L'] = ARMS['idle']['L']


def arm(pose, side):
    return ARMS[pose][side]


def body(pose):
    """Base anatomy: head, neck, bare arms/fists, bare legs and feet (skin)."""
    l = Layer()
    l.ell('S', HEAD).poly('S', NECK)
    for side in ('L', 'R'):
        up, fore, fist = arm(pose, side)
        l.poly('S', up).poly('S', fore).ell('S', fist)
    l.poly('S', LEG_L).poly('S', LEG_R)
    l.poly('S', [(19, 62), (30, 62), (30, 70), (17, 70)]).poly('S', [(35, 62), (44, 62), (46, 70), (35, 70)])
    # face basics shared by every style: nose + mouth shadow, jaw line, ears
    l.px('s', [(32, 24), (32, 25), (31, 28), (32, 28)])
    l.px('s', [(x, 30) for x in range(27, 38)])
    l.px('s', [(23, 22), (23, 23), (41, 22), (41, 23)])
    # arm muscles (bicep glint + separation) per pose
    if pose == 'idle':
        l.px('1', [(13, 38), (13, 39), (14, 42), (47, 38), (47, 39), (48, 42)])
        l.px('s', [(17, 40), (17, 41), (51, 41), (51, 42)])
    elif pose == 'flex':
        l.px('1', [(8, 36), (9, 35), (10, 35), (52, 35), (53, 35), (54, 36)])
        l.px('s', [(8, 39), (9, 39), (54, 39), (55, 39)])
    else:
        l.px('1', [(13, 38), (13, 39), (47, 35), (48, 35)])
        l.px('s', [(17, 40), (50, 39), (51, 39)])
    return l


# ---------------------------------------------------------------------------
# Torso styles (drawn per pose because sleeves/armor follow the arms)
# ---------------------------------------------------------------------------
def bracers(l, pose, t='L', sides=('L', 'R')):
    for side in sides:
        _, fore, _ = arm(pose, side)
        xs = [p[0] for p in fore]; ys = [p[1] for p in fore]
        if pose == 'idle' or (pose == 'action' and side == 'L'):
            l.rect(t, [min(xs), max(ys) - 4, max(xs), max(ys) - 1])
        elif pose == 'flex':
            l.rect(t, [min(xs) + 1, min(ys), max(xs) - 1, min(ys) + 4])
        else:
            l.poly(t, [(55, 30), (59, 32), (58, 35), (54, 33)])


def sleeves(l, pose, t, length='upper'):
    for side in ('L', 'R'):
        up, fore, _ = arm(pose, side)
        l.poly(t, up)
        if length == 'full':
            l.poly(t, fore)


def pauldrons(l, size='mid', t='T'):
    boxes = {'big': ([5, 27, 21, 40], [43, 27, 59, 40]), 'mid': ([7, 28, 20, 39], [44, 28, 57, 39]),
             'small': ([10, 29, 20, 37], [44, 29, 54, 37])}[size]
    _pauldrons(l, size, t)
    # Dark rim on the lower + inner side separates each pauldron from the chest.
    l.d.arc(boxes[0], -70, 160, fill=ord('K'))
    l.d.arc(boxes[1], 20, 250, fill=ord('K'))


def _pauldrons(l, size='mid', t='T'):
    if size == 'big':
        l.ell(t, [5, 27, 21, 40]).ell(t, [43, 27, 59, 40])
        l.px('3', [(9, 29), (10, 29), (11, 28), (47, 29), (48, 28), (49, 28)])
    elif size == 'mid':
        l.ell(t, [7, 28, 20, 39]).ell(t, [44, 28, 57, 39])
        l.px('3', [(10, 30), (11, 30), (12, 29), (47, 30), (48, 29), (49, 29)])
    else:
        l.ell(t, [10, 29, 20, 37]).ell(t, [44, 29, 54, 37])


def torso(style, pose):
    l = Layer()
    if style == 'mercenaryArmor':
        l.poly('P', TORSO_V).poly('P', TRAPS)
        l.poly('L', [(26, 42), (38, 42), (39, 54), (36, 52), (34, 56), (31, 52), (28, 55), (25, 52)])  # tabard
        l.rect('L', WAIST)
        l.poly('T', [(22, 33), (31, 33), (31, 40), (26, 41), (23, 37)])
        l.poly('T', [(33, 33), (42, 33), (41, 37), (38, 41), (33, 40)])
        l.poly('l', [(22, 33), (25, 32), (39, 41), (36, 42)])  # strap
        l.px('t', [(x, 36) for x in range(23, 30)] + [(x, 36) for x in range(34, 42)])
        l.px('3', [(24, 34), (25, 34), (34, 34), (35, 34)])
        l.px('A', [(31, 42), (32, 42), (31, 43), (32, 43)])
        l.poly('R', [(23, 29), (41, 29), (42, 33), (22, 33)])  # crimson scarf
        bracers(l, pose)
        pauldrons(l, 'mid')
    elif style == 'trainingTunic':
        l.poly('T', TORSO_V).poly('T', TRAPS).poly('T', [(24, 40), (40, 40), (41, 50), (23, 50)])
        sleeves(l, pose, 'T')
        l.rect('L', WAIST)
        l.px('t', [(32, y) for y in range(31, 38)])
        l.px('t', [(28, 31), (29, 32), (30, 33), (34, 33), (35, 32), (36, 31)])  # v-neck
        l.px('3', [(19, 34), (20, 34), (44, 34)])
    elif style == 'bareChestWraps':
        l.poly('S', TORSO_V).poly('S', TRAPS)
        l.px('s', [(x, 38) for x in range(23, 31)] + [(x, 38) for x in range(33, 41)])  # pec line
        l.px('s', [(32, y) for y in range(33, 45)])  # sternum/abs line
        l.px('s', [(29, 41), (30, 41), (34, 41), (35, 41), (29, 44), (30, 44), (34, 44), (35, 44)])
        l.px('1', [(22, 34), (23, 34), (24, 35), (36, 34), (37, 34), (26, 40), (27, 40)])
        l.rect('R', [24, 41, 40, 44])  # crimson sash
        l.poly('R', [(36, 44), (40, 44), (42, 52), (38, 50)])
        bracers(l, pose)
        l.px('l', [(12, 47), (17, 46), (47, 47), (52, 46)])
    elif style == 'crimsonBrigandine':
        l.poly('P', TRAPS)
        l.poly('T', TORSO_V).poly('T', [(24, 40), (40, 40), (41, 48), (23, 48)])
        studs = [(x, y) for y in range(34, 47, 3) for x in range(22 + (y % 2), 44, 4)]
        l.only_where('8', studs)
        l.rect('L', WAIST).px('A', [(31, 42), (32, 42)])
        l.poly('L', [(24, 28), (40, 28), (42, 32), (22, 32)])  # high collar
        sleeves(l, pose, 'P')
        bracers(l, pose)
        pauldrons(l, 'small', 'L')
    elif style == 'arcaneRobes':
        l.poly('C', TORSO_V).poly('C', TRAPS)
        l.poly('C', [(23, 40), (41, 40), (46, 64), (18, 64)])  # long robe skirt
        l.px('c', [(32, y) for y in range(40, 64)])
        l.poly('A', [(29, 29), (35, 29), (33, 46), (31, 46)])  # gold stole
        l.rect('A', [24, 41, 40, 43])
        sleeves(l, pose, 'C', 'full')
        for side in ('L', 'R'):  # wide cuffs
            _, fore, _ = arm(pose, side)
            xs = [p[0] for p in fore]; ys = [p[1] for p in fore]
            if pose == 'idle' or (pose == 'action' and side == 'L'):
                l.rect('A', [min(xs) - 1, max(ys) - 2, max(xs) + 1, max(ys)])
        l.px('6', [(20, 34), (21, 34), (22, 35), (24, 50), (24, 51)])
    elif style == 'royalPlate':
        l.poly('T', TORSO_V).poly('T', TRAPS)
        l.poly('T', [(24, 40), (40, 40), (42, 50), (22, 50)])  # faulds
        sleeves(l, pose, 'T', 'full')
        l.rect('A', [25, 40, 39, 41])
        l.px('a', [(32, y) for y in range(32, 40)])
        l.px('8', [(31, 34), (33, 34), (31, 36), (33, 36)])
        l.px('t', [(x, 45) for x in range(24, 41)])
        l.px('3', [(20, 34), (21, 34), (22, 33), (36, 33), (37, 33)])
        pauldrons(l, 'big')
        l.px('A', [(5, 34), (6, 35), (58, 34), (57, 35)])
    return l


# ---------------------------------------------------------------------------
# Legs (pants) and boots
# ---------------------------------------------------------------------------
def legs(style):
    l = Layer()
    hips = [(24, 44), (40, 44), (40, 48), (24, 48)]
    if style in ('darkBreeches', 'trainingPants', 'crimsonCuisses', 'platedGreaves'):
        l.poly('P', hips).poly('P', LEG_L).poly('P', LEG_R)
        l.px('5', [(25, 48), (25, 49), (34, 48), (34, 49)])
        l.px('p', [(32, y) for y in range(46, 52)])
    if style == 'trainingPants':
        l.poly('P', [(20, 54), (31, 54), (31, 62), (19, 62)]).poly('P', [(34, 54), (45, 54), (45, 62), (34, 62)])
        l.px('5', [(22, 56), (36, 56)])
    elif style == 'crimsonCuisses':
        l.poly('R', [(23, 47), (31, 47), (30, 54), (23, 54)]).poly('R', [(33, 47), (41, 47), (42, 54), (34, 54)])
        l.px('0', [(24, 48), (25, 48), (34, 48), (35, 48)])
    elif style == 'platedGreaves':
        l.ell('T', [21, 50, 31, 58]).ell('T', [34, 50, 44, 58])  # knee cops
        l.px('3', [(24, 52), (25, 51), (37, 52), (38, 51)])
    elif style == 'monkWraps':
        l.poly('P', hips).poly('P', [(24, 46), (31, 46), (31, 52), (23, 52)]).poly('P', [(33, 46), (40, 46), (41, 52), (34, 52)])
        for y in (55, 58, 61):
            l.rect('L', [21, y, 30, y + 1]).rect('L', [35, y, 44, y + 1])
    elif style == 'scholarTunic':
        l.poly('P', [(23, 44), (41, 44), (45, 60), (19, 60)])
        l.px('p', [(32, y) for y in range(46, 60)])
        l.rect('A', [20, 58, 44, 59])
    return l


def boots(style):
    l = Layer()
    if style == 'cuffedMercenaryBoots':
        l.poly('L', FOOT_L).poly('L', FOOT_R)
        l.rect('L', [19, 61, 31, 63]).rect('L', [34, 61, 46, 63])
        l.px('l', [(x, 63) for x in range(20, 30)] + [(x, 63) for x in range(35, 45)])
        l.px('4', [(20, 64), (21, 64), (36, 64), (37, 64)])
    elif style == 'ironSabaton':
        l.poly('T', FOOT_L).poly('T', FOOT_R)
        l.px('t', [(x, 66) for x in range(17, 31)] + [(x, 66) for x in range(35, 48)])
        l.px('3', [(20, 62), (21, 62), (37, 62), (38, 62)])
    elif style == 'strappedSandals':
        l.rect('L', [16, 68, 31, 70]).rect('L', [34, 68, 48, 70])
        for y in (63, 66):
            l.rect('L', [19, y, 30, y]).rect('L', [35, y, 45, y])
    elif style == 'shadowBoots':
        l.poly('C', FOOT_L).poly('C', FOOT_R)
        l.poly('C', [(20, 56), (31, 56), (31, 61), (19, 61)]).poly('C', [(34, 56), (45, 56), (45, 61), (34, 61)])
        l.px('6', [(21, 58), (36, 58)])
    elif style == 'crimsonGreaves':
        l.poly('R', FOOT_L).poly('R', FOOT_R)
        l.poly('R', [(20, 55), (31, 55), (31, 61), (19, 61)]).poly('R', [(34, 55), (45, 55), (45, 61), (34, 61)])
        l.rect('A', [17, 67, 31, 67]).rect('A', [34, 67, 48, 67])
    elif style == 'gildedBoots':
        l.poly('L', FOOT_L).poly('L', FOOT_R)
        l.rect('A', [18, 60, 32, 62]).rect('A', [33, 60, 47, 62])
        l.px('A', [(17, 68), (18, 68), (46, 68), (47, 68)])
    return l


# ---------------------------------------------------------------------------
# Head: eyes, beard, hair
# ---------------------------------------------------------------------------
EL, ER = 27, 33  # left/right eye x (2 px wide each)
EY = 21


def eyes(style):
    l = Layer()
    if style == 'determined':
        l.px('W', [(EL, EY), (ER, EY)]).px('K', [(EL + 1, EY), (ER + 1, EY), (EL + 1, EY + 1), (ER + 1, EY + 1)])
        l.px('K', [(EL - 1, EY - 2), (EL, EY - 2), (EL + 1, EY - 1), (ER, EY - 1), (ER + 1, EY - 2), (ER + 2, EY - 2)])
    elif style == 'focused':
        l.px('K', [(EL, EY), (EL + 1, EY), (ER, EY), (ER + 1, EY)])
        l.px('E', [(EL + 1, EY + 1), (ER, EY + 1)])
        l.px('K', [(EL - 1, EY - 1), (EL, EY - 2), (EL + 1, EY - 2), (ER, EY - 2), (ER + 1, EY - 2), (ER + 2, EY - 1)])
    elif style == 'glowing':
        l.px('E', [(EL, EY), (EL + 1, EY), (ER, EY), (ER + 1, EY), (EL, EY + 1), (ER + 1, EY + 1)])
        l.px('W', [(EL + 1, EY), (ER, EY)])
        l.px('K', [(EL - 1, EY - 1), (EL, EY - 2), (ER + 1, EY - 2), (ER + 2, EY - 1)])
    elif style == 'serene':
        l.px('K', [(EL - 1, EY), (EL, EY + 1), (EL + 1, EY + 1), (EL + 2, EY), (ER - 1, EY), (ER, EY + 1), (ER + 1, EY + 1), (ER + 2, EY)])
        l.px('s', [(EL, EY - 2), (EL + 1, EY - 2), (ER, EY - 2), (ER + 1, EY - 2)])
    elif style == 'scarredOneEye':
        l.px('W', [(ER, EY)]).px('K', [(ER + 1, EY), (ER + 1, EY + 1), (ER, EY - 2), (ER + 1, EY - 2), (ER + 2, EY - 2)])
        l.px('K', [(EL - 1, EY), (EL, EY), (EL + 1, EY), (EL + 2, EY)])  # closed eye
        l.px('r', [(EL, EY - 3), (EL + 1, EY - 2), (EL + 1, EY - 1), (EL, EY + 1), (EL + 1, EY + 2), (EL + 2, EY + 3)])  # scar
    return l


def beard(style):
    l = Layer()
    if style == 'stubble':
        l.px('h', [(x, y) for y in range(27, 31) for x in range(25, 40) if (x + y) % 2 == 0 and not (29 <= x <= 34 and y == 28)])
    elif style == 'shortBeard':
        l.poly('H', [(24, 25), (26, 29), (30, 32), (34, 32), (38, 29), (40, 25), (40, 28), (36, 33), (28, 33), (24, 28)])
        l.px('H', [(30, 27), (31, 26), (32, 26), (33, 26), (34, 27)])  # moustache
        l.px('S', [(31, 28), (32, 28)])
    elif style == 'warlordBeard':
        l.poly('H', [(23, 24), (26, 30), (29, 38), (32, 41), (35, 38), (38, 30), (41, 24), (41, 30), (37, 36), (32, 42), (27, 36), (23, 30)])
        l.px('H', [(29, 27), (30, 26), (31, 26), (32, 26), (33, 26), (34, 26), (35, 27)])
        l.px('h', [(30, 33), (32, 36), (34, 33), (31, 38), (33, 38)])
        l.px('2', [(26, 28), (27, 30), (37, 29)])
        l.px('S', [(31, 28), (32, 28)])
    elif style == 'goatee':
        l.poly('H', [(29, 28), (35, 28), (34, 33), (32, 34), (30, 33)])
        l.px('H', [(29, 27), (30, 26), (34, 26), (35, 27)])
        l.px('S', [(31, 28), (32, 28), (33, 28)])
    return l


SPIKY = [(20, 19), (19, 14), (21, 12), (20, 9), (23, 9), (23, 6), (26, 7), (28, 4), (31, 6), (33, 4), (35, 7), (38, 5), (39, 9), (43, 9), (42, 13), (44, 16), (42, 20), (41, 23), (39, 18), (37, 20), (35, 16), (32, 19), (30, 15), (27, 19), (25, 16), (24, 22), (22, 25), (21, 21)]


def hair(style):
    l = Layer()
    if style in ('spikyBerserk', 'spikyWhiteStreak'):
        l.poly('H', SPIKY)
        l.px('2', [(26, 10), (27, 9), (31, 8), (32, 7), (37, 10), (38, 9), (23, 13)])
        l.px('h', [(28, 16), (33, 17), (38, 17)])
        if style == 'spikyWhiteStreak':
            l.only_where('W', [(x, y) for y in range(5, 20) for x in (29, 30) if y > 6] + [(31, 7), (31, 8)])
    elif style == 'shortCrop':
        l.poly('H', [(22, 20), (22, 13), (26, 9), (32, 8), (38, 9), (42, 13), (42, 20), (40, 16), (36, 14), (28, 14), (24, 16)])
        l.px('2', [(27, 10), (28, 10), (33, 9), (34, 9)])
    elif style == 'longFlowing':
        l.poly('H', [(21, 22), (21, 13), (26, 8), (33, 7), (39, 9), (43, 13), (43, 22), (40, 16), (32, 14), (24, 16)])
        l.poly('H', [(19, 18), (22, 15), (23, 24), (23, 37), (19, 35)])
        l.poly('H', [(45, 18), (42, 15), (41, 24), (41, 37), (45, 35)])
        l.px('2', [(25, 11), (26, 10), (31, 9), (32, 9), (21, 24), (22, 28)])
        l.px('h', [(42, 24), (42, 28), (22, 30)])
    elif style == 'topknot':
        l.poly('H', [(22, 20), (22, 14), (26, 10), (38, 10), (42, 14), (42, 20), (39, 16), (25, 16)])
        l.ell('H', [28, 2, 36, 10])
        l.rect('L', [29, 9, 35, 10])
        l.px('2', [(30, 4), (31, 3), (26, 12)])
    elif style == 'hooded':
        l.poly('C', [(18, 34), (18, 18), (22, 10), (32, 6), (42, 10), (46, 18), (46, 34), (42, 31), (42, 20), (38, 15), (26, 15), (22, 20), (22, 31)])
        l.px('6', [(22, 12), (23, 11), (26, 9), (20, 20), (20, 24)])
        l.px('c', [(43, 22), (43, 26), (40, 13)])
    elif style == 'ironHelm':
        l.poly('T', [(21, 25), (21, 15), (25, 10), (32, 8), (39, 10), (43, 15), (43, 25), (41, 31), (23, 31)])
        l.rect('K', [24, 20, 40, 22])   # visor slit
        l.px('E', [(28, 21), (35, 21)])
        l.px('t', [(32, y) for y in range(9, 20)] + [(x, 25) for x in range(24, 41)])
        l.px('3', [(25, 12), (26, 11), (27, 11), (23, 17), (23, 18)])
        l.poly('R', [(31, 3), (33, 3), (34, 9), (30, 9)])  # crest
    return l


# ---------------------------------------------------------------------------
# Back gear (behind everything)
# ---------------------------------------------------------------------------
TATTERED = [(17, 30), (47, 30), (51, 46), (52, 62), (49, 60), (47, 65), (43, 61), (40, 66), (36, 62), (32, 66), (28, 62), (24, 66), (20, 62), (16, 65), (13, 61), (12, 46)]


def back(style, drawn=False):
    l = Layer()
    if style == 'none':
        return l
    if style in ('dragonslayerCape', 'tatteredCloak') or drawn:
        l.poly('C', TATTERED)
        l.px('c', [(22, 45), (22, 52), (31, 48), (31, 58), (41, 46), (41, 55)])
    if drawn:
        return l
    if style == 'dragonslayerCape':
        l.poly('M', [(36, 25), (44, 18), (56, 54), (50, 60)])        # blade on back
        l.poly('M', [(39, 20), (47, 13), (51, 16), (43, 23)])          # crossguard
        l.poly('L', [(46, 14), (52, 7), (55, 9), (49, 16)])            # grip
        l.ell('M', [51, 3, 57, 9])                                     # pommel
        l.px('7', [(45, 22), (47, 27), (49, 33), (51, 39), (53, 45)])
    elif style == 'runicStaffCape':
        l.poly('C', TATTERED)
        l.line('L', [(14, 66), (48, 4)], 3)
        l.ell('E', [44, 0, 52, 8]).px('W', [(47, 3), (48, 3)])
    elif style == 'twinDaggersCloak':
        l.poly('C', [(17, 30), (47, 30), (49, 44), (40, 50), (32, 46), (24, 50), (15, 44)])
        for (x, y) in ((14, 36), (46, 36)):
            l.poly('L', [(x, y), (x + 4, y), (x + 4, y + 4), (x, y + 4)])
            l.poly('M', [(x + 1, y + 4), (x + 3, y + 4), (x + 3, y + 14), (x + 2, y + 16), (x + 1, y + 14)])
    elif style == 'paladinWingedMantle':
        l.poly('C', [(15, 30), (49, 30), (53, 50), (50, 64), (14, 64), (11, 50)])
        l.poly('M', [(12, 30), (2, 16), (5, 24), (1, 26), (6, 32), (2, 34), (9, 38)])    # wing L
        l.poly('M', [(52, 30), (62, 16), (59, 24), (63, 26), (58, 32), (62, 34), (55, 38)])  # wing R
        l.rect('A', [13, 62, 51, 63])
        l.px('7', [(4, 19), (5, 21), (59, 19), (58, 21)])
    return l


# ---------------------------------------------------------------------------
# Weapons held in the action pose (right fist at ~[54,24,62,32])
# ---------------------------------------------------------------------------
def weapon(kind):
    l = Layer()
    if kind == 'greatsword':
        l.poly('M', [(54, 22), (60, 19), (63, 0), (58, 0), (51, 17)])        # blade up
        l.line('7', [(53, 17), (59, 0)], 1)
        l.poly('A', [(51, 20), (62, 25), (61, 27), (50, 22)])                # crossguard
        l.poly('L', [(57, 25), (61, 27), (58, 34), (55, 32)])                # grip below the fist
    elif kind == 'staff':
        l.line('L', [(59, 2), (59, 66)], 3)
        l.ell('E', [55, 0, 63, 7]).px('W', [(58, 2), (59, 2)]).px('A', [(57, 7), (58, 8), (59, 8), (60, 8), (61, 7)])
    elif kind == 'daggers':
        l.poly('M', [(57, 19), (61, 19), (62, 4), (59, 2)])
        l.rect('A', [55, 19, 63, 20])
        l.poly('M', [(13, 57), (16, 57), (15, 67), (14, 68)])                # off-hand dagger
        l.rect('A', [11, 56, 18, 57])
    elif kind == 'bow':
        l.line('L', [(58, 0), (62, 10), (62, 40), (57, 54)], 2)
        l.line('W', [(57, 1), (56, 53)], 1)
        l.line('M', [(38, 23), (63, 23)], 1).px('A', [(38, 22), (38, 24), (39, 23)])
    elif kind == 'martial':
        l.ell('G', [52, 15, 63, 31])
        l.ell('S', [55, 19, 63, 27]).rect('L', [56, 25, 62, 28])
        l.px('9', [(53, 17), (62, 16), (52, 24), (63, 30)])
    elif kind == 'holyBlade':
        l.poly('M', [(57, 20), (61, 20), (62, 1), (59, 0), (56, 1)])
        l.line('7', [(58, 18), (58, 2)], 1)
        l.rect('A', [53, 19, 63, 21])
        l.px('G', [(54, 4), (62, 8), (53, 12), (63, 15)])
    elif kind == 'shield':
        l.poly('T', [(4, 34), (22, 34), (22, 52), (13, 62), (4, 52)])
        l.poly('A', [(11, 37), (15, 37), (15, 56), (11, 56)]).poly('A', [(6, 43), (20, 43), (20, 46), (6, 46)])
        l.px('3', [(6, 36), (7, 36), (5, 38)])
    return l


def aura():
    l = Layer()
    for x, y in [(6, 4), (58, 6), (3, 22), (61, 26), (4, 48), (60, 50), (10, 66), (54, 68)]:
        l.px('G', [(x, y), (x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]).px('9', [(x, y)])
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
POSES = ['idle', 'flex', 'action']


def catalog():
    c = {}
    for p in POSES:
        c[f'body.{p}'] = body(p)
        for t in TORSOS:
            c[f'torso.{t}.{p}'] = torso(t, p)
    for s in LEGS: c[f'legs.{s}'] = legs(s)
    for s in BOOTS: c[f'boots.{s}'] = boots(s)
    for s in EYES: c[f'eyes.{s}'] = eyes(s)
    for s in BEARDS: c[f'beard.{s}'] = beard(s)
    for s in HAIRS: c[f'hair.{s}'] = hair(s)
    for s in BACKS: c[f'back.{s}'] = back(s)
    c['back.drawnCloak'] = back('tatteredCloak', drawn=True)
    for s in WEAPONS: c[f'weapon.{s}'] = weapon(s)
    c['aura'] = aura()
    return c


# Digit tokens (forced highlights) are stored as symbols so that digits in the
# encoded rows always mean run-length counts.
DIGIT_ESCAPE = dict(zip('1234567890', '!@#$%^&*()'))


def rle(row):
    """Run-length encodes a row as 'count+char' pairs to keep the Dart file small."""
    row = ''.join(DIGIT_ESCAPE.get(c, c) for c in row)
    out, i = [], 0
    while i < len(row):
        j = i
        while j < len(row) and row[j] == row[i]:
            j += 1
        n = j - i
        out.append((str(n) if n > 1 else '') + row[i])
        i = j
    return ''.join(out)


def write_dart(cat):
    lines = [
        '// GENERATED by tool/art/paper_doll_gen.py — do not edit by hand.',
        '// Edit the generator and run: python3 tool/art/paper_doll_gen.py',
        '//',
        '// Each layer is 64x72; rows are run-length encoded ("12." = 12 transparent).',
        r'// Digit tokens are escaped as !@#$%^&*() (1..0) so digits always mean counts.',
        '',
        'const int paperDollWidth = %d;' % W,
        'const int paperDollHeight = %d;' % H,
        '',
        'const Map<String, List<String>> paperDollLayers = {',
    ]
    for key, layer in cat.items():
        rows = layer.rows()
        if all(set(r) == {'.'} for r in rows):
            lines.append(f"  '{key}': [],")
            continue
        lines.append(f"  '{key}': [")
        for r in rows:
            enc = rle(r).replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$')
            lines.append(f"    '{enc}',")
        lines.append('  ],')
    lines.append('};')
    OUT_DART.parent.mkdir(parents=True, exist_ok=True)
    OUT_DART.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    print('wrote', OUT_DART.relative_to(ROOT), len(cat), 'layers')


if __name__ == '__main__':
    cat = catalog()
    write_dart(cat)
    if '--preview' in sys.argv:
        from preview import render_gallery  # noqa: E402  (tool/art/preview.py)
        render_gallery(cat, sys.argv[sys.argv.index('--preview') + 1] if len(sys.argv) > sys.argv.index('--preview') + 1 else 'paper_doll_preview.png')
