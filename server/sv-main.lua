esx = exports.es_extended:getSharedObject()
local blockedSeats = {}

RegisterNetEvent('maku_cinemareservation:setCurrentMovie', function(theatre, movie)
    local client = source
    if not hasPermissions(client) then
        notify(client, 'Nemůžeš ovládat správu kina.', 'error')
        return
    end

    setCurrentMovie(theatre, movie)
    setReservation(theatre, {})
    blockedSeats[theatre] = {}
    notify(client, 'Úspěšně jsi nastavil film.', 'success')
end)

RegisterNetEvent('maku_cinemareservation:requestInformations', function(theatre)
    local client = source
    if Config.Theatres[theatre] == nil then
        return
    end

    local reservation = getReservation(theatre)
    if reservation == nil then
        reservation = {
            tickets = {}
        }
    end
    if reservation.tickets == nil then
        reservation.tickets = {}
    end

    local currentMovie = getCurrentMovie(theatre)
    if currentMovie == nil then
        notify(client, 'V tomto sále se právě nic nehraje.', 'error')
        return
    end

    local price = getPrice(theatre)
    if price == nil then
        price = 0
    end

    TriggerClientEvent('maku_cinemareservation:receiveInformations', client, theatre, reservation, currentMovie, price)
end)


RegisterNetEvent('maku_cinemareservation:reserveTickets', function(tickets, theatre)
    local client = source
    if blockedSeats[theatre] == nil then
        blockedSeats[theatre] = {}
    end

    local seatsCount = 0
    local block = false
    for rowId, row in pairs(tickets) do
        for seatId, seat in pairs(row) do
            seatsCount = seatsCount + 1
            if blockedSeats[theatre][tostring(rowId)] ~= nil and blockedSeats[theatre][tostring(rowId)][tostring(seatId)] then
                block = true
            end
        end
    end

    if block then
        notify(client,
            'Někdo jiný si právě zakoupil lístky na jednom z vybraných míst. Zkus to prosím znovu.',
            'error')
        return
    end

    local basePrice = getPrice(theatre)
    if basePrice == nil then
        basePrice = 0
    end

    local price = basePrice * seatsCount
    if not hasMoney(client, price) then
        notify(client, 'Nemáš dostatek peněz na účtě na nákup lístků.', 'error')
        return
    end

    removeMoney(client, price)

    TriggerEvent('esx_addonaccount:getSharedAccount', Config.Society, function(account)
        if account == nil then
            notify(client, 'Chyba při připisování peněz do kasy.', 'error')
            return
        end
        account.addMoney(price)
    end)

    for rowId, row in pairs(tickets) do
        for seatId, seat in pairs(row) do
            if blockedSeats[theatre][tostring(rowId)] == nil then
                blockedSeats[theatre][tostring(rowId)] = {}
            end
            blockedSeats[theatre][tostring(rowId)][tostring(seatId)] = true
        end
    end

    local reservation = getReservation(theatre)
    if reservation == nil then
        reservation = {
            tickets = {}
        }
    end

    if reservation.tickets == nil then
        reservation.tickets = {}
    end

    local movie = getCurrentMovie(theatre)
    local identifier = identifier(client)
    for rowId, row in pairs(tickets) do
        if reservation.tickets[tostring(rowId)] == nil then
            reservation.tickets[tostring(rowId)] = {}
        end

        for seatId, seat in pairs(row) do
            reservation.tickets[tostring(rowId)][tostring(seatId)] = identifier
            blockedSeats[theatre][tostring(rowId)][tostring(seatId)] = nil
            giveTicket(client, movie, theatre, rowId, seatId)
        end
    end

    setReservation(theatre, reservation)
    notify(client, 'Úspěšně jsi si zakoupil lístky.', 'success')
end)

RegisterNetEvent('maku_cinemareservation:setPrice', function(theatre, price)
    local client = source
    if not hasPermissions(client) then
        notify(client, 'Nemůžeš ovládat správu kina.', 'error')
        return
    end

    if type(price) ~= "number" then
        notify(client, 'Cena musí být číslo.', 'error')
        return
    end

    setPrice(theatre, price)
    notify(client, 'Úspěšně jsi nastavil cenu.', 'success')
end)
