hook.Add("OnPlayerChat", "panelOpen", function(ply, strText, bTeam, bDead)
	if (ply != LocalPlayer()) then return end

	strText = string.lower( strText )

	if ( strText == cosmticket.Config.Command ) then
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
		local gravity = vgui.Create("DComboBox", main)
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
			net.WriteString(gravity:GetValue())
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

		gravity:SetSize(respW(250), respH(45))
		gravity:SetPos(respW(325), respH(90))
		gravity:SetTextColor(color_white)
		gravity:SetFont("trebuchet24")
		gravity:SetValue("Gravité")
		for k, v in pairs(cosmticket.Config.Gravity) do
			gravity:AddChoice(v)
		end

		function gravity:Paint(w, h)
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
		
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------
		------------------------------------------------------------------

		net.Receive("cosmticket:EmitTicket", function()
			local creator = net.ReadEntity()
			local gravity = net.ReadString()
			local raison = net.ReadString()
			local desc = net.ReadString()
			local id = net.ReadInt(32)
		
			if (!IsValid(creator) || !creator:IsPlayer()) then return end
		
			ticket(creator, gravity, raison, desc, id)
		end)

		function ticket(creator, gravity, raison, desc, id)
			local ticket = vgui.Create("DFrame", DScrollPanel)
			ticket:SetSize(respW(400), respH(250))
			ticket:SetPos(respW(10), respH(10))
			ticket:SetTitle("")
			ticket:SetDraggable(true)
			ticket:ShowCloseButton(false)
			surface.PlaySound("garrysmod/balloon_pop_cute.wav")

			function ticket:Paint(w, h)
				draw.RoundedBox(30, 0, 0, w, h, cosmticket.Config.Color)				
				draw.RoundedBox(0, 0, respH(50), w, respH(3), color_white)
				draw.SimpleText("Gravité : "..gravity, "trebuchet24", respW(30), respH(170), color_white, TEXT_ALIGN_LEFT)
				draw.SimpleText("Raison : "..raison, "trebuchet24", respW(30), respH(200), color_white, TEXT_ALIGN_LEFT)
			end

			local toppanel = vgui.Create("DPanel", ticket)
			toppanel:SetSize(ScrW(), respH(30))
			toppanel:SetPos(respW(0), respH(5))

			function toppanel:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,0))
				draw.SimpleText("Ticket de - "..creator:Nick(), "trebuchet24", respW(25), respH(10), color_white, TEXT_ALIGN_LEFT)
			end

			local rs = vgui.Create("DPanel", ticket)
			rs:SetSize(respW(250), respH(100))
			rs:SetPos(respW(10), respH(60))
			function rs:Paint(w, h)
				draw.RoundedBox(30, 0, 0, w, h, cosmticket.Config.ColorButton)
				draw.SimpleText(desc, "trebuchet18", respW(15), respH(5), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
			end

			local pticket = vgui.Create("DPanel", ticket)
			pticket:SetSize(respW(100), respH(150))
			pticket:SetPos(respW(280), respH(60))
			function pticket:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,0))
			end

			local cl = vgui.Create("DButton", pticket)
			cl:SetSize(ScrW(), respH(30))
			cl:SetPos(respW(0), respH(120))
			function cl:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, cosmticket.Config.ColorButton)
				draw.SimpleText("Fermer", "trebuchet24", respW(50), respH(2), color_white, TEXT_ALIGN_CENTER)
			end
			function cl:DoClick()
				ticket:Close()
			end


			local take = vgui.Create("DButton", pticket)
			take:SetSize(ScrW(), respH(30))
			take:SetPos(respW(0), respH(0))
			function take:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, cosmticket.Config.ColorButton)
				draw.SimpleText("Prendre", "trebuchet24", respW(50), respH(2), color_white, TEXT_ALIGN_CENTER)
			end
			function take:DoClick()
				take:Remove()
				net.Start("cosmticket:Take")
				net.WriteInt(id, 32)
				net.SendToServer()
				
				local go = vgui.Create("DButton", pticket)
				go:SetSize(ScrW(), respH(30)) 
				go:SetPos(respW(0), respH(0))
				function go:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, cosmticket.Config.ColorButton)
					draw.SimpleText("Aller", "trebuchet24", respW(50), respH(2), color_white, TEXT_ALIGN_CENTER)
				end
				function go:DoClick()
					RunConsoleCommand("say", "!goto "..creator:SteamID())
				end

				local ret = vgui.Create("DButton", pticket)
				ret:SetSize(ScrW(), respH(30)) 
				ret:SetPos(respW(0), respH(40))
				function ret:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, cosmticket.Config.ColorButton)
					draw.SimpleText("Retourner", "trebuchet24", respW(50), respH(2), color_white, TEXT_ALIGN_CENTER)
				end
				function ret:DoClick()
					RunConsoleCommand("say", "!return "..creator:SteamID())
				end

				local tp = vgui.Create("DButton", pticket)
				tp:SetSize(ScrW(), respH(30)) 
				tp:SetPos(respW(0), respH(80))
				function tp:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, cosmticket.Config.ColorButton)
					draw.SimpleText("Téléporter", "trebuchet24", respW(50), respH(2), color_white, TEXT_ALIGN_CENTER)
				end
				function tp:DoClick()
					RunConsoleCommand("say", "!tp "..creator:SteamID())
				end


			end



			
		end




		return true
	end
end)