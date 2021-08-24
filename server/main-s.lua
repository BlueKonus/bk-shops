ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('bk-shop:buyItem')
AddEventHandler('bk-shop:buyItem', function(item, price)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src) 
    if xPlayer then
        print(price)
        if (xPlayer.getMoney() - price) >= price then 
            xPlayer.removeMoney(price) 
            xPlayer.addInventoryItem(item, 1)
            TriggerClientEvent('bk-shop:buyed', _src)
        end
    end
end)

