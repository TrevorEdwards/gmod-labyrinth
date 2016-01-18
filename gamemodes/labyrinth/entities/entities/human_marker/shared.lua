
ENT.PrintName		= "Human Marker"
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

   if SERVER then
      self:SetUseType(SIMPLE_USE)
   end

end




