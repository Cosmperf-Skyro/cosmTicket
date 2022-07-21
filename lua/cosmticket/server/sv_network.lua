util.AddNetworkString("cosmticket:Submit")
util.AddNetworkString("cosmticket:EmitTicket")
util.AddNetworkString("cosmticket:Take")

local self = cosmticket
local utils = self.Utils
local Tickets = self.Tickets

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
    local id = net.ReadInt(32)

    if (not Utils.IsAdmin(sender)) then
        // TODO: Log -> Try to hack | Severity : Important
        return
    end

    local ticket = Tickets.get(id)
    if (!ticket) then 
        // TODO: Log -> Tried to access unknown ticket | Severity : Low
        return 
    end

    cosmticket.Controller.OnTicketTake(ticket)
end)
