local startingKarma = require 'configs.shared'.startingKarma

local holiday_karma = {}

-- increase holiday karma by amount
function holiday_karma.increaseHolidayKarma(src, amount)
    local state = Player(src).state
    local currentKarma = state and state.holidayKarma or startingKarma
    local newKarma = currentKarma + amount

    state:set('holidayKarma', newKarma, true)

    lib.notify(src, {
        title = 'Holiday Karma',
        description = 'Your holiday karma has increased by ' .. amount .. '. Current karma: ' .. newKarma .. '.',
        type = 'success'
    })

    return newKarma
end

-- decrease holiday karma by amount
function holiday_karma.decreaseHolidayKarma(src, amount)
    local state = Player(src).state
    local currentKarma = state and state.holidayKarma or startingKarma
    local newKarma = currentKarma - amount

    state:set('holidayKarma', newKarma, true)

    lib.notify(src, {
        title = 'Holiday Karma',
        description = 'Your holiday karma has decreased by ' .. amount .. '. Current karma: ' .. newKarma .. '.',
        type = 'error'
    })

    return newKarma
end

-- get holiday karma for player
function holiday_karma.getHolidayKarma(src)
    local state = Player(src).state

    return state and state.holidayKarma or startingKarma
end

-- set holiday karma for player
function holiday_karma.setHolidayKarma(src, amount)
    local state = Player(src).state

    state:set('holidayKarma', amount, true)

    return true
end

return holiday_karma