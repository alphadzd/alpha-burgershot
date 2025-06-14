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

function print_gradient(text, colors)
    local lines = {}
    for line in text:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    for i, line in ipairs(lines) do
        local color = colors[(i - 1) % #colors + 1]
        print(string.format("\27[38;5;%sm%s\27[0m", color, line))
    end
end

purple_gradient = { 135, 134, 133, 132, 90, 54 }

ascii_art = [[
██╗    ██╗      ██████╗ ███████╗██╗   ██╗     █████╗ ████████╗███╗   ███╗
██║    ██║      ██╔══██╗██╔════╝██║   ██║    ██╔══██╗╚══██╔══╝████╗ ████║
██║ █╗ ██║█████╗██║  ██║█████╗  ██║   ██║    ███████║   ██║   ██╔████╔██║
██║███╗██║╚════╝██║  ██║██╔══╝  ╚██╗ ██╔╝    ██╔══██║   ██║   ██║╚██╔╝██║
╚███╔███╔╝      ██████╔╝███████╗ ╚████╔╝     ██║  ██║   ██║   ██║ ╚═╝ ██║
 ╚══╝╚══╝       ╚═════╝ ╚══════╝  ╚═══╝      ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝
]]

print_gradient(ascii_art, purple_gradient)

print("\27[38;5;135mCreated by: alphadev\27[0m")
print("\27[38;5;133mRights: discord.gg/w4dev\27[0m")
print("\27[38;5;90mW-Dev BurgerShot Server Loaded Successfully!\27[0m")
print("\27[38;5;60m----------------------------------------\27[0m")
