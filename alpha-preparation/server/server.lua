local QBCore = exports['qb-core']:GetCoreObject()

local function HasRequiredJob(Player)
    if not Config.RequireJob then return true end
    
    if not Player or not Player.PlayerData or not Player.PlayerData.job then return false end
    
    return Config.AllowedJobs[Player.PlayerData.job.name] == true
end

RegisterNetEvent('alpha-preparation:server:giveItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        if not HasRequiredJob(Player) then
            TriggerClientEvent('QBCore:Notify', src, 'You do not have the required job to use this', 'error')
            return
        end
        
        if QBCore.Shared.Items[item] then
            if Player.Functions.AddItem(item, amount) then
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
                TriggerClientEvent('QBCore:Notify', src, 'You received ' .. amount .. 'x ' .. QBCore.Shared.Items[item].label, 'success')
            else
                TriggerClientEvent('QBCore:Notify', src, 'Your inventory is full', 'error')
            end
        else
            print('Item not found in shared items: ' .. item)
            TriggerClientEvent('QBCore:Notify', src, 'Item not available', 'error')
        end
    end
end)

RegisterNetEvent('alpha-preparation:server:removeItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        if not HasRequiredJob(Player) then
            TriggerClientEvent('QBCore:Notify', src, 'You do not have the required job to use this', 'error')
            return
        end
        
        if QBCore.Shared.Items[item] then
            if Player.Functions.RemoveItem(item, amount) then
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove')
            else
                TriggerClientEvent('QBCore:Notify', src, 'You don\'t have this item', 'error')
            end
        else
            print('Item not found in shared items: ' .. item)
            TriggerClientEvent('QBCore:Notify', src, 'Item not available', 'error')
        end
    end
end)

RegisterNetEvent('alpha-preparation:server:updateHunger', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        local hunger = Player.PlayerData.metadata["hunger"]
        if hunger + amount > 100 then
            Player.Functions.SetMetaData("hunger", 100)
        else
            Player.Functions.SetMetaData("hunger", hunger + amount)
        end
    end
end)

RegisterNetEvent('alpha-preparation:server:updateThirst', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        local thirst = Player.PlayerData.metadata["thirst"]
        if thirst + amount > 100 then
            Player.Functions.SetMetaData("thirst", 100)
        else
            Player.Functions.SetMetaData("thirst", thirst + amount)
        end
    end
end)
QBCore.Functions.CreateUseableItem("burger", function(source, item)
    local src = source
    TriggerClientEvent('alpha-preparation:client:eatBurger', src)
end)

QBCore.Functions.CreateUseableItem("burger_deluxe", function(source, item)
    local src = source
    TriggerClientEvent('alpha-preparation:client:eatDeluxeBurger', src)
end)

QBCore.Functions.CreateUseableItem("burger_veggie", function(source, item)
    local src = source
    TriggerClientEvent('alpha-preparation:client:eatVeggieBurger', src)
end)

QBCore.Functions.CreateUseableItem("burger_soda", function(source, item)
    local src = source
    TriggerClientEvent('alpha-preparation:client:drinkSoda', src)
end)

QBCore.Functions.CreateUseableItem("burger_milkshake", function(source, item)
    local src = source
    TriggerClientEvent('alpha-preparation:client:drinkMilkshake', src)
end)

QBCore.Functions.CreateUseableItem("burger_fries", function(source, item)
    local src = source
    TriggerClientEvent('alpha-preparation:client:eatFries', src)
end)