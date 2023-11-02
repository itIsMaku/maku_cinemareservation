esx = exports.es_extended:getSharedObject()

RegisterNUICallback('hideFrame', function(data, cb)
    toggleNuiFrame(false)
    SendReactMessage('clear', {})
    cb({})
end)

RegisterNUICallback('pay', function(data, cb)
    toggleNuiFrame(false)
    SendReactMessage('clear', {})
    local tickets = {}
    for _, seat in ipairs(data.seats) do
        tickets[seat.row] = tickets[seat.row] or {}
        tickets[seat.row][seat.id] = true
    end
    TriggerServerEvent('maku_cinemareservation:reserveTickets', tickets, data.theatre)
    cb('ok')
end)

RegisterNetEvent('maku_cinemareservation:receiveInformations', function(theatre, reservation, currentMovie, price)
    openCinemaTicketsMenu(theatre, currentMovie, reservation, price)
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        if #(coords - Config.Shop.xyz) < 5.0 then
            esx.ShowHelpNotification('~INPUT_CONTEXT~ Otevrit menu')
            if IsControlJustReleased(0, 38) then
                openTheatresMenu()
                Citizen.Wait(500)
            end
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    DeleteEntity(shopPed)
end)

RegisterCommand(Config.Command, function()
    openTheatresMenu()
end)

RegisterCommand('kinoedit', function()
    openManagementTheatresMenu()
end)
