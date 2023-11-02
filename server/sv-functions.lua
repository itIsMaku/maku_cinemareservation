function hasPermissions(client)
    local player = esx.GetPlayerFromId(client)
    if player == nil then
        return false
    end

    local job = player.job
    if Config.Management.Job ~= job.name then
        return false
    end

    local grade = job.grade_name
    for _, possibleGrade in ipairs(Config.Management.Grades) do
        if grade == possibleGrade then
            return true
        end
    end

    return false
end

function notify(client, text, type)
    local player = esx.GetPlayerFromId(client)
    if player == nil then
        return false
    end

    player.showNotification(text, type)
end

function identifier(client)
    local player = esx.GetPlayerFromId(client)
    if player == nil then
        return false
    end

    return player.identifier
end

function hasMoney(client, amount)
    local player = esx.GetPlayerFromId(client)
    if player == nil then
        return false
    end

    return player.getAccount('bank').money >= amount
end

function removeMoney(client, amount)
    local player = esx.GetPlayerFromId(client)
    if player == nil then
        return false
    end

    player.removeAccountMoney('bank', amount)
end

function giveTicket(client, movie, theatre, row, seat)
    local player = esx.GetPlayerFromId(client)
    if player == nil then
        return false
    end

    player.addInventoryItem('cinematicket', 1, {
        movie = movie,
        theatre = theatre,
        description = string.format('Film: %s\nSál: %s\nŘada: %s\nSedadlo: %s', movie, theatre, row, seat)
    })
end
