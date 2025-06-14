local QBCore = exports['qb-core']:GetCoreObject()

local preparationLocation = vector3(-1190.99, -898.8, 13.87)

local function HasRequiredJob()
    if not Config.RequireJob then return true end
    
    local Player = QBCore.Functions.GetPlayerData()
    if not Player or not Player.job then return false end
    
    return Config.AllowedJobs[Player.job.name] == true
end

CreateThread(function()
    Wait(1000)
    
    if Config and Config.PreparationLocation then
        preparationLocation = Config.PreparationLocation
    end
    
    if exports.interact and exports.interact.AddInteraction then
        exports.interact:AddInteraction({
            coords = preparationLocation,
            distance = 8.0,
            interactDst = 1.5,
            id = 'preparation_items',
            name = 'Preparation Items',
            options = {
                {
                    label = 'Preparation Items',
                    action = function()
                        TriggerEvent('alpha-preparation:client:openMenu')
                    end,
                },
            }
        })
        
        if Config and Config.CookingLocation then
            exports.interact:AddInteraction({
                coords = Config.CookingLocation,
                distance = 8.0,
                interactDst = 1.5,
                id = 'cooking_station',
                name = 'Cooking Station',
                options = {
                    {
                        label = 'Cook Food',
                        action = function()
                            TriggerEvent('alpha-preparation:client:openCookingMenu')
                        end,
                    },
                }
            })
        end
    end
    
    if Config and Config.Blip and Config.Blip.Enable then
        local blip = AddBlipForCoord(Config.Blip.Coords.x, Config.Blip.Coords.y, Config.Blip.Coords.z)
        SetBlipSprite(blip, Config.Blip.Sprite)
        SetBlipDisplay(blip, Config.Blip.Display)
        SetBlipScale(blip, Config.Blip.Scale)
        SetBlipColour(blip, Config.Blip.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blip.Name)
        EndTextCommandSetBlipName(blip)
    end
end)

local function PlayPrepAnimation()
    local ped = PlayerPedId()
    
    ClearPedTasks(ped)
    
    local dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    
    TaskPlayAnim(ped, dict, "machinic_loop_mechandplayer", 8.0, -8.0, -1, 1, 0, false, false, false)
    
    return dict
end

RegisterNetEvent('alpha-preparation:client:openMenu', function()
    if not HasRequiredJob() then
        lib.notify({
            title = 'Access Denied',
            description = 'You do not have the required job to use this',
            type = 'error'
        })
        return
    end
    
    if lib.progressBar({
        duration = 2000,
        label = 'Checking available items...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            scenario = 'PROP_HUMAN_BUM_BIN',
        },
    }) then
        lib.showContext('preparation_menu')
        lib.notify({
            title = 'Preparation Menu',
            description = 'Select items to prepare',
            type = 'info'
        })
    else
        lib.notify({
            title = 'Cancelled',
            description = 'You cancelled the action',
            type = 'error'
        })
    end
end)

lib.registerContext({
    id = 'preparation_menu',
    title = 'Preparation Items',
    options = {
        {
            title = 'Food Items',
            icon = 'fa-solid fa-burger',
            description = 'Get food preparation items',
            onSelect = function()
                lib.showContext('food_items_menu')
            end,
        },
        {
            title = 'Drink Items',
            icon = 'fa-solid fa-wine-glass',
            description = 'Get drink preparation items',
            onSelect = function()
                lib.showContext('drink_items_menu')
            end,
        },
        {
            title = 'Cooking Utensils',
            icon = 'fa-solid fa-utensils',
            description = 'Get cooking utensils',
            onSelect = function()
                lib.showContext('utensil_items_menu')
            end,
        }
    }
})

local function GetItemWithProgress(itemName, itemLabel)
    if lib.progressBar({
        duration = 1500,
        label = 'Getting ' .. itemLabel .. '...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'mp_common',
            clip = 'givetake1_a',
        },
    }) then
        TriggerServerEvent('alpha-preparation:server:giveItem', itemName, 1)
    else
        lib.notify({
            title = 'Cancelled',
            description = 'You cancelled the action',
            type = 'error'
        })
    end
