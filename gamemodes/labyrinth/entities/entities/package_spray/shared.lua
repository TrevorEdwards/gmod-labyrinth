
ENT.PrintName		= "Spray Package"
ENT.Author			= "TB002"

if SERVER then
   AddCSLuaFile("shared.lua")
end

if CLIENT then
  
end


ENT.Type = "anim"
ENT.Model = Model("models/props_c17/BriefCase001a.mdl")



function ENT:Initialize()
   self:SetModel(self.Model)
	self:SetMaterial( "models/shiny" )

   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
   end
   self:SetMoveType(MOVETYPE_NONE)
   self:SetSolid(SOLID_BBOX)
   self:SetColor(Color(0,255,0))

   if SERVER then
      self:SetUseType(SIMPLE_USE)
   end
   
   self:EmitSound( "vehicles/APC/apc_idle1.wav" )

end

function ENT:StartTouch( ply )

	if SERVER then
	if IsValid ( ply ) and ply:IsPlayer() then
		if GetRole( ply ) == 1 then
			if ply:HasWeapon( "pepperspray" ) then
				printPlayer( ply, "You already have pepper spray!" )
			else
				ply:Give( "pepperspray" )
				printPlayer( ply, "Picked up pepper spray!" )
				if IsValid( self ) then
					sound.Play( "HL1/fvox/blip.wav", self:GetPos(), 75, 100, 1 )
					self:Remove()
				end
			end
		else
			printPlayer( ply, "Someone dropped pepper spray here.  How silly!" )
		end
		end
		
	end
end


function ENT:Think()

	local colmod = math.abs( math.sin( CurTime() * 2 ) ) * 240 + 2
	self:SetColor( Color( 0, colmod, 0, 255 ) )

	if SERVER then
		self:SetAngles( self:GetAngles() + Angle(0,6,0) )
		self:NextThink( CurTime() + .1 )
		return true
	end
end
