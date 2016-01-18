
ENT.PrintName		= "Melon Cannon"
ENT.Author			= "TB002"

if SERVER then
   AddCSLuaFile("shared.lua")
end

if CLIENT then
  
end


ENT.Type = "anim"
ENT.Model = Model("models/props_trainstation/trashcan_indoor001a.mdl")



function ENT:Initialize()
   self:SetModel(self.Model)
self:SetMaterial( "models/shiny" )
   
   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
   end
   self:SetMoveType(MOVETYPE_NONE)
   self:SetSolid(SOLID_BBOX)

   if SERVER then
      self:SetUseType(SIMPLE_USE)
   end
   
   self:EmitSound( "npc/scanner/scanner_combat_loop1.wav" )
self:SetColor( Color( 255, 0, 0 ) )
 
end

function ENT:MelonFire()

	if SERVER then
		if IsValid( self ) then
			self:EmitSound( "weapons/physcannon/superphys_launch2.wav" )
			local mypos = self:GetPos() + (self:GetAngles():Forward() * 10) + Vector(0,0, 15)
	
			local melon = ents.Create( "prop_physics" )
				melon:SetModel( "models/props_junk/watermelon01.mdl" )
				melon:SetPos( mypos )
				melon:Spawn()
				melon:GetPhysicsObject():EnableGravity( false )
				melon:GetPhysicsObject():ApplyForceCenter( ( self:GetAngles():Forward()  * 12000 ) )
				melon:SetColor( Color( math.random( 155,255), math.random( 155,255), math.random( 155,255) ) )
			self:SetColor( Color( 255, 0, 0 ) )
				
			timer.Simple( 8.5, function() SpecialExplodeMelon( melon ) end )
		end
	end

end 
 
function SpecialExplodeMelon( mel )

	if SERVER then
		if IsValid( mel ) then		
			mel:Remove()
		end
	end

end


