local orm = {}
local storage = {}

// TODO: Persist datas

/*
    CONST
*/
local ERROR_MESSAGE_UNVALID_REASON = "Unvalid reason"
local ERROR_MESSAGE_UNVALID_MESSAGE = "Unvalid message"
local ERROR_MESSAGE_UNKNOWN_TICKET = "Unknown ticket"

// TODO: Created_at, Author, Set a gravity by the reason (freekill -> important, help -> low, ...)
function orm.new(reason, message)
    local self = cosmticket
    local utils = cosmticket.Utils
    if (not utils.IsValidString(reason)) then
        return false, ERROR_MESSAGE_UNVALID_REASON
    end

    if (not utils.IsValidString(message)) then
        return false, ERROR_MESSAGE_UNVALID_MESSAGE
    end

    local ticket_id = #storage +1
    local ticket = {
        ["id"] = ticket_id,
        ["reason"] = reason,
        ["message"] = message
    }
    storage[ticket_id] = ticket

    return ticket
end

function orm.get(id)
    local ticket = storage[id]
    return ticket != nil && ticket or false
end

function orm.delete(id)
    local ticket = orm.get(id)
    if (!ticket) then
        return false, ERROR_MESSAGE_UNKNOWN_TICKET
    end

    table.remove(storage, id)
end

function orm.update(id, reason, message)
    local ticket = orm.get(id)
    if (!ticket) then
        return false, ERROR_MESSAGE_UNKNOWN_TICKET
    end

    storage[id] = {
        ["reason"] = reason,
        ["message"] = message
    }
end

cosmticket.Tickets = orm