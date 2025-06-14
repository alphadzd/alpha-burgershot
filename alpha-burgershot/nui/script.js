// Shopping cart system
let cart = [];
let cartTotal = 0;

window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.type === 'openMenu') {
        openMenu();
    } else if (data.type === 'openStaffPanel') {
        openStaffPanel();
    } else if (data.type === 'updateOrders') {
        updateOrders(data.orders);
    } else if (data.type === 'updateAcceptedOrders') {
        updateAcceptedOrders(data.acceptedOrders);
    } else if (data.type === 'showNotification') {
        showCustomNotification(data.message, data.notificationType, data.duration);
    } else if (data.type === 'closeStaffPanel') {
        closeStaffPanel();
    }
});

function openMenu() {
    const container = document.getElementById('menu-container');
    const panel = document.querySelector('.menu-panel');
    
    container.classList.remove('hidden');
    panel.classList.add('show');
    panel.classList.remove('hide');
    
    // Reset cart when opening menu
    clearCart();
}

function closeMenu() {
    const container = document.getElementById('menu-container');
    const panel = document.querySelector('.menu-panel');
    const cartPanel = document.getElementById('cart-panel');
    
    panel.classList.add('hide');
    panel.classList.remove('show');
    cartPanel.classList.remove('show');
    
    setTimeout(() => {
        container.classList.add('hidden');
    }, 300);
    
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
}

// Cart functions
function addToCart(itemId, price, name) {
    const existingItem = cart.find(item => item.id === itemId);
    
    if (existingItem) {
        existingItem.quantity += 1;
    } else {
        cart.push({
            id: itemId,
            name: name,
            price: price,
            quantity: 1
        });
    }
    
    updateCartDisplay();
    showNotification(`${name} added to cart!`, 'success');
}

function removeFromCart(itemId) {
    const itemIndex = cart.findIndex(item => item.id === itemId);
    if (itemIndex > -1) {
        cart.splice(itemIndex, 1);
        updateCartDisplay();
    }
}

function updateQuantity(itemId, change) {
    const item = cart.find(item => item.id === itemId);
    if (item) {
        item.quantity += change;
        if (item.quantity <= 0) {
            removeFromCart(itemId);
        } else {
            updateCartDisplay();
        }
    }
}

function clearCart() {
    cart = [];
    cartTotal = 0;
    updateCartDisplay();
}

function updateCartDisplay() {
    const cartCount = document.getElementById('cart-count');
    const cartItems = document.getElementById('cart-items');
    const cartEmpty = document.getElementById('cart-empty');
    const cartTotalElement = document.getElementById('cart-total');
    const placeOrderBtn = document.querySelector('.place-order-btn');
    const confirmOrderBtn = document.getElementById('confirm-order-btn');
    
    if (!cartCount) return; // Elements not loaded yet
    
    // Update cart count
    const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
    cartCount.textContent = totalItems;
    
    // Update cart total
    cartTotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    if (cartTotalElement) cartTotalElement.textContent = cartTotal;
    
    // Update button states
    const hasItems = cart.length > 0;
    if (placeOrderBtn) placeOrderBtn.disabled = !hasItems;
    if (confirmOrderBtn) confirmOrderBtn.disabled = !hasItems;
    
    // Update cart items display
    if (cart.length === 0) {
        if (cartEmpty) cartEmpty.style.display = 'block';
        if (cartItems) cartItems.innerHTML = '';
    } else {
        if (cartEmpty) cartEmpty.style.display = 'none';
        
        if (cartItems) {
            cartItems.innerHTML = cart.map(item => `
                <div class="cart-item">
                    <div class="cart-item-info">
                        <div class="cart-item-name">${item.name}</div>
                        <div class="cart-item-price">$${item.price} each</div>
                    </div>
                    <div class="cart-item-quantity">
                        <button class="quantity-btn" onclick="updateQuantity('${item.id}', -1)">
                            <i class="fas fa-minus"></i>
                        </button>
                        <span class="quantity-display">${item.quantity}</span>
                        <button class="quantity-btn" onclick="updateQuantity('${item.id}', 1)">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                </div>
            `).join('');
        }
    }
}

