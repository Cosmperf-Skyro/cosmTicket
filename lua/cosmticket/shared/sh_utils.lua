local utils = {}

function utils.IsAdmin(toCheck)
    if (!IsValid(toCheck) || !toCheck:IsPlayer()) then return false end

    return cosmticket.Config.adminUsergroup[toCheck:GetUserGroup()]
end

function utils.GetOnlineAdmins()
    local admins = {}
    for _, target in ipairs(player.GetAll()) do
        if utils.IsAdmin(target) then
            admins[#admins + 1] = target
        end
    end
    return admins
end

function utils.WriteTicket(ticket)
    net.WriteUInt(ticket["id"], 14)
    net.WriteString(ticket["reason"])
    net.WriteString(ticket["message"])
    net.WriteEntity(ticket["author"])
    net.WriteString(ticket["created_at"])
end

function utils.ReadTicket()
    local ticket = {}

    ticket["id"] = net.ReadUInt(14)
    ticket["reason"] = net.ReadString()
    ticket["message"] = net.ReadString()
    ticket["author"] = net.ReadEntity()
    ticket["created_at"] = net.ReadString()
    return ticket
end

function utils.WriteRoom(room)
    net.WriteUInt(room["id"], 14)
    net.WriteVector(room["position"])
end

function utils.ReadRoom()
    local room = {}

    room["id"] = net.ReadUInt(14)
    room["position"] = net.ReadVector()
    return room
end

// VALIDATORS
function utils.IsValidString(toTest)
    if (not isstring(toTest)) then return false end

    toTest = toTest:Trim()
    return toTest:len() > 0
end

function utils.IsValidPlayer(toTest)
    return IsValid(toTest) and toTest:IsPlayer()
end

function utils.Notify(message, target)
    if (not utils.IsValidString(message)) then 
        return
    end

    if SERVER then
        if (not IsValid(target) or not target:IsPlayer()) then 
		    return 
	    end

        if DarkRP then
            DarkRP.notify(target, 0, 7, message)
            return
	    end

	    target:PrintMessage(HUD_PRINTTALK, message)
    else
        notification.AddLegacy(message, NOTIFY_UNDO, 2)
    end

end

cosmticket.Utils = utils