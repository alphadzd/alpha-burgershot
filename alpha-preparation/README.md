### 1. Add Items to QBCore Shared Items

Add the following items to your `qb-core/shared/items.lua` file:

```lua
-- Burger Ingredients
['burger_bun'] = {['name'] = 'burger_bun', ['label'] = 'Burger Bun', ['weight'] = 50, ['type'] = 'item', ['image'] = 'burger_bun.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Burger bun for making burgers'},
['burger_patty'] = {['name'] = 'burger_patty', ['label'] = 'Beef Patty', ['weight'] = 100, ['type'] = 'item', ['image'] = 'burger_patty.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Beef patty for burgers'},
['burger_vegpatty'] = {['name'] = 'burger_vegpatty', ['label'] = 'Vegetable Patty', ['weight'] = 100, ['type'] = 'item', ['image'] = 'burger_vegpatty.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Vegetable patty for meat-free burgers'},
['burger_lettuce'] = {['name'] = 'burger_lettuce', ['label'] = 'Lettuce', ['weight'] = 25, ['type'] = 'item', ['image'] = 'burger_lettuce.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Fresh lettuce for burgers'},
['burger_tomato'] = {['name'] = 'burger_tomato', ['label'] = 'Tomato', ['weight'] = 25, ['type'] = 'item', ['image'] = 'burger_tomato.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Sliced tomato for burgers'},
['burger_cheese'] = {['name'] = 'burger_cheese', ['label'] = 'Cheese Slice', ['weight'] = 25, ['type'] = 'item', ['image'] = 'burger_cheese.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Cheese slice for burgers'},
['burger_onion'] = {['name'] = 'burger_onion', ['label'] = 'Onion', ['weight'] = 25, ['type'] = 'item', ['image'] = 'burger_onion.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Sliced onion for burgers'},
['burger_bacon'] = {['name'] = 'burger_bacon', ['label'] = 'Bacon', ['weight'] = 40, ['type'] = 'item', ['image'] = 'burger_bacon.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Crispy bacon for burgers'},
['burger_potato'] = {['name'] = 'burger_potato', ['label'] = 'Potato', ['weight'] = 100, ['type'] = 'item', ['image'] = 'burger_potato.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Raw potato for making fries'},
['burger_oil'] = {['name'] = 'burger_oil', ['label'] = 'Cooking Oil', ['weight'] = 50, ['type'] = 'item', ['image'] = 'burger_oil.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Cooking oil for frying'},
['burger_cup'] = {['name'] = 'burger_cup', ['label'] = 'Cup', ['weight'] = 10, ['type'] = 'item', ['image'] = 'burger_cup.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Empty cup for drinks'},
['burger_syrup'] = {['name'] = 'burger_syrup', ['label'] = 'Soda Syrup', ['weight'] = 50, ['type'] = 'item', ['image'] = 'burger_syrup.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Syrup for making soda'},
['burger_milk'] = {['name'] = 'burger_milk', ['label'] = 'Milk', ['weight'] = 50, ['type'] = 'item', ['image'] = 'burger_milk.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Milk for making milkshakes'},
['burger_icecream'] = {['name'] = 'burger_icecream', ['label'] = 'Ice Cream', ['weight'] = 75, ['type'] = 'item', ['image'] = 'burger_icecream.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Ice cream for making milkshakes'},

-- Cooking Utensils
['cookingpan'] = {['name'] = 'cookingpan', ['label'] = 'Cooking Pan', ['weight'] = 200, ['type'] = 'item', ['image'] = 'cookingpan.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Used for cooking food'},
['kitchenknife'] = {['name'] = 'kitchenknife', ['label'] = 'Kitchen Knife', ['weight'] = 100, ['type'] = 'item', ['image'] = 'kitchenknife.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Used for cutting ingredients'},
['mixingbowl'] = {['name'] = 'mixingbowl', ['label'] = 'Mixing Bowl', ['weight'] = 150, ['type'] = 'item', ['image'] = 'mixingbowl.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Used for mixing ingredients'},

-- Cooked Items
['burger'] = {['name'] = 'burger', ['label'] = 'Regular Burger', ['weight'] = 200, ['type'] = 'item', ['image'] = 'burger.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'A delicious regular burger'},
['burger_deluxe'] = {['name'] = 'burger_deluxe', ['label'] = 'Deluxe Burger', ['weight'] = 250, ['type'] = 'item', ['image'] = 'burger_deluxe.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'A delicious deluxe burger with bacon'},
['burger_veggie'] = {['name'] = 'burger_veggie', ['label'] = 'Veggie Burger', ['weight'] = 200, ['type'] = 'item', ['image'] = 'burger_veggie.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'A delicious vegetarian burger'},
['burger_soda'] = {['name'] = 'burger_soda', ['label'] = 'Soda', ['weight'] = 100, ['type'] = 'item', ['image'] = 'burger_soda.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'A refreshing soda'},
['burger_milkshake'] = {['name'] = 'burger_milkshake', ['label'] = 'Milkshake', ['weight'] = 150, ['type'] = 'item', ['image'] = 'burger_milkshake.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'A delicious milkshake'},
['burger_fries'] = {['name'] = 'burger_fries', ['label'] = 'French Fries', ['weight'] = 125, ['type'] = 'item', ['image'] = 'burger_fries.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Crispy french fries'},
```