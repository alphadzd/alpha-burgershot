local QBCore = exports['qb-core']:GetCoreObject()

print('Alpha Burger Shot Server Started')

local items = {
    ['burger'] = {name = 'burger', label = 'Regular Burger', price = 15, image = 'burger.png'},
    ['burger_deluxe'] = {name = 'burger_deluxe', label = 'Deluxe Burger', price = 25, image = 'burger_deluxe.png'},
    ['burger_veggie'] = {name = 'burger_veggie', label = 'Veggie Burger', price = 18, image = 'burger_veggie.png'},
    ['burger_soda'] = {name = 'burger_soda', label = 'Soda', price = 8, image = 'burger_soda.png'},
    ['burger_milkshake'] = {name = 'burger_milkshake', label = 'Milkshake', price = 12, image = 'burger_milkshake.png'},
    ['burger_fries'] = {name = 'burger_fries', label = 'French Fries', price = 10, image = 'burger_fries.png'}
}

local pendingOrders = {}
local acceptedOrders = {}
local orderIdCounter = 1
local playerOrders = {}
local function HasBurgershotJob(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return false
    end
    return Player.PlayerData.job and Player.PlayerData.job.name == 'burgershot'
end


local function NotifyBurgershotStaff(eventName, data)
    local Players = QBCore.Functions.GetPlayers()
    for _, playerId in pairs(Players) do
        if HasBurgershotJob(playerId) then
            TriggerClientEvent(eventName, playerId, data)
        end
    end
end


local function SendCustomNotification(src, message, type, duration)
    TriggerClientEvent('burgershot:showNotification', src, message, type, duration)
end

RegisterServerEvent('burgershot:buyItem', function(itemName, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then
        print('Error: Player not found for source: ' .. src)
        return
    end
    
    if not items[itemName] then
        print('Error: Item not found: ' .. itemName)
        SendCustomNotification(src, 'Invalid item!', 'error')
        return
    end
    

    local playerMoney = Player.Functions.GetMoney('cash')
    
    if playerMoney >= price then

        if not playerOrders[src] then
            playerOrders[src] = {
                items = {},
                total = 0,
                startTime = GetGameTimer()
            }
        end
        

        local existingItem = nil
        for _, item in ipairs(playerOrders[src].items) do
            if item.itemName == itemName then
                existingItem = item
                break
            end
        end
        
        if existingItem then
            existingItem.quantity = existingItem.quantity + 1
        else
            table.insert(playerOrders[src].items, {
                itemName = itemName,
                name = items[itemName].label,
                quantity = 1,
                price = price
            })
        end
        
        playerOrders[src].total = playerOrders[src].total + price
        

        if playerOrders[src].timer then
            ClearTimeout(playerOrders[src].timer)
        end
        
        playerOrders[src].timer = SetTimeout(2000, function()
            CreateOrderFromPlayerCart(src)
        end)
        
    else
        SendCustomNotification(src, 'Not enough money! You need $' .. price .. ' but only have $' .. playerMoney, 'error')
        print('Player ' .. src .. ' tried to buy ' .. itemName .. ' but only has $' .. playerMoney .. ' (needs $' .. price .. ')')
    end
end)

function CreateOrderFromPlayerCart(src)
    if not playerOrders[src] or #playerOrders[src].items == 0 then
        return
    end
    
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        playerOrders[src] = nil
        return
    end
    
    local orderId = orderIdCounter
    orderIdCounter = orderIdCounter + 1
    
    local customerName = 'Unknown Customer'
    if Player.PlayerData.charinfo then
        customerName = (Player.PlayerData.charinfo.firstname or 'Unknown') .. ' ' .. (Player.PlayerData.charinfo.lastname or 'Customer')
    end
    
    local order = {
        id = orderId,
        customerId = src,
        customerName = customerName,
        items = playerOrders[src].items,
        total = playerOrders[src].total,
        time = os.date('%H:%M:%S'),
        allItems = playerOrders[src].items
    }
    
    pendingOrders[orderId] = order
    
    print('Order created: #' .. orderId .. ' for player ' .. src .. ' - ' .. customerName .. ' (Total: $' .. order.total .. ')')
    

    playerOrders[src] = nil
    
    SendCustomNotification(src, 'Order placed! Please wait for staff to process your order.', 'success')
    NotifyBurgershotStaff('burgershot:updateStaffPanel', GetOrdersArray())
    
    print('Orders sent to staff panels. Total pending orders: ' .. #GetOrdersArray())
end

RegisterServerEvent('burgershot:acceptOrder', function(orderId)
    local src = source
    if not HasBurgershotJob(src) then
        SendCustomNotification(src, 'You must be a Burger Shot employee to do this!', 'error')
        return
    end
    
    local order = pendingOrders[orderId]
    
    if order then
        local Customer = QBCore.Functions.GetPlayer(order.customerId)
        local Staff = QBCore.Functions.GetPlayer(src)
        
        if Customer and Staff then
            if Customer.Functions.RemoveMoney('cash', order.total) then

                local staffPayment = math.floor(order.total * 0.5)
                

                Staff.Functions.AddMoney('cash', staffPayment)
                

                order.acceptedBy = src
                order.acceptedTime = os.date('%H:%M:%S')
                order.status = 'accepted'
                acceptedOrders[orderId] = order
                
                SendCustomNotification(order.customerId, 'Your order has been accepted! Please wait for your order to be prepared.', 'success')
                SendCustomNotification(src, 'Order #' .. orderId .. ' accepted! You received $' .. staffPayment .. ' (50% of order value). Customer is waiting for order.', 'success')
                
                print('Order #' .. orderId .. ' accepted by staff ' .. src .. '. Customer ' .. order.customerId .. ' paid $' .. order.total .. ', staff received $' .. staffPayment)
            else
                SendCustomNotification(order.customerId, 'Not enough money for your order!', 'error')
                SendCustomNotification(src, 'Customer has insufficient funds', 'error')
            end
        elseif not Customer then
            SendCustomNotification(src, 'Customer is no longer online', 'error')
        elseif not Staff then
            print('Error: Staff player not found for source: ' .. src)
        end
        
        pendingOrders[orderId] = nil
        NotifyBurgershotStaff('burgershot:updateStaffPanel', GetOrdersArray())
    else
        TriggerClientEvent('QBCore:Notify', src, 'Order not found!', 'error')
    end
end)

RegisterServerEvent('burgershot:completeOrder', function(orderId)
    local src = source
    if not HasBurgershotJob(src) then
        TriggerClientEvent('QBCore:Notify', src, 'You must be a Burger Shot employee to do this!', 'error')
        return
    end
    
    local order = acceptedOrders[orderId]
    
    if order then
        local Customer = QBCore.Functions.GetPlayer(order.customerId)
        
        if Customer then
            for _, item in ipairs(order.allItems or order.items) do
                for i = 1, item.quantity do
                    Customer.Functions.AddItem(item.itemName, 1)
                    if QBCore.Shared.Items[item.itemName] then
                        TriggerClientEvent('inventory:client:ItemBox', order.customerId, QBCore.Shared.Items[item.itemName], 'add')
                    end
                end
            end
            
            TriggerClientEvent('QBCore:Notify', order.customerId, 'Your order #' .. orderId .. ' is ready! Items have been delivered.', 'success')
            TriggerClientEvent('QBCore:Notify', src, 'Order #' .. orderId .. ' completed and delivered to customer.', 'success')
            
            print('Order #' .. orderId .. ' completed and delivered to customer ' .. order.customerId)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Customer is no longer online', 'error')
        end
        

        acceptedOrders[orderId] = nil
        

        NotifyBurgershotStaff('burgershot:updateAcceptedOrders', GetAcceptedOrdersArray())
    else
        TriggerClientEvent('QBCore:Notify', src, 'Order not found or not accepted!', 'error')
    end
end)

RegisterServerEvent('burgershot:refuseOrder', function(orderId)
    local src = source
    if not HasBurgershotJob(src) then
        TriggerClientEvent('QBCore:Notify', src, 'You must be a Burger Shot employee to do this!', 'error')
        return
    end
    
    local order = pendingOrders[orderId]
    
    if order then
        local Player = QBCore.Functions.GetPlayer(order.customerId)
        
        if Player then
            TriggerClientEvent('QBCore:Notify', order.customerId, 'Your order has been refused by staff.', 'error')
        end
        
        TriggerClientEvent('QBCore:Notify', src, 'Order #' .. orderId .. ' refused', 'success')
        

        pendingOrders[orderId] = nil
        

        NotifyBurgershotStaff('burgershot:updateStaffPanel', GetOrdersArray())
    else
        TriggerClientEvent('QBCore:Notify', src, 'Order not found!', 'error')
    end
end)

RegisterServerEvent('burgershot:getOrders', function()
    local src = source
    
    if not HasBurgershotJob(src) then
        TriggerClientEvent('QBCore:Notify', src, 'You must be a Burger Shot employee to do this!', 'error')
        return
    end
    
    local orders = GetOrdersArray()
    print('Staff panel requested orders. Sending ' .. #orders .. ' orders to player ' .. src)
    TriggerClientEvent('burgershot:updateStaffPanel', src, orders)
end)

RegisterServerEvent('burgershot:getAcceptedOrders', function()
    local src = source
    
    if not HasBurgershotJob(src) then
        TriggerClientEvent('QBCore:Notify', src, 'You must be a Burger Shot employee to do this!', 'error')
        return
    end
    
    local acceptedOrdersArray = GetAcceptedOrdersArray()
    print('Staff panel requested accepted orders. Sending ' .. #acceptedOrdersArray .. ' accepted orders to player ' .. src)
    TriggerClientEvent('burgershot:updateAcceptedOrders', src, acceptedOrdersArray)
end)

function GetOrdersArray()
    local ordersArray = {}
    for orderId, order in pairs(pendingOrders) do
        table.insert(ordersArray, order)
    end
    print('GetOrdersArray called. Found ' .. #ordersArray .. ' pending orders')
    return ordersArray
end

function GetAcceptedOrdersArray()
    local acceptedOrdersArray = {}
    for orderId, order in pairs(acceptedOrders) do
        table.insert(acceptedOrdersArray, order)
    end
    print('GetAcceptedOrdersArray called. Found ' .. #acceptedOrdersArray .. ' accepted orders')
    return acceptedOrdersArray
end