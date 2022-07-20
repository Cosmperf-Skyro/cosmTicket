util.AddNetworkString("cosmticket:Submit")
util.AddNetworkString("cosmticket:EmitTicket")
util.AddNetworkString("cosmticket:Take")

net.Receive("cosmticket:Submit", function(len, ticketAuthor)
	local reason = net.ReadString()
	local description = net.ReadString()	

    local self = cosmticket
    local utils = self.Utils
    local Tickets = self.Tickets

    if (not utils.IsValidString(reason)
        or not utils.IsValidString(description)) then
            utils.Notify("Les champs saisis sont incorrect !", ticketAuthor)
        return
    end

    local ticket, message = Tickets.new(reason, description)
    if (!ticket) then
        utils.Notify(message, ticketAuthor)
        return
    end

    utils.Notify("Ticket créé, vous serez pris en charge sous peu !", ticketAuthor)

    // Emit ticket to admins
	net.Start("cosmticket:EmitTicket")
        utils.WriteTicket(ticket)
    net.Send(utils.GetOnlineAdmins())
end)


net.Receive("cosmticket:Take", function(_, sender)
    local id = net.ReadInt(32)

    local self = cosmticket
    local Utils = cosmticket.Utils

    if (not Utils.IsAdmin(sender)) then
        // TODO: Log -> Try to hack | Severity : Important
        return
    end

    local Tickets = cosmticket.Tickets

    local ticket = Tickets.get(id)
    if (!ticket) then 
        // TODO: Log -> Tried to access unknown ticket | Severity : Low
        return 
    end
end)
