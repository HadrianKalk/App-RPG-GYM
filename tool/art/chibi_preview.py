"""PNG gallery for the chibi paper-doll (same layer order as HeroPaperDoll.compose).

Colours: expects `old_sprites.json` next to the output PNG, a dump of
`HeroPaperDoll.buildPalette` per preset ({"<preset>.idle": {"palette": {token: argb}}}).
Create it with a throwaway flutter test that json-encodes the palettes.
"""
import json
from pathlib import Path
from PIL import Image, ImageDraw

PRESETS = {
    'blackSwordsman': dict(back='dragonslayerCape', legs='darkBreeches', boots='cuffedMercenaryBoots', torso='mercenaryArmor', eyes='scarredOneEye', beard='none', hair='spikyBerserk'),
    'ironWarrior': dict(back='tatteredCloak', legs='platedGreaves', boots='ironSabaton', torso='royalPlate', eyes='determined', beard='shortBeard', hair='shortCrop'),
    'ashenBarbarian': dict(back='dragonslayerCape', legs='darkBreeches', boots='cuffedMercenaryBoots', torso='bareChestWraps', eyes='determined', beard='warlordBeard', hair='longFlowing'),
    'shadowRogue': dict(back='twinDaggersCloak', legs='darkBreeches', boots='shadowBoots', torso='crimsonBrigandine', eyes='focused', beard='none', hair='hooded'),
    'arcaneScholar': dict(back='runicStaffCape', legs='scholarTunic', boots='gildedBoots', torso='arcaneRobes', eyes='glowing', beard='goatee', hair='spikyWhiteStreak'),
    'crimsonPaladin': dict(back='paladinWingedMantle', legs='platedGreaves', boots='gildedBoots', torso='royalPlate', eyes='determined', beard='none', hair='ironHelm'),
    'sereneMonk': dict(back='none', legs='monkWraps', boots='strappedSandals', torso='trainingTunic', eyes='serene', beard='stubble', hair='topknot'),
}
WEAPON_FOR_POSE = {'attackGreatsword': 'greatsword', 'attackStaff': 'staff', 'guard': 'shield', 'attackBow': 'bow'}


def keys_for(a, pose):
    body = 'flex' if pose == 'flex' else 'idle'
    weapon = WEAPON_FOR_POSE.get(pose)
    back = a['back']
    ks = ['back.drawnCloak' if weapon and back != 'none' else f'back.{back}', f'body.{body}',
          f"legs.{a['legs']}", f"boots.{a['boots']}", f"torso.{a['torso']}.{body}",
          'backFront.tatteredCloak' if weapon and back != 'none' else f'backFront.{back}',
          f"eyes.{a['eyes']}", f"beard.{a['beard']}", f"hair.{a['hair']}"]
    if weapon:
        ks.append(f'weapon.{weapon}')
    return ks


def compose(cat, keys):
    g = [['.'] * 28 for _ in range(36)]
    for k in keys:
        for y, row in enumerate(cat[k].rows()):
            for x, ch in enumerate(row):
                if ch != '.':
                    g[y][x] = ch
    return g


def render(g, palette, s):
    im = Image.new('RGBA', (28, 36), (0, 0, 0, 0))
    for y, row in enumerate(g):
        for x, ch in enumerate(row):
            if ch in palette:
                v = palette[ch]
                im.putpixel((x, y), ((v >> 16) & 255, (v >> 8) & 255, v & 255, 255))
    return im.resize((28 * s, 36 * s), Image.NEAREST)


def render_gallery(cat, path, palettes='old_sprites.json', s=8):
    pal = json.load(open(Path(path).parent / palettes))
    poses = ['idle', 'flex', 'attackGreatsword', 'attackStaff', 'guard', 'attackBow']
    cw, ch = 28 * s + 8, 36 * s + 8
    sheet = Image.new('RGB', (len(poses) * cw + 8, len(PRESETS) * ch + 8), (73, 121, 125))
    d = ImageDraw.Draw(sheet)
    for i, (name, a) in enumerate(PRESETS.items()):
        palette = pal[f'{name}.idle']['palette']
        for j, pose in enumerate(poses):
            im = render(compose(cat, keys_for(a, pose)), palette, s)
            sheet.paste(im, (8 + j * cw, 8 + i * ch), im)
        d.text((10, 10 + i * ch), name, fill=(240, 240, 240))
    sheet.save(path)
    print('preview', path)
