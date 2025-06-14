local QBCore = exports['qb-core']:GetCoreObject()

function ShowNotification(message, type, duration)
    duration = duration or 5000
    type = type or 'info'
    
    SendNUIMessage({
        type = 'showNotification',
        message = message,
        notificationType = type,
        duration = duration
    })
end


RegisterNetEvent('burgershot:showNotification', function(message, type, duration)
    ShowNotification(message, type, duration)
end)