hook.Add("OnPlayerChat", "panelOpen", function(ply, strText, bTeam, bDead)
	if (ply != LocalPlayer()) then return end

	strText = string.lower( strText )

	if (strText == cosmticket.Config.Command) then
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		----------------------------Variable------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		local main = vgui.Create("DFrame")
		local quitter = vgui.Create("DButton", main)
		local submit = vgui.Create("DButton", main)
		local raison = vgui.Create("DComboBox", main)
		local desc = vgui.Create("DTextEntry", main)






		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		main:SetSize(respW(600), respH(500))
		main:Center()
		main:SizeIn()
		main:MakePopup()
		main:SetDraggable(false)
		main:SetTitle("")
		function main:Paint(w, h)
			draw.RoundedBox(30, 0, 0, w, h, cosmticket.Config.Color)
			draw.SimpleText("Ouvrir un ticket - "..GetHostName(), "Title", respW(200), respH(20), color_white, TEXT_ALIGN_CENTER)
			draw.RoundedBox(0, 0, respH(65), w, respH(3), color_white)
		end



		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		quitter:SetSize(respW(250), respH(45))
		quitter:SetPos(respW(325), respH(400))
		quitter:SetText("")
		function quitter:Paint(w, h)
			draw.RoundedBox(30, 0, 0, w, h, cosmticket.Config.ColorButton)
			draw.SimpleText("Fermer", "trebuchet24", respW(125), respH(8), color_white, TEXT_ALIGN_CENTER)
		end
		function quitter:DoClick()
			main:Close()
		end

		submit:SetSize(respW(250), respH(45))
		submit:SetPos(respW(25), respH(400))
		submit:SetText("")
		function submit:Paint(w, h)
			draw.RoundedBox(30, 0, 0, w, h, cosmticket.Config.ColorButton)
			draw.SimpleText("Soumettre", "trebuchet24", respW(125), respH(8), color_white, TEXT_ALIGN_CENTER)
		end
		function submit:DoClick()
		net.Start("cosmticket:Submit")
			net.WriteString(raison:GetValue())
			net.WriteString(desc:GetValue())
		net.SendToServer()	
		main:Close()
		end
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------


		raison:SetSize(respW(250), respH(45))
		raison:SetPos(respW(25), respH(90))
		raison:SetTextColor(color_white)
		raison:SetFont("trebuchet24")
		raison:SetValue("Raison")
		for k, v in pairs(cosmticket.Config.Raison) do
			raison:AddChoice(v)
		end

		function raison:Paint(w, h)
			draw.RoundedBox(30, 0, 0, w, h, cosmticket.Config.ColorButton)
		end

		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------

		desc:SetSize(respW(550), respH(225))
		desc:SetPos(respW(25), respH(155))
		desc:SetFont("trebuchet24")
		desc:SetMultiline(true)
		function desc:Paint(w, h)
			draw.RoundedBox(30, 0, 0, w, h, cosmticket.Config.ColorButton)
			self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
		end
	
		return true
	end
end)

local function showTicket(ticket)
	PrintTable(ticket)
	chat.AddText(Color(255, 0, 0), "New ticket received !")
end

net.Receive("cosmticket:EmitTicket", function()
	local self = cosmticket
	local utils = self.Utils

	local ticket = utils.ReadTicket()

	showTicket(ticket)
end)

