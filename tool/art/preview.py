"""Preview renderer for paper-doll layers (mirrors paper_doll_shader.dart).

Keep the shading rules here identical to the Dart shader so previews match the app.
"""
from PIL import Image, ImageDraw

REGIONS = 'SHTLPCMAGR'
FORCED_SHADOW = REGIONS.lower()
FORCED_HIGHLIGHT = '1234567890'
OUTLINE = (15, 15, 18)


def material(t):
    if t in REGIONS or t in 'KWE':
        return t
    if t in FORCED_SHADOW:
        return t.upper()
    if t in FORCED_HIGHLIGHT:
        return REGIONS[FORCED_HIGHLIGHT.index(t)]
    return None


def darken(c, f):
    return tuple(int(v * f) for v in c)


def shade(composed, ramps, white=(242, 244, 248), iris=(35, 29, 32)):
    """composed: (token rows, layer owners). ramps: material -> (hi, base, shadow)."""
    grid, owner = composed
    h, w = len(grid), len(grid[0])

    def tok(x, y):
        return grid[y][x] if 0 <= x < w and 0 <= y < h else '.'

    def mat(x, y):
        return material(tok(x, y))

    out = [[None] * w for _ in range(h)]
    for y in range(h):
        for x in range(w):
            t = tok(x, y)
            if t == '.':
                continue
            m = material(t)
            if t == 'K':
                out[y][x] = OUTLINE; continue
            if t == 'W':
                out[y][x] = white; continue
            if t == 'E':
                out[y][x] = iris; continue
            hi, base, sh = ramps[m]
            deep = darken(sh, 0.62)
            # Silhouette outline.
            if any(tok(x + dx, y + dy) == '.' for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                out[y][x] = OUTLINE; continue
            if t in FORCED_SHADOW:
                out[y][x] = sh; continue
            if t in FORCED_HIGHLIGHT:
                out[y][x] = hi; continue
            # Inner border: a different region to the right/bottom.
            nb = [(x + 1, y), (x, y + 1)]
            if any(tok(*p) in REGIONS and (mat(*p) != m or owner[p[1]][p[0]] != owner[y][x])
                   for p in nb if 0 <= p[0] < w and 0 <= p[1] < h):
                out[y][x] = deep; continue
            tl = mat(x - 1, y) != m or mat(x, y - 1) != m
            br = mat(x + 1, y) != m or mat(x, y + 1) != m
            c = base
            if tl and not br:
                c = hi
            elif br:
                c = sh
            out[y][x] = c
    return out


def compose(cat, keys):
    """Returns (token grid, layer-index grid)."""
    from paper_doll_gen import W, H
    grid = [['.'] * W for _ in range(H)]
    owner = [[-1] * W for _ in range(H)]
    for i, k in enumerate(keys):
        for y, row in enumerate(cat[k].rows()):
            for x, ch in enumerate(row):
                if ch != '.':
                    grid[y][x] = ch
                    owner[y][x] = i
    return [''.join(r) for r in grid], owner


def keys_for(a, pose='idle', weapon=None, aura=False):
    body_pose = 'action' if weapon else pose
    ks = ['back.drawnCloak' if weapon and a['back'] != 'none' else f"back.{a['back']}",
          f'body.{body_pose}', f"legs.{a['legs']}", f"boots.{a['boots']}",
          f"torso.{a['torso']}.{body_pose}", f"eyes.{a['eyes']}", f"beard.{a['beard']}",
          f"hair.{a['hair']}"]
    if weapon:
        ks.append(f'weapon.{weapon}')
    if aura:
        ks.append('aura')
    return ks


SKIN = {'fair': ((0xF2, 0xC2, 0x99), (0xD9, 0x9E, 0x72), (0xA4, 0x68, 0x40)),
        'warm': ((238, 190, 146), (206, 142, 96), (158, 92, 60)),
        'bronze': ((0xC9, 0x8B, 0x5E), (0x9A, 0x62, 0x3D), (0x6B, 0x3F, 0x26))}
HAIR = {'raven': ((92, 90, 100), (52, 52, 60), (32, 34, 42)),
        'silver': ((240, 240, 246), (190, 192, 204), (130, 132, 148)),
        'ember': ((220, 110, 70), (170, 70, 40), (110, 40, 24))}
TINTS = {
    'iron': dict(T=((0x9C, 0x9A, 0xA9), (0x69, 0x67, 0x78), (0x43, 0x41, 0x4F)),
                 L=((0xB8, 0x6B, 0x35), (0x8C, 0x4A, 0x20), (0x59, 0x2B, 0x0F)),
                 P=((0x47, 0x46, 0x54), (0x31, 0x30, 0x3B), (0x1F, 0x1E, 0x26)),
                 C=((0x66, 0x44, 0x36), (0x4A, 0x30, 0x25), (0x2E, 0x1D, 0x16)), A=(0xD9, 0x9B, 0x26)),
    'crimson': dict(T=((176, 70, 70), (130, 40, 44), (86, 24, 30)),
                    L=((90, 80, 86), (60, 52, 58), (38, 32, 38)),
                    P=((70, 66, 74), (46, 44, 52), (30, 28, 36)),
                    C=((120, 40, 44), (84, 26, 30), (52, 16, 20)), A=(0xE0, 0xA9, 0x6D)),
    'arcane': dict(T=((96, 120, 190), (60, 80, 150), (38, 50, 100)),
                   L=((150, 120, 90), (110, 86, 60), (76, 58, 40)),
                   P=((60, 60, 90), (40, 40, 66), (26, 26, 44)),
                   C=((70, 60, 130), (48, 40, 96), (30, 24, 64)), A=(0xE5, 0xC0, 0x5A)),
}


def ramps_for(skin, hair, tint, aura=(0xE0, 0xA9, 0x6D)):
    t = TINTS[tint]
    a = t['A']
    return {'S': SKIN[skin], 'H': HAIR[hair], 'T': t['T'], 'L': t['L'], 'P': t['P'], 'C': t['C'],
            'M': ((176, 192, 190), (92, 100, 112), (60, 62, 74)),
            'A': (tuple(min(255, int(v * 1.25)) for v in a), a, darken(a, 0.65)),
            'G': (tuple(min(255, int(v * 1.3)) for v in aura), aura, darken(aura, 0.6)),
            'R': ((176, 56, 58), (130, 36, 40), (90, 24, 30))}


PRESETS = [
    ('Espadachim', dict(back='dragonslayerCape', legs='darkBreeches', boots='cuffedMercenaryBoots', torso='mercenaryArmor', eyes='determined', beard='none', hair='spikyBerserk'), 'warm', 'raven', 'iron'),
    ('Barbaro', dict(back='tatteredCloak', legs='monkWraps', boots='strappedSandals', torso='bareChestWraps', eyes='scarredOneEye', beard='warlordBeard', hair='longFlowing'), 'bronze', 'ember', 'iron'),
    ('Paladino', dict(back='paladinWingedMantle', legs='platedGreaves', boots='gildedBoots', torso='royalPlate', eyes='focused', beard='shortBeard', hair='shortCrop'), 'fair', 'silver', 'crimson'),
    ('Mago', dict(back='runicStaffCape', legs='scholarTunic', boots='shadowBoots', torso='arcaneRobes', eyes='glowing', beard='goatee', hair='hooded'), 'fair', 'silver', 'arcane'),
    ('Ladino', dict(back='twinDaggersCloak', legs='trainingPants', boots='shadowBoots', torso='crimsonBrigandine', eyes='focused', beard='stubble', hair='topknot'), 'warm', 'raven', 'crimson'),
    ('Cavaleiro', dict(back='none', legs='crimsonCuisses', boots='ironSabaton', torso='trainingTunic', eyes='serene', beard='none', hair='ironHelm'), 'warm', 'raven', 'iron'),
]


def to_image(px, scale):
    h, w = len(px), len(px[0])
    im = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    for y in range(h):
        for x in range(w):
            if px[y][x]:
                im.putpixel((x, y), px[y][x] + (255,))
    return im.resize((w * scale, h * scale), Image.NEAREST)


def render_gallery(cat, path, scale=5):
    rows = []
    for name, a, skin, hair, tint in PRESETS:
        r = ramps_for(skin, hair, tint)
        row = [to_image(shade(compose(cat, keys_for(a, 'idle')), r), scale),
               to_image(shade(compose(cat, keys_for(a, 'flex')), r), scale)]
        for wpn in ('greatsword', 'staff', 'shield'):
            row.append(to_image(shade(compose(cat, keys_for(a, weapon=wpn, aura=wpn == 'staff')), r), scale))
        rows.append((name, row))
    cw, ch = 64 * scale, 72 * scale
    sheet = Image.new('RGB', (len(rows[0][1]) * (cw + 6) + 6, len(rows) * (ch + 6) + 6), (60, 82, 92))
    d = ImageDraw.Draw(sheet)
    for i, (name, row) in enumerate(rows):
        for j, im in enumerate(row):
            sheet.paste(im, (6 + j * (cw + 6), 6 + i * (ch + 6)), im)
        d.text((10, 8 + i * (ch + 6)), name, fill=(230, 230, 230))
    sheet.save(path)
    print('preview', path)
