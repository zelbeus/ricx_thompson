----------------------------REDEMRP_MENU----------------------------
MenuData = {}
TriggerEvent("redemrp_menu_base:getData",function(call)
    MenuData = call
end)
----------------------------END REDEMRP_MENU----------------------------
local TEXTS = Config.Texts
local TEXTURES = Config.Textures
local menuOpen = false 

local pcoords = nil 
local isdead = nil

local BlipEntities = {}

local PromptKey 
local PromptGroup = GetRandomIntInRange(0, 0xffffff)

local OpenShop
local ShopUpgrade
local ShopPrompts = GetRandomIntInRange(0, 0xffffff)

local prompts = {}

local thompson = nil
local thompsoninfo = nil

local removing = false

function IsThompson()
    return thompson
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function TableNum(tbl) 
    local c = 0
    for i,v in pairs(tbl) do 
        c = c + 1
    end
    return c
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function PrepareAnim(dict)
	if not HasAnimDictLoaded(dict) then 
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do 
			Citizen.Wait(1)
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function LoadModel(model)
	if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(1)
        end
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function NilDelete(ent)
    DeleteEntity(ent)
    SetEntityAsNoLongerNeeded(ent)
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function RayCastGamePlayCamera(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))
	return b, c, e
end

local function ReloadTommyGun()
    local clip = 25 * thompsoninfo.clipsize
    if thompsoninfo.inclip < clip and thompsoninfo.ammo > 0 then 
        local missing = clip - thompsoninfo.inclip
        local anim = {"mech_weapons_longarms@base@weapon@winchester_str", "reload_end"}
        PrepareAnim(anim[1])
        TaskPlayAnim(PlayerPedId(), anim[1], anim[2], 8.0, -8.0, 1000, 31, 0, true, 0, false, 0, false)
        if thompsoninfo.ammo >= missing then
            thompsoninfo.inclip = thompsoninfo.inclip + missing
            thompsoninfo.ammo = thompsoninfo.ammo - missing
        else
            thompsoninfo.inclip = thompsoninfo.inclip + thompsoninfo.ammo
            thompsoninfo.ammo = 0
        end
        Wait(1000)

    end
end

local function ResetTommyGun()
    removing = true 
    TriggerServerEvent("ricx_thompson:savedata", thompsoninfo)
    if thompson then
        DeleteEntity(thompson)
        if thompsoninfo.barrel then 
            DeleteEntity(thompsoninfo.barrel)
        end
        if thompsoninfo.clip then 
            DeleteEntity(thompsoninfo.clip)
        end
    end
    thompson = nil
    thompsoninfo = nil
    removing = false
    ClearPedTasksImmediately(PlayerPedId())
    if Config.Framework == "redemrp" then
        TriggerEvent("redemrp_inventory:reloadWeapons")
    elseif Config.Framework == "qbr" or Config.Framework == "qbr2" or Config.Framework == "rsg" then
        Citizen.InvokeNative(0x4899CB088EDF59B8, PlayerPedId(), `weapon_shotgun_pump`, 1, 1)
    else
        TriggerServerEvent("ricx_thompson:reset_weapons")
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function MakePrompt(text, prompt, group, enabled, visibled)
    local a
    local str = text
    local enable = 1 
    local visible = 1
    if visibled ~= nil then 
        visible = 0
    end
    if enabled ~= nil then 
        enable = 0
    end
    a = PromptRegisterBegin()
    PromptSetControlAction(a, prompt)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(a, str)
    PromptSetEnabled(a, enable)
    PromptSetVisible(a, visible)
	PromptSetStandardMode(a, 1)
	PromptSetGroup(a, group)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C,a,true)
	PromptRegisterEnd(a)
    prompts[a] = a
    return a
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function LoadPrompts()
    PromptKey = MakePrompt(TEXTS.Prompt1, Config.Prompts.Prompt1, PromptGroup)
    OpenShop = MakePrompt(TEXTS.OpenShop, Config.Prompts.OpenShop, ShopPrompts)
    ShopUpgrade = MakePrompt(TEXTS.Upgrades, Config.Prompts.Upgrades, ShopPrompts)
end

local function GetPedCurrentHeldWeapon(ped)
    return Citizen.InvokeNative(0x8425C5F057012DAB, ped)
