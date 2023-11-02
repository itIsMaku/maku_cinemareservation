function getCurrentMovies()
    local raw = GetResourceKvpString(THEATRE_MOVIES_KVP_KEY)
    if raw == nil or raw == '' then
        return {}
    end
    local movies = json.decode(raw)
    return movies
end

function getCurrentMovie(theatre)
    local movies = getCurrentMovies()
    return movies[theatre]
end

function setCurrentMovies(movies)
    local raw = json.encode(movies)
    SetResourceKvp(THEATRE_MOVIES_KVP_KEY, raw)
end

function setCurrentMovie(theatre, movie)
    local movies = getCurrentMovies()
    movies[theatre] = movie
    setCurrentMovies(movies)
end

function getReservations()
    local raw = GetResourceKvpString(RESERVED_SEATS_KVP_KEY)
    if raw == nil or raw == '' then
        return {}
    end
    local reservations = json.decode(raw)
    return reservations
end

function getReservation(theatre)
    local reservations = getReservations()
    return reservations[theatre]
end

function setReservations(reservations)
    local raw = json.encode(reservations)
    SetResourceKvp(RESERVED_SEATS_KVP_KEY, raw)
end

function setReservation(theatre, reservation)
    local reservations = getReservations()
    reservations[theatre] = reservation
    setReservations(reservations)
end

function getPrices()
    local raw = GetResourceKvpString(THEATRE_PRICES_KVP_KEY)
    if raw == nil or raw == '' then
        return {}
    end
    local prices = json.decode(raw)
    return prices
end

function getPrice(theatre)
    local prices = getPrices()
    return prices[theatre] or 0
end

function setPrices(prices)
    local raw = json.encode(prices)
    SetResourceKvp(THEATRE_PRICES_KVP_KEY, raw)
end

function setPrice(theatre, price)
    local prices = getPrices()
    prices[theatre] = price
    setPrices(prices)
end
