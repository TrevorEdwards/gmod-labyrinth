
ENT.PrintName		= "Weapon Package"
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

   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
   end
   self:SetMoveType(MOVETYPE_NONE)
   self:SetSolid(SOLID_BBOX)
   self:SetCollisionGroup(COLLISION_GROUP_WORLD)

   if SERVER then
      self:SetUseType(SIMPLE_USE)
   end
   
	self:EmitSound( "vehicles/APC/apc_idle1.wav" )

end

function ENT:Use( ply )

	if SERVER then
		if GetRole( ply ) == ROLE_PLAYER then
			ply:SetupHands()
			ply:Give( "weapon_crowbar" )
			sound.Play( "HL1/fvox/bell.wav", self:GetPos(), 75, 100, 1 )
			self:Remove()
		else
			printPlayer( ply, "Somebody dropped a crowbar here.  How silly!" )
		end
	end

end


function ENT:Think()

	local colmod = math.abs( math.sin( CurTime() * 2 ) ) * 240 + 2
	self:SetColor( Color( colmod, colmod, colmod, 255 ) )

	if SERVER then
		self:SetAngles( self:GetAngles() + Angle(0,6,0) )
		self:NextThink( CurTime() + .1 )
		return true
	end
end

