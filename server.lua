data = {}
QRCore = {}
QBRItems = {}

if Config.Framework == "redemrp" then
    TriggerEvent("redemrp_inventory:getData",function(call)
        data = call
    end)
elseif Config.Framework == "redemrp-reboot" then
    TriggerEvent("redemrp_inventory:getData",function(call)
        data = call
    end)
    RedEM = exports["redem_roleplay"]:RedEM()
elseif Config.Framework == "qbr2" then
    QRCore = exports['qr-core']:GetCoreObject()
elseif Config.Framework == "rsg" then
    local qc = "rsg-core"
    QRCore = exports[qc]:GetCoreObject()
end
--------------------------------------------------------------------------------------------------------------------------------------------
local TEXTS = Config.Texts
local TEXTURES = Config.Textures
--------------------------------------------------------------------------------------------------------------------------------------------
local function TableNum(tbl) 
    local c = 0
    for i,v in pairs(tbl) do 
        c = c + 1
    end
    return c
end
--------------------------------------------------------------------------------------------------------------------------------------------
if Config.Framework == "redemrp" then
    RegisterServerEvent("RegisterUsableItem:weapon_tommy_gun", function(source, info)
        local _source = source
        local meta = info.meta
        if not meta.damaged then
            local remove = data.getItem(_source, "weapon_tommy_gun") 
            remove.RemoveItem(1)
            meta = {}
            meta.barreltype = 1
            meta.damaged = 0
            meta.ammo = 0
            meta.inclip = 0 
            meta.clipsize = 1
            meta.id = math.random(1, 999999)
            local itemD = data.getItem(_source, "weapon_tommy_gun", meta)
            itemD.ItemMeta = meta
            itemD.AddItem(1)
        end
        TriggerClientEvent("ricx_thompson:add_thompson", _source, meta)
    end)
    RegisterServerEvent("RegisterUsableItem:tommy_gun_oil", function(source)
        local _source = source
        local tommy = data.getItem(_source, "weapon_tommy_gun")
        if tommy and tommy.ItemAmount == 1 then 
            if not tommy.ItemMeta.damaged then 
                local meta = {}
                meta.barreltype = 1
                meta.damaged = 0
                meta.ammo = 0
                meta.inclip = 0 
                meta.clipsize = 1
                meta.id = math.random(1, 999999)
                tommy.ChangeMeta(meta)
            else
                tommy.ItemMeta.damaged = tommy.ItemMeta.damaged - 1
                if tommy.ItemMeta.damaged < 0 then 
                    tommy.ItemMeta.damaged = 0
                end
                tommy.ChangeMeta(tommy.ItemMeta)
            end
            local itemD = data.getItem(_source, "tommy_gun_oil")
            itemD.RemoveItem(1)
        else
            TriggerClientEvent("Notification:left_tommygun", _source, TEXTS.TommyGun, TEXTS.NoTommy, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
        end
    end)
elseif Config.Framework == "redemrp-reboot" then
    RegisterServerEvent("RegisterUsableItem:weapon_tommy_gun", function(source, info)
        local _source = source
        local meta = info.meta
        if not meta.damaged then
            local remove = data.getItem(_source, "weapon_tommy_gun") 
            remove.RemoveItem(1)
            meta = {}
            meta.barreltype = 1
            meta.damaged = 0
            meta.ammo = 0
            meta.inclip = 0 
            meta.clipsize = 1
            meta.id = math.random(1, 999999)
            local itemD = data.getItem(_source, "weapon_tommy_gun", meta)
            itemD.ItemMeta = meta
            itemD.AddItem(1)
        end
        TriggerClientEvent("ricx_thompson:add_thompson", _source, meta)
    end)
    RegisterServerEvent("RegisterUsableItem:tommy_gun_oil", function(source)
        local _source = source
        local tommy = data.getItem(_source, "weapon_tommy_gun")
        local count = tommy.ItemAmount
        if tommy and count == 1 then 
            local tmet = tommy.ItemMeta
            if not tmet.damaged then 
                local meta = {}
                meta.barreltype = 1
                meta.damaged = 0
                meta.ammo = 0
                meta.inclip = 0 
                meta.clipsize = 1
                meta.id = math.random(1, 999999)
                tommy.ChangeMeta(meta)
            else
                tmet.damaged = tmet.damaged - 1
                if tmet.damaged < 0 then 
                    tmet.damaged = 0
                end
                tommy.ChangeMeta(tmet)
            end
            local itemD = data.getItem(_source, "tommy_gun_oil")
            itemD.RemoveItem(1)
        else
            TriggerClientEvent("Notification:left_tommygun", _source, TEXTS.TommyGun, TEXTS.NoTommy, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
        end
    end)
elseif Config.Framework == "qbr" then
    exports['qbr-core']:CreateUseableItem("weapon_tommy_gun", function(source, item)
        local _source = source
        local meta = item.info or nil
        if meta == "" then 
            meta = {}
        end
        local User = exports['qbr-core']:GetPlayer(_source)
        if TableNum(meta) == 0 then 
            User.Functions.RemoveItem('weapon_tommy_gun', 1)
            meta = {}
            meta.barreltype = 1
            meta.damaged = 0
            meta.ammo = 0
            meta.inclip = 0 
            meta.clipsize = 1
            meta.id = math.random(1, 999999)
            User.Functions.AddItem('weapon_tommy_gun', 1, nil, meta)
        end
        TriggerClientEvent("ricx_thompson:add_thompson", _source, meta)
    end)
    exports['qbr-core']:CreateUseableItem("tommy_gun_oil", function(source, item)
        local _source = source
        local User = exports['qbr-core']:GetPlayer(_source)
        local hasItem = User.Functions.GetItemByName("weapon_tommy_gun")
        if hasItem then 
            if not hasItem.info.damaged then 
                User.Functions.RemoveItem('weapon_tommy_gun', 1)
                local meta = {}
                meta.barreltype = 1
                meta.damaged = 0
                meta.ammo = 0
                meta.inclip = 0 
                meta.clipsize = 1
                meta.id = math.random(1, 999999)
                Wait(50)
                User.Functions.AddItem('weapon_tommy_gun', 1, nil, meta)
            else
                hasItem.info.damaged = hasItem.info.damaged - 1 
                if hasItem.info.damaged < 0 then 
                    hasItem.info.damaged = 0 
                end
                local meta = hasItem.info
                User.Functions.RemoveItem('weapon_tommy_gun', 1)
                Wait(50)
                User.Functions.AddItem('weapon_tommy_gun', 1, nil, meta)
            end
            User.Functions.RemoveItem('tommy_gun_oil', 1)
        else
            TriggerClientEvent("Notification:left_tommygun", _source, TEXTS.TommyGun, TEXTS.NoTommy, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
        end
    end)
elseif Config.Framework == "qbr2" or Config.Framework == "rsg" then

    QRCore.Functions.CreateUseableItem("weapon_tommy_gun", function(source, item)
        local _source = source
        local meta = item.info or nil
        if meta == "" then 
            meta = {}
        end
        local User = QRCore.Functions.GetPlayer(_source)
        if TableNum(meta) == 0 or not meta.damaged then 
            User.Functions.RemoveItem('weapon_tommy_gun', 1)
            meta = {}
            meta.barreltype = 1
            meta.damaged = 0
            meta.ammo = 0
            meta.inclip = 0 
            meta.clipsize = 1
            meta.id = math.random(1, 999999)
            User.Functions.AddItem('weapon_tommy_gun', 1, nil, meta)
        end
        TriggerClientEvent("ricx_thompson:add_thompson", _source, meta)
    end)
    QRCore.Functions.CreateUseableItem("tommy_gun_oil", function(source, item)
        local _source = source
        local User = QRCore.Functions.GetPlayer(_source)
        local hasItem = User.Functions.GetItemByName("weapon_tommy_gun")
        if hasItem then 
            if not hasItem.info.damaged then 
                User.Functions.RemoveItem('weapon_tommy_gun', 1)
                local meta = {}
                meta.barreltype = 1
                meta.damaged = 0
                meta.ammo = 0
                meta.inclip = 0 
                meta.clipsize = 1
                meta.id = math.random(1, 999999)
                Wait(50)
                User.Functions.AddItem('weapon_tommy_gun', 1, nil, meta)
            else
                hasItem.info.damaged = hasItem.info.damaged - 1 
                if hasItem.info.damaged < 0 then 
                    hasItem.info.damaged = 0 
                end
                local meta = hasItem.info
                User.Functions.RemoveItem('weapon_tommy_gun', 1)
                Wait(50)
                User.Functions.AddItem('weapon_tommy_gun', 1, nil, meta)
            end
            User.Functions.RemoveItem('tommy_gun_oil', 1)
        else
            TriggerClientEvent("Notification:left_tommygun", _source, TEXTS.TommyGun, TEXTS.NoTommy, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
        end
    end)
end 
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("ricx_thompson:removeammo", function()
    local _source = source
    if Config.Framework == "redemrp" then
        local itemD = data.getItem(_source, "tommy_gun_ammo")
        itemD.RemoveItem(1)
    elseif Config.Framework == "redemrp-reboot" then
        local itemD = data.getItem(_source, "tommy_gun_ammo")
        itemD.RemoveItem(1)
    elseif Config.Framework == "qbr" then
        local User = exports['qbr-core']:GetPlayer(_source)
        User.Functions.RemoveItem('tommy_gun_ammo', 1)
    elseif Config.Framework == "qbr2" or Config.Framework == "rsg" then
        local User = QRCore.Functions.GetPlayer(_source)
        User.Functions.RemoveItem('tommy_gun_ammo', 1)
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("ricx_thompson:getammo", function()
    local _source = source
    if Config.Framework == "redemrp" then
        local itemD = data.getItem(_source, "tommy_gun_ammo")
        if itemD and itemD.ItemAmount > 0 then 
            itemD.RemoveItem(1)
            TriggerClientEvent("ricx_thompson:add_ammo", _source, 1)
        else
            TriggerClientEvent("Notification:left_tommygun", _source, TEXTS.TommyGun, TEXTS.NoAmmo, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
        end
    elseif Config.Framework == "redemrp-reboot" then
        local itemD = data.getItem(_source, "tommy_gun_ammo")
        local count = itemD.ItemAmount
        if itemD and count > 0 then 
            itemD.RemoveItem(1)
            TriggerClientEvent("ricx_thompson:add_ammo", _source, 1)
        else
            TriggerClientEvent("Notification:left_tommygun", _source, TEXTS.TommyGun, TEXTS.NoAmmo, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
        end
    elseif Config.Framework == "qbr" then
        local User = exports['qbr-core']:GetPlayer(_source)
        local hasItem = User.Functions.GetItemByName("tommy_gun_ammo")
        if hasItem and hasItem.amount > 0 then 
            User.Functions.RemoveItem('tommy_gun_ammo', 1)
            TriggerClientEvent("ricx_thompson:add_ammo", _source, 1)
        else
            TriggerClientEvent("Notification:left_tommygun", _source, TEXTS.TommyGun, TEXTS.NoAmmo, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
        end
    elseif Config.Framework == "qbr2" or Config.Framework == "rsg" then
        local User = QRCore.Functions.GetPlayer(_source)
        local hasItem = User.Functions.GetItemByName("tommy_gun_ammo")
        if hasItem and hasItem.amount > 0 then 
            User.Functions.RemoveItem('tommy_gun_ammo', 1)
            TriggerClientEvent("ricx_thompson:add_ammo", _source, 1)
        else
            TriggerClientEvent("Notification:left_tommygun", _source, TEXTS.TommyGun, TEXTS.NoAmmo, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
        end
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("ricx_thompson:savedata", function(info)
    local _source = source
    meta = {
        damaged = info.damaged, 
        ammo = info.ammo, 
        inclip = info.inclip,
        id = info.id,
        clipsize = info.clipsize,
        barreltype = info.barreltype,
    }
    if Config.Framework == "redemrp" then
        local tommy = data.getItem(_source, "weapon_tommy_gun")
        tommy.ChangeMeta(meta)
    elseif Config.Framework == "redemrp-reboot" then
        local tommy = data.getItem(_source, "weapon_tommy_gun")
        tommy.ChangeMeta(meta)
    elseif Config.Framework == "qbr" then
        local User = exports['qbr-core']:GetPlayer(_source)
        User.Functions.RemoveItem('weapon_tommy_gun', 1)
        Wait(100)
        User.Functions.AddItem('weapon_tommy_gun', 1, nil, meta)
    elseif Config.Framework == "qbr2" or Config.Framework == "rsg" then
        local User = QRCore.Functions.GetPlayer(_source)
        User.Functions.RemoveItem('weapon_tommy_gun', 1)
        Wait(100)
        User.Functions.AddItem('weapon_tommy_gun', 1, nil, meta)
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("ricx_thompson:check_shop", function(id, id2)
    local _source = source
    local shop = Config.GunDealers[id]
    local go = true
    local User
    if shop.job ~= false then 
        local job = nil 
        if Config.Framework == "redemrp" then 
            TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
                job = user.getJob()
            end)
            Wait(200)
        elseif Config.Framework == "redemrp-reboot" then 
            local Player = RedEM.GetPlayer(_source)
            if Player then 
                job = Player.job
            end
        elseif Config.Framework == "qbr" then 
            User = exports['qbr-core']:GetPlayer(_source)
            job = User.PlayerData.job.name
        elseif Config.Framework == "qbr2" or Config.Framework == "rsg" then
            User = QRCore.Functions.GetPlayer(_source)
            job = User.PlayerData.job.name
        end
        go = false 
        for i,v in pairs(shop.job) do 
            if v == job then 
                go = true
            end
        end
    end
    if go then 
        if not id2 then
            TriggerClientEvent("ricx_thompson:gundealer", _source, id)
        else
            TriggerClientEvent("ricx_thompson:gundealer_upgrade", _source, id)
        end
    else
        TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.NoJob, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("ricx_thompson:buy_product", function(id, item)
    local _source = source
    local shop = Config.GunDealers[id]
    local go = true
    local money = 0
    local User
    if shop.job ~= false then 
        local job = nil 
        if Config.Framework == "redemrp" then 
            TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
                job = user.getJob()
                money = user.getMoney()
            end)
            Wait(200)
        elseif Config.Framework == "redemrp-reboot" then 
            local Player = RedEM.GetPlayer(_source)
            if Player then 
                job = Player.job
                money = Player.money
            end
        elseif Config.Framework == "qbr" then 
            User = exports['qbr-core']:GetPlayer(_source)
            money = User.PlayerData.money.cash
            job = User.PlayerData.job.name
        elseif Config.Framework == "qbr2" or Config.Framework == "rsg" then
            User = QRCore.Functions.GetPlayer(_source)
            money = User.PlayerData.money.cash
            job = User.PlayerData.job.name
        end
        go = false 
        for i,v in pairs(shop.job) do 
            if v == job then 
                go = true
            end
        end
    end
    if go then 
        local item_d = shop.items[item[1]]
        if item_d[1] == item[2][1] and item_d[2] == item[2][2] and item_d[3] == item[2][3] then 
            if money >= item_d[3] then
                if Config.Framework == "redemrp" then
                    local itemD = data.getItem(_source, item_d[1])
                    itemD.AddItem(1)
                    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
                        user.removeMoney(item_d[3])
                    end)
                elseif Config.Framework == "redemrp-reboot" then
                    local itemD = data.getItem(_source, item_d[1])
                    itemD.AddItem(1)
                    local Player = RedEM.GetPlayer(_source)
                    if Player then 
                        Player.RemoveMoney(item_d[3])
                    end
                elseif Config.Framework == "qbr" or Config.Framework == "qbr2" or Config.Framework == "rsg" then 
                    if item_d[1] == "weapon_tommy_gun" then 
                        local hasItem = User.Functions.GetItemByName(item_d[1])
                        if hasItem and hasItem.amount == 1 then 
                            return
                        else
                            User.Functions.AddItem(item_d[1], 1)
                            User.Functions.RemoveMoney("cash", item_d[3], "Gun Dealer Purchase")
                        end
                    else
                        User.Functions.AddItem(item_d[1], 1)
                        User.Functions.RemoveMoney("cash", item_d[3], "Gun Dealer Purchase")
                    end
                end
            else
                TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.NoMoney, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
            end
        else
            TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.CantBuy, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
        end
    else
        TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.NoJob, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("ricx_thompson:buy_upgrade", function(id, item, type1)
    local _source = source
    local shop = Config.GunDealers[id]
    local price = shop.upgrade_price
    if type1 then 
        price = item[2][3]
    end
    local go = true
    local money = 0
    local User
    if shop.job ~= false then 
        local job = nil 
        if Config.Framework == "redemrp" then 
            TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
                job = user.getJob()
                money = user.getMoney()
            end)
            Wait(200)
        elseif Config.Framework == "redemrp-reboot" then 
            local Player = RedEM.GetPlayer(_source)
            if Player then 
                job = Player.job 
                money = Player.money
            end
        elseif Config.Framework == "qbr" then 
            User = exports['qbr-core']:GetPlayer(_source)
            money = User.PlayerData.money.cash
            job = User.PlayerData.job.name
        elseif Config.Framework == "qbr2" or Config.Framework == "rsg" then
            User = QRCore.Functions.GetPlayer(_source)
            money = User.PlayerData.money.cash
            job = User.PlayerData.job.name
        end
        go = false 
        for i,v in pairs(shop.job) do 
            if v == job then 
                go = true
            end
        end
    end
    if go then 
        if money >= price then
            if Config.Framework == "redemrp" then
                local itemD = data.getItem(_source, "weapon_tommy_gun") 
                if itemD then
                    if not itemD.ItemMeta.damaged then
                        local meta = {}
                        meta.damaged = 0
                        meta.ammo = 0
                        meta.inclip = 0 
                        meta.clipsize = 1
                        meta.barreltype = 1
                        meta.id = math.random(1, 999999)
                        local tommy = data.getItem(_source, "weapon_tommy_gun")
                        tommy.ChangeMeta(meta)
                    end
                    if item == "clipsize" then 
                        if itemD.ItemMeta.clipsize ~= 3 then 
                            itemD.ItemMeta.clipsize = itemD.ItemMeta.clipsize + 1
                            local tommy = data.getItem(_source, "weapon_tommy_gun")
                            tommy.ChangeMeta(itemD.ItemMeta)
                            TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.UpgradeBought, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
                            TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
                                user.removeMoney(price)
                            end)
                        else
                            TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.ClipUpgraded, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
                        end
                    elseif item == "repair" then 
                        if itemD.ItemMeta.damaged ~= 0 then 
                            itemD.ItemMeta.damaged = 0
                            local tommy = data.getItem(_source, "weapon_tommy_gun")
                            tommy.ChangeMeta(itemD.ItemMeta)
                            TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.Repaired, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
                            TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
                                user.removeMoney(price)
                            end)
                        end
                    elseif type(item[1]) == "number" and type1 == "barrel" then 
                        itemD.ItemMeta.barreltype = item[1]
                        local tommy = data.getItem(_source, "weapon_tommy_gun")
                        tommy.ChangeMeta(itemD.ItemMeta)
                        TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
                            user.removeMoney(price)
                        end)
                        TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.UpgradeBought, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
                    end
                end
            elseif Config.Framework == "redemrp-reboot" then
                local Player = RedEM.GetPlayer(_source)
                local itemD = data.getItem(_source, "weapon_tommy_gun") 
                if itemD then
                    local tmet = itemD.ItemMeta
                    if not tmet.damaged then
                        local meta = {}
                        meta.damaged = 0
                        meta.ammo = 0
                        meta.inclip = 0 
                        meta.clipsize = 1
                        meta.barreltype = 1
                        meta.id = math.random(1, 999999)
                        local tommy = data.getItem(_source, "weapon_tommy_gun")
                        tommy.ChangeMeta(meta)
                    end
                    if item == "clipsize" then 
                        if tmet.clipsize ~= 3 then 
                            tmet.clipsize = tmet.clipsize + 1
                            local tommy = data.getItem(_source, "weapon_tommy_gun")
                            tommy.ChangeMeta(tmet)
                            TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.UpgradeBought, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
                            Player.RemoveMoney(price)
                        else
                            TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.ClipUpgraded, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
                        end
                    elseif item == "repair" then 
                        if tmet.damaged ~= 0 then 
                            tmet.damaged = 0
                            local tommy = data.getItem(_source, "weapon_tommy_gun")
                            tommy.ChangeMeta(tmet)
                            TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.Repaired, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
                            Player.RemoveMoney(price)
                        end
                    elseif type(item[1]) == "number" and type1 == "barrel" then 
                        tmet.barreltype = item[1]
                        local tommy = data.getItem(_source, "weapon_tommy_gun")
                        tommy.ChangeMeta(tmet)
                        Player.RemoveMoney(price)
                        TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.UpgradeBought, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
                    end
                end
            elseif Config.Framework == "qbr" or Config.Framework == "qbr2" or Config.Framework == "rsg" then 
                local hasItem = User.Functions.GetItemByName("weapon_tommy_gun")
                if hasItem then
                    if not hasItem.info.damaged then
                        local meta = {}
                        meta.damaged = 0
                        meta.ammo = 0
                        meta.inclip = 0 
                        meta.clipsize = 1
                        meta.barreltype = 1
                        meta.id = math.random(1, 999999)
                        User.Functions.RemoveItem('weapon_tommy_gun', 1)
                        Wait(100)
                        User.Functions.AddItem('weapon_tommy_gun', 1, nil, meta)
                    end
                    if item == "clipsize" then 
                        if hasItem.info.clipsize ~= 3 then 
                            hasItem.info.clipsize = hasItem.info.clipsize + 1
                            User.Functions.RemoveItem('weapon_tommy_gun', 1)
                            Wait(100)
                            User.Functions.AddItem('weapon_tommy_gun', 1, nil, hasItem.info)
                            TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.UpgradeBought, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
                            User.Functions.RemoveMoney("cash", price, "Tommy Gun Upgrade")
                        else
                            TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.ClipUpgraded, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
                        end
                    elseif item == "repair" then 
                        if hasItem.info.damaged ~= 0 then 
                            hasItem.info.damaged = 0
                            User.Functions.RemoveItem('weapon_tommy_gun', 1)
                            Wait(100)
                            User.Functions.AddItem('weapon_tommy_gun', 1, nil, hasItem.info)
                            TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.Repaired, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
                            User.Functions.RemoveMoney("cash", price, "Tommy Gun Upgrade")
                        end
                    elseif type(item[1]) == "number" and type1 == "barrel" then 
                        hasItem.info.barreltype = item[1]
                        User.Functions.RemoveItem('weapon_tommy_gun', 1)
                        Wait(100)
                        User.Functions.AddItem('weapon_tommy_gun', 1, nil, hasItem.info)
                        User.Functions.RemoveMoney("cash", price, "Tommy Gun Upgrade")
                        TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.UpgradeBought, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
                    end
                end
            end
        else
            TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.NoMoney, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
        end   
    else
        TriggerClientEvent("Notification:left_tommygun", _source, shop.name, TEXTS.NoJob, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("ricx_thompson:bullet_s", function(pc, bc, t)
    local _source = source
    TriggerClientEvent("ricx_thompson:bullet", -1, pc, bc, t)
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("ricx_thompson:reset_weapons", function()
    local _source = source
    --ADD YOUR OWN LOGIC HERE IF USING DIFFERENT THAN REDEMRP/QBR/QBR2/RSG
end)
