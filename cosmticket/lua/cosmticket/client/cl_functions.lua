function respW(pixels, base)
    base = base or 1920
    return ScrW()/(base/pixels)
end
 
function respH(pixels, base)
    base = base or 1080
    return ScrH()/(base/pixels)
end

PANEL = FindMetaTable("Panel")

function PANEL:SizeIn(duration, callback)
	duration = duration or 0.3

	local w, h = self:GetSize()
	self:SetSize(0,0)
	self:SizeTo(w, h, duration, 0, -1, function()
		if callback and isfunction(callback) then
			callback()
		end
	end)

	function self:OnSizeChanger(w, h)
		self:Center()	
	end
end
