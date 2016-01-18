
ENT.PrintName		= "Melon Cannon"
ENT.Author			= "TB002"

if SERVER then
   AddCSLuaFile("shared.lua")
end

if CLIENT then
  
end


ENT.Type = "anim"
ENT.Model = Model("models/hunter/misc/sphere075x075.mdl")



function ENT:Initialize()
    self:SetModel(self.Model)

   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
   end
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_BBOX)
   self:SetCollisionGroup(COLLISION_GROUP_WORLD)
   self:SetColor(Color(0,0,0,0))
   self:SetRenderMode( RENDERMODE_TRANSALPHA )
 
end

function ENT:Think()

	if SERVER then
		if GAMEMODE.minigameactive then
			local mycannons = ents.FindByClass( "minigame_meloncannon" )
			if #mycannons == 3 then
			local launcher = table.Random( mycannons )
			launcher:SetColor( Color( 0, 255, 0 ) )
			launcher:EmitSound( "buttons/button19.wav" )
			timer.Simple( .45, function()
				if IsValid( launcher ) then
					launcher:MelonFire()
				end
			end)
			end
		else
			if IsValid( self ) then
				self:Remove()
			end
		end
		
		self:NextThink( CurTime() + 0.5 )
		return true
	end

end 
 

