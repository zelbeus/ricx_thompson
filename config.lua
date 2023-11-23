Config = {}

Config.Framework = "rsg" -- "redemrp" or "qbr" or "qbr2" or "redemrp-reboot" or "rsg"

Config.Prompts = {
    Prompt1 = 0x05CA7C52,
    OpenShop = 0x05CA7C52,
    Upgrades = 0xD7DE6B1E,
}

Config.DisableControls = {--make sure to disable any control which can cause bug during handling the gun
    0x85D24405, 0x85D24405, 0xB238FE0B, 0xAC4BD4F1, 0x1C826362, 0x938D4071, 0x4FD1C57B, 0xE2B557A3,--TAB
    0xCEFD9220,--E
    0x4CC0E2FE,--B
    0xE30CD707,--R
}

Config.Texts = {
    Prompt1 = "Put Away",
    OpenShop = "Open Shop",
    Upgrades = "Upgrade",
    --TEXTS
    TommyGun = "Tommy Gun",
    NoAmmo = "You dont have ammo in pocket!",
    AlreadyEquipped = "You have it equipped!",
    BuyItem = "Buy Item",
    Options = "Options",
    NoJob = "You dont have the required job!",
    CantBuy = "You cant buy it now!",
    NoMoney = "You dont have enough money!",
    ClipUpgrade = "Clip Upgrade",
    UpgradesDis = "Upgrades",
    Repair = "Repair",
    ClipUpgraded = "Clip is upgraded fully!",
    UpgradeBought = "You have purchased an upgrade!",
    Repaired = "Gun is repaired!",
    NoTommy = "You dont have Thompson Gun!",
    AmmoD = "Ammo:",
    PocketD = "In Pocket",
    ReloadD = "Reload [R]",
    ConditionD = "Condition:",
    Barrels = "Barrels",
    SelectBarrel = "Select a Barrel Type",
    ChangeBarrel = "Change Barrel type for weapon",
    
}

Config.BarrelTypes = {
    [1] = {`weapon_revolver_cattleman`, "Type Base", 300},
    [2] = {`weapon_revolver_doubleaction`, "Type 1", 1400},
    [3] = {`weapon_revolver_schofield`, "Type 2", 2000},
    [4] = {`weapon_revolver_navy`, "Type 3", 2000},
    [5] = {`weapon_pistol_mauser`, "Type 4", 2500},
    [6] = {`weapon_pistol_semiauto`, "Type 5", 2500},
    [7] = {`weapon_pistol_volcanic`, "Type 6", 2500},
    [8] = {`weapon_pistol_m1899`, "Type 7", 3000},
    [9] = {`weapon_repeater_evans`, "Type 8", 4000},
    [10] = {`weapon_repeater_henry`, "Type 9", 4000},
    [11] = {`weapon_repeater_winchester`, "Type 10", 4000},
    [12] = {`weapon_repeater_carbine`, "Type 11", 4000},
    [13] = {`weapon_rifle_springfield`, "Type 12", 5000},
    [14] = {`weapon_rifle_boltaction`, "Type 13", 5000},
    [15] = {`weapon_rifle_varmint`, "Type 14", 4000},
    [16] = {`weapon_shotgun_sawedoff`, "Type 15", 6000},
    [17] = {`weapon_shotgun_pump`, "Type 16", 6000},
    [18] = {`weapon_shotgun_repeating`, "Type 17", 6000},
    [19] = {`weapon_shotgun_semiauto`, "Type 18", 6000},
    [20] = {`weapon_shotgun_doublebarrel`, "Type 19", 6000},
    [21] = {`weapon_sniperrifle_carcano`, "Type 20", 6000},
    [22] = {`weapon_sniperrifle_rollingblock`, "Type 21", 6000},
}

Config.Textures = {
    cross = {"scoretimer_textures", "scoretimer_generic_cross"},
    locked = {"menu_textures","stamp_locked_rank"},
    tick = {"scoretimer_textures","scoretimer_generic_tick"},
    money = {"inventory_items", "money_moneystack"},
    alert = {"menu_textures", "menu_icon_alert"},
}

Config.GunDealers = {
    [1] = {
        name = "Shady Guns",
        blip = {enable = true, sprite = -995686252},
        coords = vector3(2780.344, -1151.322, 48.375),
        job = {"police",},
        upgrade_price = 500,
        items = {
            {"weapon_tommy_gun", "Thompson Gun", 2000},
            {"tommy_gun_ammo", "Thompson Ammo", 100},
            {"tommy_gun_oil", "Thompson Gun Oil", 250},
        }
    },
}

--[[
    --REDEM:RP INVENTORY 2.0 ITEM
    ["weapon_tommy_gun"] = { label = "Thompson Gun", description = "Deadly Weapon", weight = 1.3, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 1, imgsrc = "items/weapon_tommy_gun.png", type = "item_standard",},
    ["tommy_gun_ammo"] = { label = "Thompson Gun Ammo", description = "Ammo", weight = 0.1, canBeDropped = true, canBeUsed = false, requireLvl = 0, limit = 25, imgsrc = "items/tommy_gun_ammo.png", type = "item_standard",},
    ["tommy_gun_oil"] = { label = "Thompson Gun Oil", description = "Oil for Thompson Gun", weight = 0.1, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 50, imgsrc = "items/tommy_gun_oil.png", type = "item_standard",},

    --QBR:
    ['weapon_tommy_gun'] = {['name'] = 'weapon_tommy_gun', ['label'] = 'Tommy Gun', ['weight'] = 1, ['type'] = 'item', ['image'] = 'items/weapon_tommy_gun.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'A gun'},
    ['tommy_gun_ammo'] = {['name'] = 'tommy_gun_ammo', ['label'] = 'Tommy Gun Ammo', ['weight'] = 1, ['type'] = 'item', ['image'] = 'items/tommy_gun_ammo.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Ammo type'},
    ['tommy_gun_oil'] = {['name'] = 'tommy_gun_oil', ['label'] = 'Tommy Gun Oil', ['weight'] = 1, ['type'] = 'item', ['image'] = 'items/tommy_gun_oil.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Ammo type'},
]]
