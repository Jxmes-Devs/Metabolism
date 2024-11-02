
    
    -- SOME PROPS
    --
    -- p_bottlejd01x = Whyskey bottle
    -- p_bottlebeer01a = Beer bottle
    -- p_bottlewine01x = Wine bottle
    -- You can find more props in http://rdr2.mooshe.tv/
    
    
    -- SOME EFFECTS
    -- PlayerDrunk01
    -- PlayerDrunkAberdeen
    -- PlayerDrugsPoisonWell
    -- You can find more effects in https://github.com/femga/rdr3_discoveries/blob/master/graphics/animpostfx/animpostfx.lua

Consumables = {

    Items = {  
        Food = { 
            {
                name = 'anise_candy',
                animation = 'eat',
                propName = 's_candybag01x_red',
                hunger = 10,
                thirst = 0,
                stamina = 20,
                health = 10,
                goldInnerHealth = 0,
                goldOuterHealth = 0,
                goldInnerStamina = 1000,
                goldOuterStamina = 1000,
                mutliUse = 0,
                drunk = 1.0,
                specialEffect = false,
                effectDuration = 30000,
                temperature = 0, 
            },
        },

        Drinks = {
            {
                name = 'ale',
                animation = 'drink',
                propName = 's_drinkshootmg04x',
                hunger = 0,
                thirst = 15,
                stamina = 0,
                health = 0,
                goldInnerHealth = 0,
                goldOuterHealth = 0,
                goldInnerStamina = 0,
                goldOuterStamina = 0,
                mutliUse = 0,
                drunk = 0,
                specialEffect = false,
                effectDuration = 0,
                temperature = 0, 
            },

        },  	
    }
}