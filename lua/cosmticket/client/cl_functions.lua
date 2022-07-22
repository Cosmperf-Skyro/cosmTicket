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


function admin_sphere()
	hook.Add( "PostDrawTranslucentRenderables", "cosmticket:Sphere", function()

		-- Set the draw material to solid white
		render.SetColorMaterial()
	
		-- The position to render the sphere at, in this case, the looking position of the local player
	
		local radius = 300
		local wideSteps = 10
		local tallSteps = 100
	
		-- Draw the sphere!
		render.DrawSphere( salle_pos, radius, wideSteps, tallSteps, Color( 0, 175, 175, 0 ) )
	
		-- Draw the wireframe sphere!
		render.DrawWireframeSphere( salle_pos, radius, wideSteps, tallSteps, Color( 255, 255, 255, 255 ) )
	end )
end