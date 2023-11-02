function openCinemaTicketsMenu(theatre, movie, reservedSeats, price)
    toggleNuiFrame(true)
    SendReactMessage('showSelection', {
        grid = {
            rows = generateRowsByPattern(Config.Theatres[theatre].Pattern, reservedSeats, theatre, price)
        },
        movie = movie,
        theatre = theatre
    })
end

function generateRowsByPattern(pattern, reservedTickets, theatre, price)
    local rows = {}
    local blanks = 0
    for _, rawRow in ipairs(pattern) do
        local nonBlankSeats = 0
        local row = {
            id = #rows + 1,
            seats = {},
            blank = false
        }
        for i = 1, #rawRow do
            local char = rawRow:sub(i, i)
            local space = char == '-'
            if space then
                table.insert(row.seats, {
                    id = 'blank_' .. (blanks + 1),
                    row = row.id,
                    reserved = false,
                    blank = true
                })
                blanks = blanks + 1
            else
                local seatId = nonBlankSeats + 1
                table.insert(row.seats, {
                    id = seatId,
                    row = row.id,
                    reserved = reservedTickets.tickets[tostring(row.id)] ~= nil and
                        reservedTickets.tickets[tostring(row.id)][tostring(seatId)] ~= nil,
                    blank = false,
                    selected = false,
                    price = price
                })
                nonBlankSeats = nonBlankSeats + 1
            end
        end
        table.insert(rows, row)
    end
    return rows
end

function openTheatresMenu()
    local elements = {}
    for theatreId, theatre in pairs(Config.Theatres) do
        table.insert(elements, {
            label = theatre.Name,
            value = theatreId
        })
    end
    esx.UI.Menu.Open('default', GetCurrentResourceName(), 'cinema', {
        align = 'right',
        title = 'Výběr sálů',
        elements = elements
    }, function(data, menu)
        menu.close()
        local theatre = data.current.value
        TriggerServerEvent('maku_cinemareservation:requestInformations', theatre)
    end, function(data, menu)
        menu.close()
    end)
end

function openManagementTheatresMenu()
    local elements = {}
    for theatreId, theatre in pairs(Config.Theatres) do
        table.insert(elements, {
            label = 'Nastavit film sálu ' .. theatre.Name,
            type = 'set',
            value = theatreId
        })
        table.insert(elements, {
            label = 'Nastavit cenu lístku sálu ' .. theatre.Name,
            type = 'price',
            value = theatreId
        })
        table.insert(elements, {
            label = 'Smazat film sálu ' .. theatre.Name,
            type = 'delete',
            value = theatreId
        })
    end
    esx.UI.Menu.Open('default', GetCurrentResourceName(), 'cinema_edit', {
        align = 'right',
        title = 'Správa sálu',
        elements = elements
    }, function(data, menu)
        menu.close()
        if data.current.type == 'set' then
            esx.UI.Menu.Open('dialog', GetCurrentResourceName(), 'cinema_movie', {
                title = 'Nastavení filmu'
            }, function(data2, menu2)
                menu2.close()
                local movie = data2.value
                if movie == nil or movie == '' then
                    notify('Musíš zadat název filmu.', 'error')
                    return
                end
                TriggerServerEvent('maku_cinemareservation:setCurrentMovie', data.current.value, movie)
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.type == 'price' then
            esx.UI.Menu.Open('dialog', GetCurrentResourceName(), 'cinema_price', {
                title = 'Nastavení ceny'
            }, function(data2, menu2)
                menu2.close()
                local price = data2.value
                if price == nil or price == '' then
                    notify('Musíš zadat cenu.', 'error')
                    return
                end
                TriggerServerEvent('maku_cinemareservation:setPrice', data.current.value, tonumber(price))
            end, function(data2, menu2)
                menu2.close()
            end)
        else
            TriggerServerEvent('maku_cinemareservation:setCurrentMovie', data.current.value, nil)
        end
    end, function(data, menu)
        menu.close()
    end)
end