end

local function CreateFoodItemsMenu()
    local options = {}
    
    if Config and Config.Items and Config.Items.FoodItems then
        for _, item in ipairs(Config.Items.FoodItems) do
            local itemData = QBCore.Shared.Items[item.name]
            
            table.insert(options, {
                title = item.label,
                icon = 'fa-solid fa-burger',
                description = item.description,
                metadata = {
                    {label = 'Item', value = item.name},
                    {label = 'Type', value = 'Food Preparation'}
                },
                onSelect = function()
                    GetItemWithProgress(item.name, item.label)
                end,
            })
        end
    else
        table.insert(options, {
            title = 'Config Error',
            description = 'Config not loaded properly',
            onSelect = function()
                lib.notify({
                    title = 'Error',
                    description = 'Items configuration not loaded',
                    type = 'error'
                })
            end,
        })
    end
    
    return options
end

lib.registerContext({
    id = 'food_items_menu',
    title = 'Food Preparation Items',
    menu = 'preparation_menu',
    options = CreateFoodItemsMenu()
})

local function CreateDrinkItemsMenu()
    local options = {}
    
    if Config and Config.Items and Config.Items.DrinkItems then
        for _, item in ipairs(Config.Items.DrinkItems) do
            local itemData = QBCore.Shared.Items[item.name]
            
            table.insert(options, {
                title = item.label,
                icon = 'fa-solid fa-wine-glass',
                description = item.description,
                metadata = {
                    {label = 'Item', value = item.name},
                    {label = 'Type', value = 'Drink Preparation'}
                },
                onSelect = function()
                    GetItemWithProgress(item.name, item.label)
                end,
            })
        end
    else
        table.insert(options, {
            title = 'Config Error',
            description = 'Config not loaded properly',
            onSelect = function()
                lib.notify({
                    title = 'Error',
                    description = 'Items configuration not loaded',
                    type = 'error'
                })
            end,
        })
    end
    
    return options
end

lib.registerContext({
    id = 'drink_items_menu',
    title = 'Drink Preparation Items',
    menu = 'preparation_menu',
    options = CreateDrinkItemsMenu()
})

local function CreateUtensilItemsMenu()
    local options = {}
    
    if Config and Config.Items and Config.Items.Utensils then
        for _, item in ipairs(Config.Items.Utensils) do
            local itemData = QBCore.Shared.Items[item.name]
            
            table.insert(options, {
                title = item.label,
                icon = 'fa-solid fa-utensils',
                description = item.description,
                metadata = {
                    {label = 'Item', value = item.name},
                    {label = 'Type', value = 'Cooking Utensil'}
                },
                onSelect = function()
                    GetItemWithProgress(item.name, item.label)
                end,
            })
        end
    else
        table.insert(options, {
            title = 'Config Error',
            description = 'Config not loaded properly',
            onSelect = function()
                lib.notify({
                    title = 'Error',
                    description = 'Items configuration not loaded',
                    type = 'error'
                })
            end,
        })
    end
    
    return options
end

lib.registerContext({
    id = 'utensil_items_menu',
    title = 'Cooking Utensils',
    menu = 'preparation_menu',
    options = CreateUtensilItemsMenu()
})

