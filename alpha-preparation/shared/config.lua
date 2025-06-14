Config = {}

Config.PreparationLocation = vector3(-1190.99, -898.8, 13.87)
Config.CookingLocation = vector3(-1195.67, -898.17, 13.89)

Config.RequireJob = true
Config.AllowedJobs = {
    ['burgershot'] = true,
    ['restaurant'] = true,
}

Config.Blip = {
    Enable = true,
    Coords = vector3(-1190.99, -898.8, 13.87),
    Sprite = 106,
    Display = 4,
    Scale = 0.8,
    Color = 5,
    Name = "BurgerShot"
}

Config.Items = {
    FoodItems = {
        {name = 'burger_bun', label = 'Burger Bun', description = 'Burger bun for making burgers'},
        {name = 'burger_patty', label = 'Beef Patty', description = 'Beef patty for burgers'},
        {name = 'burger_vegpatty', label = 'Vegetable Patty', description = 'Vegetable patty for meat-free burgers'},
        {name = 'burger_lettuce', label = 'Lettuce', description = 'Fresh lettuce for burgers'},
        {name = 'burger_tomato', label = 'Tomato', description = 'Sliced tomato for burgers'},
        {name = 'burger_cheese', label = 'Cheese Slice', description = 'Cheese slice for burgers'},
        {name = 'burger_onion', label = 'Onion', description = 'Sliced onion for burgers'},
        {name = 'burger_bacon', label = 'Bacon', description = 'Crispy bacon for burgers'},
        {name = 'burger_potato', label = 'Potato', description = 'Raw potato for making fries'},
        {name = 'burger_oil', label = 'Cooking Oil', description = 'Cooking oil for frying'},
    },
    DrinkItems = {
        {name = 'burger_cup', label = 'Cup', description = 'Empty cup for drinks'},
        {name = 'burger_syrup', label = 'Soda Syrup', description = 'Syrup for making soda'},
        {name = 'burger_milk', label = 'Milk', description = 'Milk for making milkshakes'},
        {name = 'burger_icecream', label = 'Ice Cream', description = 'Ice cream for making milkshakes'},
    },
    Utensils = {
        {name = 'cookingpan', label = 'Cooking Pan', description = 'Used for cooking food'},
        {name = 'kitchenknife', label = 'Kitchen Knife', description = 'Used for cutting ingredients'},
        {name = 'mixingbowl', label = 'Mixing Bowl', description = 'Used for mixing ingredients'},
    }
}