end
--------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    for i, v in pairs(Config.GunDealers) do
        if v.blip.enable == true then
            local sprite = v.blip.sprite
            BlipEntities[i] = N_0x554d9d53f696d002(1664425300, v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(BlipEntities[i], sprite, 1)
            Citizen.InvokeNative(0x9CB1A1623062F402, BlipEntities[i], v.name)
        end
    end  
    LoadPrompts()
    while true do 
        Citizen.Wait(500)
        local ped = PlayerPedId()
        pcoords = GetEntityCoords(ped)
        isdead = IsEntityDead(ped)
        if thompson then 
            if IsPedSwimming(ped) or IsPedFalling(ped) or isdead == 1 then 
                ResetTommyGun()
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        local t = 1 
        if thompson and not removing then 
            for i,v in pairs(Config.DisableControls) do 
                DisableControlAction(0, v, 1) 
            end
            local held = GetPedCurrentHeldWeapon(PlayerPedId())
            if held ~= 834124286 then 
                SetCurrentPedWeapon(PlayerPedId(), `weapon_shotgun_pump`, 1, 0, 0, 1)
                local a = GetCurrentPedWeaponEntityIndex(PlayerPedId(), 0)
                SetEntityVisible(a, false)
                Wait(500)
            end
            if IsDisabledControlPressed(0, 0xE30CD707) and not pressed and held == 834124286 then 
                pressed = true
                if thompsoninfo.ammo == 0 then 
                    TriggerServerEvent("ricx_thompson:getammo")
                    Wait(1000)
                    ReloadTommyGun()
                else
                    ReloadTommyGun()
                end
                Wait(100)
                pressed = false
            end
            if IsDisabledControlPressed(0, 0x07CE1E61) and not pressed and held == 834124286 then 
                if thompsoninfo and thompsoninfo.hit and thompsoninfo.damaged < 9.8 then
                    pressed = true
                    if thompsoninfo.inclip > 0 then 
                        local remove = math.random(1,3)/100
                        thompsoninfo.damaged = thompsoninfo.damaged + remove
                        thompsoninfo.inclip = thompsoninfo.inclip - 1 
                        local explosionTag_id = 15 
                        local ped_coords = GetEntityCoords(thompsoninfo.barrel)
                        local damageScale = 0.0

                        local weaponType = Config.BarrelTypes[thompsoninfo.barreltype][1]
                        Citizen.InvokeNative(0x7D6F58F69DA92530, ped_coords.x, ped_coords.y, ped_coords.z, explosionTag_id, damageScale, false, false, false)
                        TriggerServerEvent("ricx_thompson:bullet_s", ped_coords, thompsoninfo.bc, weaponType)
                        Citizen.InvokeNative(0x867654CBC7606F2C, ped_coords, thompsoninfo.bc, 1.0, 1, weaponType, PlayerPedId(), 0, 1, 5.0, 1)
                        local dt = 0 
                        if thompsoninfo.damaged == 0 then 
                            dt = 1
                        end
                        Wait(50*(dt+thompsoninfo.damaged))
                    end
                    pressed = false
                end
            end
        else
            t = 1000
        end
        Wait(t)
    end
end)