function toggleCart() {
    const cartPanel = document.getElementById('cart-panel');
    cartPanel.classList.toggle('show');
}

function placeOrder() {
    if (cart.length === 0) {
        showNotification('Your cart is empty!', 'error');
        return;
    }
    
    // Send order to server
    fetch(`https://${GetParentResourceName()}/placeOrder`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            items: cart,
            total: cartTotal
        })
    });
    
    // Show success notification
    showNotification('Order placed successfully! Please wait for staff approval.', 'success');
    
    // Clear cart and close menu
    clearCart();
    toggleCart();
    closeMenu();
}

function confirmOrder() {
    if (cart.length === 0) {
        showNotification('Your cart is empty!', 'error');
        return;
    }
    
    // Send order to server
    fetch(`https://${GetParentResourceName()}/placeOrder`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            items: cart,
            total: cartTotal
        })
    });
    
    // Show success notification
    showNotification('Order placed successfully! Please wait for staff approval.', 'success');
    
    // Clear cart and close menu
    clearCart();
    closeMenu();
}

function showNotification(message, type) {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.innerHTML = `
        <i class="fas ${type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
        <span>${message}</span>
    `;
    
    // Add styles
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'success' ? 'linear-gradient(145deg, #28a745, #218838)' : 'linear-gradient(145deg, #dc3545, #c82333)'};
        color: white;
        padding: 15px 20px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 600;
        box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        z-index: 10000;
        transform: translateX(100%);
        transition: transform 0.3s ease;
    `;
    
    // Add to body
    document.body.appendChild(notification);
    
    // Show notification
    setTimeout(() => {
        notification.style.transform = 'translateX(0)';
    }, 100);
    
    // Remove notification after 3 seconds
    setTimeout(() => {
        notification.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (document.body.contains(notification)) {
                document.body.removeChild(notification);
            }
        }, 300);
    }, 3000);
}

// Custom notification system for Burger Shot
function showCustomNotification(message, type, duration) {
    duration = duration || 5000;
    type = type || 'info';
    
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `burger-notification ${type}`;
    
    // Set icon based on type
    let icon = 'fa-info-circle';
    let bgColor = '#3498db';
    
    switch(type) {
        case 'success':
            icon = 'fa-check-circle';
            bgColor = '#27ae60';
            break;
        case 'error':
            icon = 'fa-exclamation-circle';
            bgColor = '#e74c3c';
            break;
        case 'warning':
            icon = 'fa-exclamation-triangle';
            bgColor = '#f39c12';
            break;
        case 'info':
        default:
            icon = 'fa-info-circle';
            bgColor = '#3498db';
            break;
    }
    
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas ${icon}"></i>
            <span class="notification-text">${message}</span>
        </div>
        <div class="notification-progress"></div>
    `;
    
    // Add styles
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${bgColor};
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        z-index: 10000;
        transform: translateX(100%);
        transition: transform 0.3s ease;
        min-width: 300px;
        max-width: 400px;
        font-family: 'Roboto', sans-serif;
        font-size: 14px;
        margin-bottom: 10px;
    `;
    
    // Style the content
    const content = notification.querySelector('.notification-content');
    content.style.cssText = `
        display: flex;
        align-items: center;
        gap: 10px;
    `;
    
    // Style the progress bar
    const progress = notification.querySelector('.notification-progress');
    progress.style.cssText = `
        position: absolute;
        bottom: 0;
        left: 0;
        height: 3px;
        background: rgba(255,255,255,0.3);
        width: 100%;
        border-radius: 0 0 8px 8px;
    `;
    
    // Add to body
    document.body.appendChild(notification);
    
    // Show notification
    setTimeout(() => {
        notification.style.transform = 'translateX(0)';
    }, 100);
    
    // Animate progress bar
    setTimeout(() => {
        progress.style.transition = `width ${duration}ms linear`;
        progress.style.width = '0%';
    }, 200);
    
    // Remove notification after duration
    setTimeout(() => {
        notification.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (document.body.contains(notification)) {
                document.body.removeChild(notification);
            }
        }, 300);
    }, duration);
}

// Function to handle accepted orders updates
function updateAcceptedOrders(acceptedOrders) {
    // This function can be implemented later for accepted orders panel
    console.log('Accepted orders updated:', acceptedOrders);
}

document.addEventListener('DOMContentLoaded', function() {
    // Initialize cart display
    updateCartDisplay();
});

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeMenu();
        closeStaffPanel();
    }
});

// Staff Panel Functions
function openStaffPanel() {
    const container = document.getElementById('staff-container');
    const panel = container.querySelector('.menu-panel');
    
    container.classList.remove('hidden');
    panel.classList.add('show');
    panel.classList.remove('hide');
    
    // Request current orders
    fetch(`https://${GetParentResourceName()}/getOrders`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
}

