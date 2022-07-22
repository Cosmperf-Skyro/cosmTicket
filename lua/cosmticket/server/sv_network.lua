util.AddNetworkString("cosmticket:Submit")
util.AddNetworkString("cosmticket:EmitTicket")
util.AddNetworkString("cosmticket:Take")
util.AddNetworkString("cosmticket:Salle")
util.AddNetworkString("cosmticket:BookedRoom")

local self = cosmticket
local utils = self.Utils
local Tickets = self.Tickets
local Rooms = self.Rooms

net.Receive("cosmticket:Submit", function(len, author)
	local reason = net.ReadString()
	local description = net.ReadString()	

    if (not utils.IsValidString(reason)
        or not utils.IsValidString(description)) then
            utils.Notify("Les champs saisis sont incorrect !", author)
        return
    end

    cosmticket.Controller.OnSubmitTicket(reason, description, author)
end)


net.Receive("cosmticket:Take", function(_, sender)
    local id = net.ReadInt(14)

    if (not utils.IsAdmin(sender)) then
        // TODO: Log -> Try to hack | Severity : Important
        return
    end

    local ticket = Tickets.get(id)
    if (!ticket) then 
        // TODO: Log -> Tried to access unknown ticket | Severity : Low
        return 
    end

    cosmticket.Controller.OnTicketTake(ticket, sender)
end)

net.Receive("cosmticket:Salle", function(_, sender)
    local room_id = net.ReadInt(14)

    local room = Rooms.get(room_id)
    if (!room) then
        print("not room")
        // TODO: Log -> Try to hack | Severity : Important
        return
    end

    if (room["admin"] ~= sender) then
        print("admin != sender")
        // TODO: Log -> Try to hack | Severity : Important
        return
    end

    local ok, message = Rooms.teleportTo(room_id)
    if (!ok) then
        utils.Notify(message, sender)
    end
end)