--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ricx_thompson:bullet", function(pc, bc, type1)
    local dist = #(GetEntityCoords(PlayerPedId()) - pc)
    if dist < 45.0 then
        Citizen.InvokeNative(0x867654CBC7606F2C, pc, bc, 0.0, 0, type1, PlayerPedId(), 1, 0, 0.0, 0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local t = 5 
        local pressed = false
        if thompson and not removing then 
            if thompsoninfo and thompsoninfo.inclip then 
                local cl = 25 * thompsoninfo.clipsize
                local dmg = string.format("%.2f", (100-(thompsoninfo.damaged*10)))
                local msg = TEXTS.TommyGun.."\n"..TEXTS.AmmoD.." "..thompsoninfo.inclip.."/"..cl.." ("..TEXTS.PocketD.." "..thompsoninfo.ammo..")\n"..TEXTS.ReloadD.."\n"..TEXTS.ConditionD.." "..dmg.."%"
                --thompsoninfo.hit, thompsoninfo.bc, thompsoninfo.entity = 0, 0, 0
                thompsoninfo.hit, thompsoninfo.bc, thompsoninfo.entity = RayCastGamePlayCamera(1000.0)
                local dist = #(thompsoninfo.bc - GetEntityCoords(PlayerPedId()))
                if dist <= 1.0 then 
                    thompsoninfo.hit, thompsoninfo.bc = 1, GetOffsetFromEntityInWorldCoords(thompsoninfo.barrel, 30.0, 0.8, 0.5)
                end
                local label  = CreateVarString(10, 'LITERAL_STRING', msg)
                PromptSetActiveGroupThisFrame(PromptGroup, label)
                if Citizen.InvokeNative(0xC92AC953F0A982AE,PromptKey) then
                    ResetTommyGun()
                    Wait(3000)
                end   
            end
        else
            t = 1000
        end
        Citizen.Wait(t)
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local t = 5 
        if pcoords ~= nil and (isdead ~= nil and isdead == false) and menuOpen == false and not thompson then 
            for i,v in pairs(Config.GunDealers) do 
                local dist = #(pcoords-v.coords)
                if dist < 7.0 then
                    Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, v.coords.x, v.coords.y, v.coords.z-0.98, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.3, 126, 0, 0, 255, 0, 0, 2, 0, 0, 0, 0)
                end
                if dist < 1.1 then 
                    local label  = CreateVarString(10, 'LITERAL_STRING', msg)
                    PromptSetActiveGroupThisFrame(ShopPrompts, label)
                    if Citizen.InvokeNative(0xC92AC953F0A982AE,OpenShop) then
                        TriggerServerEvent("ricx_thompson:check_shop", i)
                        Wait(3000)
                    end   
                    if Citizen.InvokeNative(0xC92AC953F0A982AE,ShopUpgrade) then
                        TriggerServerEvent("ricx_thompson:check_shop", i, 1)
                        Wait(3000)
                    end 
                end
            end
        else
            t = 1500
        end
        Citizen.Wait(t)
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ricx_thompson:add_thompson", function(meta)
    if thompson then 
        TriggerEvent("Notification:left_tommygun", TEXTS.TommyGun, TEXTS.AlreadyEquipped, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
        return
    end
    if thompsoninfo == nil then
        thompsoninfo = {}
    end
    thompsoninfo.spring = 1
    thompsoninfo.clipsize = meta.clipsize
    thompsoninfo.damaged = meta.damaged
    thompsoninfo.barreltype = meta.barreltype
    thompsoninfo.id = meta.id
    Citizen.InvokeNative(0x06D26A96CA1BCA75, PlayerPedId(), 11, 1, 0)
    local mod = `w_sb_gusenberg_hi`
    local mod2 = `p_bocceballjack01x`
    local mod3 = `w_pistol_semiauto01_clip`
    LoadModel(mod)
    LoadModel(mod2)
    LoadModel(mod3)

    Citizen.InvokeNative(0x5E3BDDBCB83F3D84, PlayerPedId(), `weapon_shotgun_pump`, 0, true, false)

    SetCurrentPedWeapon(PlayerPedId(), `weapon_shotgun_pump`, 1, 0, 0, 1)
    Wait(500)
    local a = GetCurrentPedWeaponEntityIndex(PlayerPedId(), 0)
    SetEntityVisible(a, false)
    SetEntityCollision(a, 0, 0)
    thompson = CreateObject(mod, GetEntityCoords(PlayerPedId()), 1, 1, 1)
    SetEntityCollision(thompson, 0, 0)
    thompsoninfo.barrel = CreateObject(mod2, GetEntityCoords(PlayerPedId()), 0, 0, 0)
    thompsoninfo.clip = CreateObject(mod3, GetEntityCoords(PlayerPedId()), 0, 0, 0)
    SetEntityCollision(thompsoninfo.clip, 0, 0)

    SetEntityVisible(thompsoninfo.barrel, false)
    SetEntityCollision(thompsoninfo.barrel, 0, 0)
    AttachEntityToEntity(thompsoninfo.barrel, thompson, 0, 0.44, 0.0, 0.03, 180.0, 0.0, 0.0, false, false, false, true, 2, true)
    AttachEntityToEntity(thompsoninfo.clip, thompson, 0,  0.08, 0.01, -0.05, 0.0, 0.0, 0.0, false, false, false, true, 2, true)
    local bone1 = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_HAND")
    
    AttachEntityToEntity(thompson, PlayerPedId(), bone1, 0.15, 0.05, -0.02, 275.0, 5.0, 11.0, false, false, false, true, 2, true)
    if not thompsoninfo.ammo then 
        thompsoninfo.ammo = meta.ammo
    end
    if not thompsoninfo.inclip then 
        thompsoninfo.inclip = meta.inclip
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ricx_thompson:add_ammo", function(id)
    if not thompson then 
        TriggerEvent("Notification:left_tommygun", TEXTS.TommyGun, TEXTS.NoAmmo, TEXTURES.alert[1], TEXTURES.alert[2], 3000)
        return
    end
    if not thompsoninfo then
        thompsoninfo = {}
        thompsoninfo.ammo = 0 
        thompsoninfo.inclip = 0
    end
    thompsoninfo.ammo = thompsoninfo.ammo + 25
    if not id then
        TriggerServerEvent("ricx_thompson:removeammo")
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ricx_thompson:gundealer", function(id)
    MenuData.CloseAll()
    menuOpen = true
    local elements = {}
    local shop = Config.GunDealers[id]
    for i,v in pairs(shop.items) do 
        elements[i] = {label = v[2].." $"..v[3], value = {i,v}, desc = TEXTS.BuyItem}
    end 

    MenuData.Open('default', GetCurrentResourceName(), 'ricx_thompsonguns'..id,{
         title    = shop.name,
         subtext    = TEXTS.Options,
         align    = "top-right",
         elements = elements,
     },
     function(data, menu)
        if data.current.value then 
            TriggerServerEvent("ricx_thompson:buy_product", id, data.current.value)
            menuOpen = false
            menu.close()
        end
     end,
     function(data, menu)
        menuOpen = false
        menu.close()
     end)
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ricx_thompson:gundealer_upgrade", function(id)
    MenuData.CloseAll()
    menuOpen = true
    local shop = Config.GunDealers[id]
    local elements = {
        {label = TEXTS.ClipUpgrade, value = "clipsize", desc = "$"..shop.upgrade_price},
        {label = TEXTS.Repair, value = "repair", desc = "$"..shop.upgrade_price},
        {label = TEXTS.Barrels, value = "barrels", desc = TEXTS.SelectBarrel},
    }

    MenuData.Open('default', GetCurrentResourceName(), 'ricx_thompsongun_upgrades'..id,{
         title    = shop.name..": "..TEXTS.UpgradesDis,
         subtext    = TEXTS.Options,
         align    = "top-right",
         elements = elements,
     },
     function(data, menu)
        if data.current.value then 
            if data.current.value ~= "barrels" then
                TriggerServerEvent("ricx_thompson:buy_upgrade", id, data.current.value)
                menuOpen = false
                menu.close()
            else
                menuOpen = false
                menu.close()
                TriggerEvent("ricx_thompson:barrels", id)
            end
        end
     end,
     function(data, menu)
        menuOpen = false
        menu.close()
     end)
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ricx_thompson:barrels", function(id)
    MenuData.CloseAll()
    menuOpen = true
    local shop = Config.GunDealers[id]
    local elements = {}

    for i,v in pairs(Config.BarrelTypes) do 
        elements[i] = {label = v[2].." $"..v[3], value = {i, v}, desc = TEXTS.ChangeBarrel}
    end

    MenuData.Open('default', GetCurrentResourceName(), 'ricx_thompsongun_upgrade_b'..id,{
         title    = shop.name..": "..TEXTS.Barrels,
         subtext    = TEXTS.Options,
         align    = "top-right",
         elements = elements,
     },
     function(data, menu)
        if data.current.value then 
            TriggerServerEvent("ricx_thompson:buy_upgrade", id, data.current.value, "barrel")
            menuOpen = false
            menu.close()
        end
     end,
     function(data, menu)
        menuOpen = false
        menu.close()
     end)
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ricx_:", function()

end)
--------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
    if menuOpen then
        MenuData.CloseAll()
    end
    if thompson then 
        DeleteEntity(thompson)
        if thompsoninfo.barrel then 
            DeleteEntity(thompsoninfo.barrel)
        end
        if thompsoninfo.clip then 
            DeleteEntity(thompsoninfo.clip)
        end
    end
    for i,v in pairs(prompts) do 
        PromptDelete(v)
    end
    for i,v in pairs(BlipEntities) do 
        RemoveBlip(v)
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
----------------------------Basic Notification----------------------------
RegisterNetEvent('Notification:left_tommygun', function(t1, t2, dict, txtr, timer)
    local _dict = tostring(dict)
    if not HasStreamedTextureDictLoaded(_dict) then
        RequestStreamedTextureDict(_dict, true) 
        while not HasStreamedTextureDictLoaded(_dict) do
            Citizen.Wait(5)
        end
    end
    if txtr ~= nil then
        exports.ricx_thompson.LeftNot(0, tostring(t1), tostring(t2), tostring(dict), tostring(txtr), tonumber(timer))
    else
        local txtr = "tick"
        exports.ricx_thompson.LeftNot(0, tostring(t1), tostring(t2), tostring(dict), tostring(txtr), tonumber(timer))
    end
     SetStreamedTextureDictAsNoLongerNeeded(_dict)
end)
--------------------------------------------------------------------------------------------------------------------------------------------
