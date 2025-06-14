exports.interact:AddInteraction({
    coords = vector3(-1194.82, -893.2, 14.0),
    distance = 8.0,
    interactDst = 1.0,
    id = 'burgershot_open_menu',
    name = 'Burger Shot Menu',
    options = {
        {
            label = 'Open Menu',
            action = function(entity, coords, args)
                local playerPed = PlayerPedId()
                
                RequestAnimDict("amb@world_human_tourist_map@male@base")
                while not HasAnimDictLoaded("amb@world_human_tourist_map@male@base") do
                    Citizen.Wait(100)
                end
                TaskPlayAnim(playerPed, "amb@world_human_tourist_map@male@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)

                exports['progressbar']:Progress({
                    name = "opening_menu",
                    duration = 3000,
                    label = "Looking at menu...",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(cancelled)
                    ClearPedTasks(playerPed)
                    
                    if not cancelled then
                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            type = 'openMenu'
                        })
                        ShowNotification('Welcome to Burger Shot!', 'success', 3000)
                    else
                        ShowNotification('Menu access cancelled', 'warning', 2000)
                    end
                end)
            end,
        },
    }
})


RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('placeOrder', function(data, cb)
    local playerPed = PlayerPedId()
    

    SetNuiFocus(false, false)
    cb('ok')
    
    -- Start animation
    RequestAnimDict("mp_common")
    while not HasAnimDictLoaded("mp_common") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, 8.0, -1, 1, 0, false, false, false)
    
    -- Show progress bar
    exports['progressbar']:Progress({
        name = "placing_order",
        duration = 2500,
        label = "Placing order...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(cancelled)
        -- Stop animation
        ClearPedTasks(playerPed)
        
        if not cancelled then
            -- Send each item in the cart as a separate order
            for _, item in ipairs(data.items) do
                for i = 1, item.quantity do
                    TriggerServerEvent('burgershot:buyItem', item.id, item.price)
                end
            end
            ShowNotification('Order placed successfully!', 'success', 4000)
        else
            ShowNotification('Order placement cancelled', 'warning', 3000)
        end
    end)
end)

-- Staff Panel Interaction
exports.interact:AddInteraction({
    coords = vector3(-1201.81, -895.23, 13.8),
    distance = 8.0,
    interactDst = 1.0,
    id = 'burgershot_staff_panel',
    name = 'Staff Panel',
    options = {
        {
            label = 'Open Staff Panel',
            action = function(entity, coords, args)
                local QBCore = exports['qb-core']:GetCoreObject()
                local PlayerData = QBCore.Functions.GetPlayerData()
                
                -- Check if player has burgershot job
                if PlayerData.job and PlayerData.job.name == 'burgershot' then
                    local playerPed = PlayerPedId()
                    
                    -- Start animation
                    RequestAnimDict("amb@world_human_clipboard@male@idle_a")
                    while not HasAnimDictLoaded("amb@world_human_clipboard@male@idle_a") do
                        Citizen.Wait(100)
                    end
                    TaskPlayAnim(playerPed, "amb@world_human_clipboard@male@idle_a", "idle_c", 8.0, 8.0, -1, 1, 0, false, false, false)
                    
                    -- Show progress bar
                    exports['progressbar']:Progress({
                        name = "opening_staff_panel",
                        duration = 2000,
                        label = "Accessing staff panel...",
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                    }, function(cancelled)
                        -- Stop animation
                        ClearPedTasks(playerPed)
                        
                        if not cancelled then
                            -- Open staff panel after progress completes
                            SetNuiFocus(true, true)
                            SendNUIMessage({
                                type = 'openStaffPanel'
                            })
                            ShowNotification('Staff panel accessed', 'info', 3000)
                        else
                            ShowNotification('Staff panel access cancelled', 'warning', 2000)
                        end
                    end)
                else
                    ShowNotification('You must be a Burger Shot employee to use this!', 'error')
                end
            end,
        },
    }
})

RegisterNUICallback('closeStaffPanel', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('acceptOrder', function(data, cb)
    local playerPed = PlayerPedId()
    
    -- Close staff panel first
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'closeStaffPanel'
    })
    cb('ok')
    
    -- Start animation
    RequestAnimDict("mp_common")
    while not HasAnimDictLoaded("mp_common") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, 8.0, -1, 1, 0, false, false, false)
    
    -- Show progress bar
    exports['progressbar']:Progress({
        name = "accepting_order",
        duration = 2000,
        label = "Accepting order...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(cancelled)
        -- Stop animation
        ClearPedTasks(playerPed)
        
        if not cancelled then
            TriggerServerEvent('burgershot:acceptOrder', data.orderId)
            ShowNotification('Processing order acceptance...', 'info', 3000)
        else
            ShowNotification('Order acceptance cancelled', 'warning', 3000)
        end
    end)
end)

RegisterNUICallback('refuseOrder', function(data, cb)
    local playerPed = PlayerPedId()
    
    -- Close staff panel first
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'closeStaffPanel'
    })
    cb('ok')
    
    -- Start animation
    RequestAnimDict("gestures@m@standing@casual")
    while not HasAnimDictLoaded("gestures@m@standing@casual") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(playerPed, "gestures@m@standing@casual", "gesture_no_way", 8.0, 8.0, -1, 1, 0, false, false, false)
    
    -- Show progress bar
    exports['progressbar']:Progress({
        name = "refusing_order",
        duration = 1500,
        label = "Refusing order...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(cancelled)
        -- Stop animation
        ClearPedTasks(playerPed)
        
        if not cancelled then
            TriggerServerEvent('burgershot:refuseOrder', data.orderId)
            ShowNotification('Order refused', 'error', 3000)
        else
            ShowNotification('Order refusal cancelled', 'warning', 3000)
        end
    end)
end)

RegisterNUICallback('completeOrder', function(data, cb)
    local playerPed = PlayerPedId()
    
    -- Close staff panel first
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'closeStaffPanel'
    })
    cb('ok')
    
    -- Start animation
    RequestAnimDict("mp_common")
    while not HasAnimDictLoaded("mp_common") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, 8.0, -1, 1, 0, false, false, false)
    
    -- Show progress bar
    exports['progressbar']:Progress({
        name = "completing_order",
        duration = 3000,
        label = "Preparing and delivering order...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(cancelled)
        -- Stop animation
        ClearPedTasks(playerPed)
        
        if not cancelled then
            TriggerServerEvent('burgershot:completeOrder', data.orderId)
            ShowNotification('Order completed and delivered!', 'success', 4000)
        else
            ShowNotification('Order completion cancelled', 'warning', 3000)
        end
    end)
end)

RegisterNUICallback('getOrders', function(data, cb)
    TriggerServerEvent('burgershot:getOrders')
    cb('ok')
end)

RegisterNUICallback('getAcceptedOrders', function(data, cb)
    TriggerServerEvent('burgershot:getAcceptedOrders')
    cb('ok')
end)

RegisterNetEvent('burgershot:updateStaffPanel', function(orders)
    SendNUIMessage({
        type = 'updateOrders',
        orders = orders
    })
end)

RegisterNetEvent('burgershot:updateAcceptedOrders', function(acceptedOrders)
    SendNUIMessage({
        type = 'updateAcceptedOrders',
        acceptedOrders = acceptedOrders
    })
end)