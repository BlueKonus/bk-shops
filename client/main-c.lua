ESX = nil
local ped

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) -- Základ ESX
        Citizen.Wait(0)
    end
end)

function menuBuy(value, price)
    local elements = {
        {label = 'Ne', value = 'no'},
        {label = 'Ano', value = 'yes'}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buymenu', {
        title = 'Potvrdit obchod', 
        align = 'center', 
        elements = elements
    }, function(data, menu)
        if data.current.value == 'yes' then
            TriggerServerEvent('bk-shop:buyItem', value, price)  -- Propojení
            print('Zaplatil jsi nákup')
            menu.close()
        elseif data.current.value == 'no' then
            menu.close() -- Zavření menu
        end
    end, function(data, menu)
        menu.close()
    end)
end

function openShopMenu() 
    local elements = {}
    
    for i=1, #Config.Shops do
        local item = Config.Shops[i]
        local itemLabel = string.format('%s - $%s / %sks', item.label, item.price * AMOUNT_TO_BUY, AMOUNT_TO_BUY)
        table.insert(elements, {label = itemLabel, value = item.name, price = item.price})      
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_menu', {
        title = 'Obchod', 
        align = 'center', 
        elements = elements, 
    }, function(data, menu) 
        menu.close() 
        menuBuy(data.current.value, data.current.price)
    end, function(data, menu) 
        menu.close() 
    end)
end  

local blips = {

     {title="Obchod", colour=5, id=446, x = -51.5, y = -1754.84, z = 38.009},
     {title="Obchod", colour=5, id=446, x = 25.74, y = -1347.13, z = 29.5},
     {title="Obchod", colour=5, id=446, x = -706.12, y = -913.61, z = 29.5},
     {title="Obchod", colour=5, id=446, x = 1134.32, y = -983.0, z = 45.42},
     {title="Obchod", colour=5, id=446, x = 1163.6, y = -323.98, z = 69.21},
     {title="Obchod", colour=5, id=446, x = 372.51, y = 326.43, z = 103.57},
     {title="Obchod", colour=5, id=446, x = -1486.55, y = -377.64, z = 40.16},
     {title="Obchod", colour=5, id=446, x = -1221.43, y = -907.91, z = 12.33},
}
      
Citizen.CreateThread(function()

	for k,v in pairs(Config.Pos) do
		local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

		SetBlipSprite (blip, 52)
		SetBlipScale  (blip, 1.0)
		SetBlipColour (blip, 2)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString('Obchod')
		EndTextCommandSetBlipName(blip)
	end
end)

function DrawText3Ds(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local p = GetGameplayCamCoords()
	local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
	local scale = (1 / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov
	if onScreen then
		SetTextScale(0.30, 0.30)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0120, factor, 0.026, 41, 11, 41, 68)
	end
end

local nearestCoords
local timeToWait = 500

Citizen.CreateThread(function()
    while true do
        Wait(500)
        if nearestCoords then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            if #(pedCoords - nearestCoords) > 3 then
                nearestCoords = nil
                timeToWait = 500
            else
                Wait(500)
            end
        else
            Wait(500)
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        Wait(timeToWait)

        for k,v in pairs(Config.Pos) do
            local coords = GetEntityCoords(PlayerPedId())
            local dist = #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z))
            if dist < 3 then
                if not nearestCoords then
                    timeToWait = 0
                    nearestCoords = vector3(v.Pos.x, v.Pos.y, v.Pos.z)
                end
                    DrawText3Ds(v.Pos.x, v.Pos.y, v.Pos.z + 0.1, '[~g~E~s~] Shop')
                    if IsControlJustPressed(0, 38) then
                        openShopMenu()
                    end
            end
        end
    end
end)

local koordinaten = {
    {-46.6, -1757.92, 28.40,"obchodnik",51.54,0x18CE57D0,"mp_m_shopkeep_01"},
    {24.5, -1347.29, 28.5,"obchodnik",261.34,0x18CE57D0,"mp_m_shopkeep_01"},
    {-706.1, -913.61, 18.22,"obchodnik",86.62,0x18CE57D0,"mp_m_shopkeep_01"},
    {1134.32, -983.0, 45.42,"obchodnik",282.81,0x18CE57D0,"mp_m_shopkeep_01"},
    {1164.84, -323.5, 68.21,"obchodnik",101.03,0x18CE57D0,"mp_m_shopkeep_01"},
    {372.51, 326.34, 102.57,"obchodnik",252.79,0x18CE57D0,"mp_m_shopkeep_01"},
    {-1486.67, -377.58, 39.16,"obchodnik",132.35,0x18CE57D0,"mp_m_shopkeep_01"},
    {-1221.43, -907.91, 11.33,"obchodnik",34.37,0x18CE57D0,"mp_m_shopkeep_01"},
  }
  
  Citizen.CreateThread(function()
  
      for _,v in pairs(koordinaten) do
        RequestModel(GetHashKey(v[7]))
        while not HasModelLoaded(GetHashKey(v[7])) do
          Wait(1)
        end
    
        RequestAnimDict("mini@strip_club@idles@bouncer@base")
        while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
          Wait(1)
        end
        ped =  CreatePed(4, v[7],v[1],v[2],v[3], GetHashKey(v[7]), false, true)
        SetEntityHeading(ped, v[5])
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

RegisterNetEvent('bk-shop:buyed')
AddEventHandler('bk-shop:buyed', function()
    exports['pogressBar']:drawBar(3000, 'Platíš nákup')
    loadAnimDict('mp_common')
    TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 1.0, 1.0, -1, 1, 0, 0, 0, 0)
    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 1.0, 1.0, -1, 1, 0, 0, 0, 0)
    Wait(3000)
    ClearPedTasks(PlayerPedId())
    ClearPedTasks(ped)
    RemoveAnimDict('mp_common')
    exports['mythic_notify']:SendAlert('success', string.format('Zaplatil/a jsi nákup.', Config.Shops))
end)
    

