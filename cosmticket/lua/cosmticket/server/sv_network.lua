util.AddNetworkString("cosmticket:Submit")
util.AddNetworkString("cosmticket:EmitTicket")
util.AddNetworkString("cosmticket:Take")



local function myScriptIsAdmin(toCheck)
    if (!IsValid(toCheck) || !toCheck:IsPlayer()) then return false end

    return cosmticket.Config.adminUsergroup[toCheck:GetUserGroup()]
end

local function myScriptGetOnlineAdmins()
    local admins = {}
    for _, target in ipairs(player.GetAll()) do
        if myScriptIsAdmin(target) then
            admins[#admins + 1] = target
        end
    end
    return admins
end

net.Receive("cosmticket:Submit", function (len, creator)
	local raison = net.ReadString()
	local gravity = net.ReadString()
	local desc = net.ReadString()	

    cosmticket.Ticket = cosmticket.Ticket or {}

    local id = table.insert(cosmticket.Ticket, { ["Author"] = creator})

	local onlineAdmins = myScriptGetOnlineAdmins()
	net.Start("cosmticket:EmitTicket")
    net.WriteEntity(creator)
    net.WriteString(gravity)
    net.WriteString(raison)
	net.WriteString(desc)
    net.WriteInt(id, 32)
    net.Send(onlineAdmins)
end)


net.Receive("cosmticket:Take", function(_, ply)
    local id = net.ReadInt(32)

    local noti = cosmticket.Ticket[id]
    if not noti then return end

    if not IsValid(noti.Author) or not noti.Author:IsPlayer() then return end
    DarkRP.notify(noti.Author, 0, 4, cosmticket.Config.Notification)


end)