local function CookItemWithProgress(itemName, itemLabel, requiredItems)
    local hasItems = true
    local missingItems = {}
    
    for _, item in ipairs(requiredItems) do
        local hasItem = QBCore.Functions.HasItem(item.name, item.amount)
        if not hasItem then
            hasItems = false
            table.insert(missingItems, item.label)
        end
    end
    
    if not hasItems then
        local missingItemsText = table.concat(missingItems, ", ")
        lib.notify({
            title = 'Missing Ingredients',
            description = 'You need: ' .. missingItemsText,
            type = 'error'
        })
        return
    end
    
    local animDict = PlayPrepAnimation()
    
    if lib.progressBar({
        duration = 5000,
        label = 'Cooking ' .. itemLabel .. '...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
    }) then
        for _, item in ipairs(requiredItems) do
            TriggerServerEvent('alpha-preparation:server:removeItem', item.name, item.amount)
        end
        
        TriggerServerEvent('alpha-preparation:server:giveItem', itemName, 1)
        
        lib.notify({
            title = 'Success',
            description = 'You cooked a ' .. itemLabel,
            type = 'success'
        })
    else
        lib.notify({
            title = 'Cancelled',
            description = 'You cancelled the cooking',
            type = 'error'
        })
    end
    
    ClearPedTasks(PlayerPedId())
    RemoveAnimDict(animDict)
end

RegisterNetEvent('alpha-preparation:client:openCookingMenu', function()
    if not HasRequiredJob() then
        lib.notify({
            title = 'Access Denied',
            description = 'You do not have the required job to use this',
            type = 'error'
        })
        return
    end
    
    if lib.progressBar({
        duration = 2000,
        label = 'Checking cooking station...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            scenario = 'PROP_HUMAN_BUM_BIN',
        },
    }) then
        lib.showContext('cooking_menu')
        lib.notify({
            title = 'Cooking Station',
            description = 'Select items to cook',
            type = 'info'
        })
    else
        lib.notify({
            title = 'Cancelled',
            description = 'You cancelled the action',
            type = 'error'
        })
    end
end)

lib.registerContext({
    id = 'cooking_menu',
    title = 'Cooking Station',
    options = {
        {
            title = 'Burgers',
            icon = 'fa-solid fa-burger',
            description = 'Cook different types of burgers',
            onSelect = function()
                lib.showContext('burger_cooking_menu')
            end,
        },
        {
            title = 'Drinks',
            icon = 'fa-solid fa-wine-glass',
            description = 'Prepare different drinks',
            onSelect = function()
                lib.showContext('drink_cooking_menu')
            end,
        },
        {
            title = 'Side Items',
            icon = 'fa-solid fa-utensils',
            description = 'Cook side items like fries',
            onSelect = function()
                lib.showContext('side_cooking_menu')
            end,
        }
    }
})

lib.registerContext({
    id = 'burger_cooking_menu',
    title = 'Cook Burgers',
    menu = 'cooking_menu',
    options = {
        {
            title = 'Regular Burger',
            icon = 'fa-solid fa-burger',
            description = 'Cook a regular burger',
            metadata = {
                {label = 'Ingredients', value = 'Bun, Beef Patty, Lettuce, Tomato, Cheese'},
            },
            onSelect = function()
                CookItemWithProgress('burger', 'Regular Burger', {
                    {name = 'burger_bun', label = 'Burger Bun', amount = 1},
                    {name = 'burger_patty', label = 'Beef Patty', amount = 1},
                    {name = 'burger_lettuce', label = 'Lettuce', amount = 1},
                    {name = 'burger_tomato', label = 'Tomato', amount = 1},
                    {name = 'burger_cheese', label = 'Cheese Slice', amount = 1}
                })
            end,
        },
        {
            title = 'Deluxe Burger',
            icon = 'fa-solid fa-burger',
            description = 'Cook a deluxe burger with bacon',
            metadata = {
                {label = 'Ingredients', value = 'Bun, Beef Patty, Lettuce, Tomato, Cheese, Bacon, Onion'},
            },
            onSelect = function()
                CookItemWithProgress('burger_deluxe', 'Deluxe Burger', {
                    {name = 'burger_bun', label = 'Burger Bun', amount = 1},
                    {name = 'burger_patty', label = 'Beef Patty', amount = 1},
                    {name = 'burger_lettuce', label = 'Lettuce', amount = 1},
                    {name = 'burger_tomato', label = 'Tomato', amount = 1},
                    {name = 'burger_cheese', label = 'Cheese Slice', amount = 1},
                    {name = 'burger_bacon', label = 'Bacon', amount = 1},
                    {name = 'burger_onion', label = 'Onion', amount = 1}
                })
            end,
        },
        {
            title = 'Veggie Burger',
            icon = 'fa-solid fa-leaf',
            description = 'Cook a vegetarian burger',
            metadata = {
                {label = 'Ingredients', value = 'Bun, Veggie Patty, Lettuce, Tomato, Cheese, Onion'},
            },
            onSelect = function()
                CookItemWithProgress('burger_veggie', 'Veggie Burger', {
                    {name = 'burger_bun', label = 'Burger Bun', amount = 1},
                    {name = 'burger_vegpatty', label = 'Vegetable Patty', amount = 1},
                    {name = 'burger_lettuce', label = 'Lettuce', amount = 1},
                    {name = 'burger_tomato', label = 'Tomato', amount = 1},
                    {name = 'burger_cheese', label = 'Cheese Slice', amount = 1},
                    {name = 'burger_onion', label = 'Onion', amount = 1}
                })
            end,
        }
    }
})

