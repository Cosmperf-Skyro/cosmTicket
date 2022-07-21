local controller = {}

local self = cosmticket
local utils = self.Utils
local Tickets = self.Tickets

function controller.OnSubmitTicket(reason, description, author)
    local ticket, message = Tickets.new(reason, description)
    if (!ticket) then
        utils.Notify(message, author)
        return
    end

    utils.Notify("Ticket créé, vous serez pris en charge sous peu !", author)

    // Emit ticket to admins
	net.Start("cosmticket:EmitTicket")
        utils.WriteTicket(ticket)
    net.Send(utils.GetOnlineAdmins())
end

function controller.OnTicketTake(ticket)

end

cosmticket.Controller = controller