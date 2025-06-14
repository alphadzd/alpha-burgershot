Config = {}

-- Debug Settings
Config.Debug = false -- Set to false to disable debug prints

-- Restaurant Settings
Config.RestaurantName = "BURGER SHOT"
Config.RestaurantSubtitle = "Premium Fast Food"

-- Interaction Settings
Config.CustomerInteraction = vector3(-1194.82, -893.2, 14.0)
Config.StaffInteraction = vector3(-1201.81, -895.23, 13.8)
Config.InteractionDistance = 8.0
Config.InteractDistance = 1.0

-- Menu Items
Config.Items = {
    ['burger'] = {name = 'burger', label = 'Regular Burger', price = 15, image = 'burger.png'},
    ['burger_deluxe'] = {name = 'burger_deluxe', label = 'Deluxe Burger', price = 25, image = 'burger_deluxe.png'},
    ['burger_veggie'] = {name = 'burger_veggie', label = 'Veggie Burger', price = 18, image = 'burger_veggie.png'},
    ['burger_soda'] = {name = 'burger_soda', label = 'Soda', price = 8, image = 'burger_soda.png'},
    ['burger_milkshake'] = {name = 'burger_milkshake', label = 'Milkshake', price = 12, image = 'burger_milkshake.png'},
    ['burger_fries'] = {name = 'burger_fries', label = 'French Fries', price = 10, image = 'burger_fries.png'}
}

-- Debug function
function DebugPrint(message)
    if Config.Debug then
        print('[BURGER SHOT DEBUG] ' .. tostring(message))
    end
end