lib.registerContext({
    id = 'drink_cooking_menu',
    title = 'Prepare Drinks',
    menu = 'cooking_menu',
    options = {
        {
            title = 'Soda',
            icon = 'fa-solid fa-wine-bottle',
            description = 'Prepare a soda',
            metadata = {
                {label = 'Ingredients', value = 'Cup, Soda Syrup'},
            },
            onSelect = function()
                CookItemWithProgress('burger_soda', 'Soda', {
                    {name = 'burger_cup', label = 'Cup', amount = 1},
                    {name = 'burger_syrup', label = 'Soda Syrup', amount = 1}
                })
            end,
        },
        {
            title = 'Milkshake',
            icon = 'fa-solid fa-mug-hot',
            description = 'Prepare a milkshake',
            metadata = {
                {label = 'Ingredients', value = 'Cup, Milk, Ice Cream'},
            },
            onSelect = function()
                CookItemWithProgress('burger_milkshake', 'Milkshake', {
                    {name = 'burger_cup', label = 'Cup', amount = 1},
                    {name = 'burger_milk', label = 'Milk', amount = 1},
                    {name = 'burger_icecream', label = 'Ice Cream', amount = 1}
                })
            end,
        }
    }
})

lib.registerContext({
    id = 'side_cooking_menu',
    title = 'Cook Side Items',
    menu = 'cooking_menu',
    options = {
        {
            title = 'French Fries',
            icon = 'fa-solid fa-utensils',
            description = 'Cook french fries',
            metadata = {
                {label = 'Ingredients', value = 'Potato, Cooking Oil'},
            },
            onSelect = function()
                CookItemWithProgress('burger_fries', 'French Fries', {
                    {name = 'burger_potato', label = 'Potato', amount = 1},
                    {name = 'burger_oil', label = 'Cooking Oil', amount = 1}
                })
            end,
        }
    }
})

local function PlayEatAnimation()
    local ped = PlayerPedId()
    
    ClearPedTasks(ped)
    
    local dict = "mp_player_inteat@burger"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    
    TaskPlayAnim(ped, dict, "mp_player_int_eat_burger", 8.0, -8.0, -1, 49, 0, false, false, false)
    
    return dict
end

local function PlayDrinkAnimation()
    local ped = PlayerPedId()
    
    ClearPedTasks(ped)
    
    local dict = "mp_player_intdrink"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    
    TaskPlayAnim(ped, dict, "loop_bottle", 8.0, -8.0, -1, 49, 0, false, false, false)
    
    return dict
end

