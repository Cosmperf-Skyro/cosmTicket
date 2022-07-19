-- Notify a player with the specified message
function cosmticket:Notify(pPlayer, sContent)

	if not IsValid(pPlayer) or not pPlayer:IsPlayer() then return end

	if DarkRP then
		return DarkRP.notify(pPlayer, 0, 7, sContent)
	end

	return pPlayer:PrintMessage(HUD_PRINTTALK, sContent)
	
end