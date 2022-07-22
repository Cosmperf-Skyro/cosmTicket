local controller = {}

local self = cosmticket
local utils = self.Utils
local Tickets = self.Tickets
local Rooms = self.Rooms

function controller.OnSubmitTicket(reason, description, author)
    local ticket, message = Tickets.new(reason, description, author)
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

function controller.OnTicketTake(ticket, admin)
    // TODO: Réserver une salle admin
    local room, message = Rooms.takeRoom(admin, ticket["author"])
    if (!room) then
        print(message)
        utils.Notify("Aucune salle d'administration disponible", admin)
    else
        // TODO: Renvoyer la salle à l'admin
        net.Start("cosmticket:BookedRoom")
            utils.WriteRoom(room)
        net.Send(admin)
    end

    // TODO: Prévenir autres admin que ticket pris 
end

cosmticket.Controller = controller