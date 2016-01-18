
ENT.PrintName		= "Light"
ENT.Author			= "TB002"

if SERVER then
   AddCSLuaFile("shared.lua")
end

if CLIENT then
  
end


ENT.Type = "anim"
ENT.Model = Model("models/hunter/misc/sphere1x1.mdl")



function ENT:Initialize()
   self:SetModel(self.Model)

   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
   end
   self:SetMoveType(MOVETYPE_NONE)
   self:SetSolid(SOLID_BBOX)
   self:SetCollisionGroup(COLLISION_GROUP_WORLD)
   self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor( Color( 0, 0, 0, 0 ) )
	self:TurnOn()


end

function ENT:TurnOn()
	if SERVER then
	self.flashlight = ents.Create( "env_projectedtexture" )

		self.flashlight:SetParent( self.Entity )

		-- The local positions are the offsets from parent..
		self.flashlight:SetLocalPos( Vector( 0, 0, -1 ) )
		self.flashlight:SetAngles(  Angle( 90, 0, 0 ) )

		self.flashlight:SetKeyValue( "enableshadows", 0 )
		self.flashlight:SetKeyValue( "farz", 750 )
		self.flashlight:SetKeyValue( "nearz", 4 )
		self.flashlight:SetKeyValue( "lightfov", 120 )

		local c = Color( math.random(100,255), math.random(0,120), math.random(0,120) )
		self.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r, c.g, c.b ) )

	self.flashlight:Spawn()
	end

end

function ENT:ChangeColor( col )
	self.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", col.r, col.g, col.b ) )
end


