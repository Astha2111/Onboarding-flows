# Shared Image Library

Local image repository for use across all projects.

## Structure

- `horizontal/` — 1920x1080 game hero thumbnails
- `vertical/` — 720x1080 cover thumbnails
- `hero/` — 1920x1080 hero/background/screenshot images
- `font/` — JioType font family (Light, LightItalic, Medium, MediumItalic, Bold, Black) + spec PDF
- `logos/` — JioGames service logos (SVG, black + white variants)
- `index.json` — generated index mapping game slug → image paths
- `build_index.sh` — regenerate `index.json` after adding/removing files
- `find.sh` — look up image paths by game name

## Usage

**Find images for a game:**
```bash
/Users/jeetesh.shah/Desktop/Claude/assets/find.sh "tomb raider"
/Users/jeetesh.shah/Desktop/Claude/assets/find.sh "tomb raider" --json
```

**From a project, reference by absolute path** (read `index.json` to look up):
```js
const assets = require('/Users/jeetesh.shah/Desktop/Claude/assets/index.json');
const game = assets.items.find(i => i.slug === 'tomb-raider');
// game.horizontal, game.vertical
```

**After adding new images** to `horizontal/` or `vertical/`:
```bash
/Users/jeetesh.shah/Desktop/Claude/assets/build_index.sh
```
