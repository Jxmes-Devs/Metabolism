# James Metabolism

A RedM resource that provides advanced metabolism and status tracking for your RedM server.

## Features
- Dynamic UI positioning system / Server-side position saving
- Character-specific metabolism tracking 
- Database integration with character data

## Dependencies
- VORP Core
- ghmattimysql / oxmysql
- If using voice option SaltyChat is required

## Installation / Usage
1. Copy `Metabolism` to your resources folder
2. Add `ensure Metabolism` to your server.cfg
3. Start your server

## Content
- Easy way to configure your consumables.
- Weather effect on metabolism.
- Effects and Gold Cores.
- Custom UI

## Usage

Add items into the items.lua file;
```
{
    name = 'example name',
    animation = 'eat',
    propName = 'example prop',
    hunger = 10,
    thirst = 0,
    stamina = 20,
    health = 10,
    goldInnerHealth = 0,
    goldOuterHealth = 0,
    goldInnerStamina = 0,
    goldOuterStamina = 0,
    mutliUse = 0,
    drunk = 0,
    specialEffect = false,
    temperature = 0, 
},
```

Add Animations into the config.lua;

```
['Eat'] = {    
            dict = nil,                                     Anim Dictionary
            name = "quick_left_hand",                       Anim Name
            flag = 24,                                      Anim Flag
            bone = "SKEL_L_Finger12",                       Bone for Prop
            attachPoints = {x,y,z,xrot,yrot,zrot},          Attachment point for Prop

            itemAnim = false,                               Is the animation Item locked? (hard locked like coffee or beer)
            multiItem = false,                              If true above & needs more than 1 item
            itemInteractionState = nil,                     Both of the following links will help identify both interactionState & propNameGXT https://www.rdr2mods.com/wiki/pages/list-of-rdr2-scenarios/ https://raw.githubusercontent.com/Cephy314/RDR3-Scripts/master/script_mp_rel/_hashes.csv
            propNameGxt = nil                               
            item1 = nil,                                    prop name 1
            item1Anim = nil,                                prop anim 1
            item2 = nil,                                    prop name 2
            item2Anim = nil,                                prop anim 2

},
``` 

Usage from another script:
```
 TriggerServerEvent("James_meta:setStatus",functionhunger, thirst, saveHealth, healthInner, healthOuter, staminaInner, staminaOuter)
```
- Setting saveHealth to false will disable the health / stamina saving (on both items & general usage)