RegisterNetEvent('alpha-preparation:client:eatBurger', function()
    local animDict = PlayEatAnimation()
    
    QBCore.Functions.Progressbar("eat_burger", "Eating Regular Burger...", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('alpha-preparation:server:removeItem', "burger", 1)
        
        TriggerServerEvent('alpha-preparation:server:updateHunger', 35)
        TriggerServerEvent('hud:server:RelieveStress', math.random(5, 10))
        
        QBCore.Functions.Notify('You ate a Regular Burger', 'success')
        
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict(animDict)
    end, function()
        QBCore.Functions.Notify('Cancelled...', 'error')
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict(animDict)
    end)
end)

RegisterNetEvent('alpha-preparation:client:eatDeluxeBurger', function()
    local animDict = PlayEatAnimation()
    
    QBCore.Functions.Progressbar("eat_deluxe_burger", "Eating Deluxe Burger...", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('alpha-preparation:server:removeItem', "burger_deluxe", 1)
        
        TriggerServerEvent('alpha-preparation:server:updateHunger', 50)
        TriggerServerEvent('hud:server:RelieveStress', math.random(10, 15))
        
        QBCore.Functions.Notify('You ate a Deluxe Burger - You feel energized!', 'success')
        
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict(animDict)
    end, function()
        QBCore.Functions.Notify('Cancelled...', 'error')
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict(animDict)
    end)
end)

RegisterNetEvent('alpha-preparation:client:eatVeggieBurger', function()
    local animDict = PlayEatAnimation()
    
    QBCore.Functions.Progressbar("eat_veggie_burger", "Eating Veggie Burger...", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('alpha-preparation:server:removeItem', "burger_veggie", 1)
        
        TriggerServerEvent('alpha-preparation:server:updateHunger', 40)
        TriggerServerEvent('hud:server:RelieveStress', math.random(8, 12))
        
        QBCore.Functions.Notify('You ate a Veggie Burger - You feel healthier!', 'success')
        
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict(animDict)
    end, function()
        QBCore.Functions.Notify('Cancelled...', 'error')
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict(animDict)
    end)
end)

RegisterNetEvent('alpha-preparation:client:drinkSoda', function()
    local animDict = PlayDrinkAnimation()
    
    QBCore.Functions.Progressbar("drink_soda", "Drinking Soda...", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('alpha-preparation:server:removeItem', "burger_soda", 1)
        
        TriggerServerEvent('alpha-preparation:server:updateThirst', 35)
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 5))
        
        QBCore.Functions.Notify('You drank a Soda', 'success')
        
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict(animDict)
    end, function()
        QBCore.Functions.Notify('Cancelled...', 'error')
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict(animDict)
    end)
end)

RegisterNetEvent('alpha-preparation:client:drinkMilkshake', function()
    local animDict = PlayDrinkAnimation()
    
    QBCore.Functions.Progressbar("drink_milkshake", "Drinking Milkshake...", 3500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('alpha-preparation:server:removeItem', "burger_milkshake", 1)
        
        TriggerServerEvent('alpha-preparation:server:updateThirst', 45)
        TriggerServerEvent('hud:server:RelieveStress', math.random(8, 12))
        
        QBCore.Functions.Notify('You drank a Milkshake - You feel relaxed!', 'success')
        
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict(animDict)
    end, function()
        QBCore.Functions.Notify('Cancelled...', 'error')
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict(animDict)
    end)
end)

RegisterNetEvent('alpha-preparation:client:eatFries', function()
    local animDict = PlayEatAnimation()
    
    QBCore.Functions.Progressbar("eat_fries", "Eating French Fries...", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('alpha-preparation:server:removeItem', "burger_fries", 1)
        
        TriggerServerEvent('alpha-preparation:server:updateHunger', 25)
        TriggerServerEvent('hud:server:RelieveStress', math.random(3, 7))
        
        QBCore.Functions.Notify('You ate French Fries', 'success')
        
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict(animDict)
    end, function()
        QBCore.Functions.Notify('Cancelled...', 'error')
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict(animDict)
    end)
end)