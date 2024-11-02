Config = {    

    DevMode = true,

    -- TICK: This is the time (rate) it takes to excecute every check 
    -- For e.g: 2 food is drain per tick
    -- 1000 = 1 second; 20000 = 20 seconds; 3600 = 3,5 seconds
    -- **WARNING: ONLY TOUCH THIS VARIABLES IF YOU NEED, MAY HIGHLY AFFECT OPERATION**
    
    NeedsTick = 60000, -- Checks your needs over time
    DamageTick = 10000, -- time between damage if hunger / thirst is 0

    -- SAVE HEALTH & STAMINA TO DB
    saveStatus = true,
    healthMultiplier = 3, --based on the MAX HP you set in vorp core

    cinematicHide = true,

    -- VOICE Version
    voiceSystem = true,
    saltyChat = true,
    
    WhisperRange = 3.5,
    NormalRange = 8.0,
    ShoutRange = 15.0,
    TrailRange = 32.0,

    -- NOTIFICATIONS
    MSG = "You consumed ", -- Message to display when consumed 
    FoodNotify1 = "You hear your belly rumbling!", -- When your food is low it displays this notification
    WaterNotify1 = "You are thirsty!", -- When your water is low it displays this notification

    FoodNotify2 = "You should eat something!", -- When your food is low it displays this notification
    WaterNotify2 = "You should drink something!", -- When your water is low it displays this notification


    FoodNotification1 = 10, -- Determines when FoodNotify notifications displays
    FoodNotification2 = 5, -- Determines when FoodNotify notifications displays
    WaterNotification1 = 10, -- Determines when WaterNotify notifications displays
    WaterNotification2 = 5, -- Determines when WaterNotify notifications displays
    NotificationTime = 30000, -- timer between notifications
    
    -- INITIAL VALUES
    InitialHunger = 100, -- INITIAL FOOD -- MAX VALUE 100%
    InitialThirst = 100, -- INITIAL FOOD -- MAX VALUE 100%
    
    -- DRAINS PER TICK ("NeedsTick")
    FoodDrainIdle = 0.5, -- Food drop rate on stand by
    FoodDrainRunning = .03, -- Food drop rate while running
    FoodDrainWalking = .01, -- Food drop rate while walking
    WaterDrainIdle = 1, -- Water drop rate on stand by
    WaterDrainRunning = .05, -- Water drop rate while running
    WaterDrainWalking = .03, -- Water drop rate while walking
    
    -- HEALTH LOSS STRIPE
    HealthLoss = 30, -- Health you lose per tick
    hungerDamageTrigger = 0, -- Food stripe that determines when you start to lose health
    thirstDamageTrigger = 0, -- Water stripe that determines when you start to lose health
    
    -- TEMPERATURE DEBUFF STRIPE
    TemperatureSystem = false, -- Enables/disables Temperature System
    MinTemperature = -50, -- -20°C From this temperature below, you'll lose more food and water
    MaxTemperature = 80, -- 20°C From this temperature above, you'll lose more food and water
    TempNotify = "You are feeling very cold, you should cover yourself more!!",
    TempNotifyCold = "You're cold, you should cover yourself",
    TempNotifyFreeze = "You're freezing cover yourself up, otherwise you will die!",
    
    

    -- FOOD AND WATER DROP RATE FROM TEMPERATURE
    WaterHotLoss = 3, -- Water drop rate increment for higher temperatures
    FoodColdLoss = 3, -- Food drop rate increment for lower temperatures
    
    -- DRUNK SYSTEM -
    VomitEnabled = true, -- Enables/disables Vomit system
    DisableDrunkRun = true, -- Enables/disables running when drunk

    -- Additiction System-- TODO
    AddicitonSystem = false, --wip
    
    -- CLOTHES TEMPERATURE
    -- Temperature increment each clothes gives.
    HatTemp = 1, -- Hats
    ShirtTemp = 2, -- Shirts
    PantsTemp = 2, -- Pants
    BootsTemp = 2, -- Boots
    CoatTemp = 3, -- Coats
    ClosedCoatTemp = 4, -- Closed Coats
    GlovesTemp = 1, -- Gloves
    VestTemp = 1, -- Vest
    PonchoTemp = 5, -- Poncho
    
    AnimationTypes= {
        ['eat'] = {
            
            dict = "mech_inventory@eating@multi_bite@sphere_d8-2_sandwich",
            name = "quick_left_hand", 
            flag = 24,
            bone = "SKEL_L_Finger12",
            attachPoints = {0.02, 0.028, 0.001, 15.0, 175.0, 0.0},

            itemAnim = false,
            multiItem = false,
            item1Anim = nil,
            itemInteractionState = nil,
            prop1 = nil,
            item2Anim = nil,
            prop2 = nil,
            itemInteractionState = nil,
            propNameGxt = nil
            
            
        },
        ['drink'] = {
            dict = "amb_rest_drunk@world_human_drinking@male_a@idle_a",
            name = "idle_a", 
            flag = 24,
            bone = "SKEL_R_Finger12",
            attachPoints = {0.02, 0.028, 0.001, 15.0, 175.0, 0.0},

            itemAnim = false,
            multiItem = false,
            item1Anim = nil,
            itemInteractionState = nil,
            item1 = nil,
            item2Anim = nil,
            item2 = nil,
            propNameGxt = nil
        },
        ['drink_cup'] ={
            
            dict = nil,
            name = "DRINK_COFFEE_HOLD", 
            flag = nil,
            bone = nil,
            attachPoints = nil,

            itemAnim = true,
            multiItem = false,
            item1Anim = "p_mugCOFFEE01x_ph_r_hand",
            itemInteractionState = -1199896558,
            item1 = nil,
            item2Anim = nil,
            item2 = nil,
            itemInteractionState = nil,
            propNameGxt = nil

        },
        ['bowl'] ={
            
            dict = nil,
            name = "Stew_Fill", 
            flag = nil,
            bone = nil,
            attachPoints = nil,

            itemAnim = true,
            multiItem = true,
            item1Anim = "p_bowl04x_stew_ph_l_hand",
            item1 = 'p_bowl04x_stew',
            item2Anim = "p_spoon01x_ph_r_hand",
            item2 = 'p_spoon01x',
            itemInteractionState = -583731576,
            propNameGxt = 599184882
        },
        ['berry'] = {
            
            dict = "mech_pickup@plant@berries",
            name = "exit_eat", 
            flag = -1,
            bone = nil,
            attachPoints = {0.02, 0.028, 0.001, 15.0, 175.0, 0.0},

            itemAnim = false,
            multiItem = false,
            item1Anim = false,
            itemInteractionState = false,
            item1 = nil,
            item2Anim = false,
            item2 = nil,
            propId = false
        }
    }

    }