function closeStaffPanel() {
    const container = document.getElementById('staff-container');
    const panel = container.querySelector('.menu-panel');
    
    panel.classList.add('hide');
    panel.classList.remove('show');
    
    setTimeout(() => {
        container.classList.add('hidden');
    }, 300);
    
    fetch(`https://${GetParentResourceName()}/closeStaffPanel`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
}

function updateOrders(orders) {
    const ordersContainer = document.getElementById('orders-container');
    const noOrders = document.getElementById('no-orders');
    
    if (!orders || orders.length === 0) {
        noOrders.style.display = 'block';
        // Clear any existing orders
        const existingOrders = ordersContainer.querySelectorAll('.order-item');
        existingOrders.forEach(order => order.remove());
        return;
    }
    
    noOrders.style.display = 'none';
    
    // Clear existing orders
    const existingOrders = ordersContainer.querySelectorAll('.order-item');
    existingOrders.forEach(order => order.remove());
    
    // Add new orders
    orders.forEach(order => {
        const orderElement = createOrderElement(order);
        ordersContainer.appendChild(orderElement);
    });
}

function createOrderElement(order) {
    const orderDiv = document.createElement('div');
    orderDiv.className = 'order-item';
    orderDiv.setAttribute('data-order-id', order.id);
    
    const itemsList = order.items.map(item => `${item.quantity}x ${item.name}`).join(', ');
    
    orderDiv.innerHTML = `
        <div class="order-header">
            <div class="order-id">Order #${order.id}</div>
            <div class="order-time">${order.time}</div>
        </div>
        <div class="order-details">
            <div class="order-customer">Customer: ${order.customerName}</div>
            <div class="order-items">Items: ${itemsList}</div>
            <div class="order-total">Total: $${order.total}</div>
        </div>
        <div class="order-actions">
            <button class="accept-btn" onclick="acceptOrder(${order.id})">
                <i class="fas fa-check"></i>
                Accept
            </button>
            <button class="refuse-btn" onclick="refuseOrder(${order.id})">
                <i class="fas fa-times"></i>
                Refuse
            </button>
        </div>
    `;
    
    return orderDiv;
}

function acceptOrder(orderId) {
    fetch(`https://${GetParentResourceName()}/acceptOrder`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            orderId: orderId
        })
    });
    
    // Remove the order from UI
    const orderElement = document.querySelector(`[data-order-id="${orderId}"]`);
    if (orderElement) {
        orderElement.style.transform = 'translateX(100%)';
        orderElement.style.opacity = '0';
        setTimeout(() => {
            orderElement.remove();
            
            // Check if no orders left
            const remainingOrders = document.querySelectorAll('.order-item');
            if (remainingOrders.length === 0) {
                document.getElementById('no-orders').style.display = 'block';
            }
        }, 300);
    }
}

function refuseOrder(orderId) {
    fetch(`https://${GetParentResourceName()}/refuseOrder`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            orderId: orderId
        })
    });
    
    // Remove the order from UI
    const orderElement = document.querySelector(`[data-order-id="${orderId}"]`);
    if (orderElement) {
        orderElement.style.transform = 'translateX(-100%)';
        orderElement.style.opacity = '0';
        setTimeout(() => {
            orderElement.remove();
            
            // Check if no orders left
            const remainingOrders = document.querySelectorAll('.order-item');
            if (remainingOrders.length === 0) {
                document.getElementById('no-orders').style.display = 'block';
            }
        }, 300);
    }
}