# ![Redline Studios Banner](https://i.imgur.com/VFEXnGd.png)

## Redline Studios Discord

<https://dsc.gg/redlinestudios>

# rs-xmas
Simple Christmas Resource for QBCore
- Spawn Christmas tress
- Collect gifts from trees
- Random chance to get coal
- Trees are server synced by citizenids. You can only use each tree once every server restart
- `QBCore.Functions.AddItems()` is used for the two items, no need to add items to your core shared items when using this script.

Happy Holidays from the Redline Studios Team!

# Preview:
https://streamable.com/edguuq

# Installation:
- Add the images to your inventory images
- Set locations for spawning trees
- Setup gift items and amounts
- If `Config.NewCore = false` then add the items to your core shared items
```lua
['xmas_gift']   = {['name'] = 'xmas_gift',              ['label'] = 'Christmas Gift',               ['weight'] = 100,         ['type'] = 'item',      ['image'] = 'gift.png',    ['unique'] = false,      ['useable'] = true,     ['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'A nice Christmas Gift'},
['coal']        = {['name'] = 'coal',                   ['label'] = 'Coal',                			['weight'] = 100,         ['type'] = 'item',      ['image'] = 'coal.png',    ['unique'] = false,      ['useable'] = true,     ['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'Coal for all the naughty people!'},```
