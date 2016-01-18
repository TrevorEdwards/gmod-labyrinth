
ENT.PrintName		= "Speed Package"
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
   self:SetColor(Color(255,0,0))

   if SERVER then
      self:SetUseType(SIMPLE_USE)
   end
   
   self:EmitSound( "vehicles/APC/apc_idle1.wav" )

end

function ENT:StartTouch( ply )

	if SERVER then
	if IsValid ( ply ) and ply:IsPlayer() then
		GAMEMODE:SetPlayerSpeed( ply, ply:GetWalkSpeed() + 15, ply:GetRunSpeed() + 25 )
		printPlayer( ply, "Picked up a speed boost!" )
		
		if IsValid( self ) then
			sound.Play( "HL1/fvox/blip.wav", self:GetPos(), 75, 100, 1 )
			self:Remove()
		end
	end
	end
end

function ENT:Think()

	local colmod = math.abs( math.sin( CurTime() * 2 ) ) * 240 + 2
	self:SetColor( Color( colmod, 0, 0, 255 ) )

	if SERVER then
		self:SetAngles( self:GetAngles() + Angle(0,6,0) )
		self:NextThink( CurTime() + .1 )
		return true
	end
end


