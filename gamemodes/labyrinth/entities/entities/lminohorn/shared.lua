ENT.PrintName		= "lMino Horn"
ENT.Author			= "TB002"
ENT.Model = "models/Gibs/HGIBS_rib.mdl"
ENT.Type = "anim"

if SERVER then
   AddCSLuaFile("shared.lua")
end


function ENT:Initialize()
   self:SetModel( self.Model )
   self:SetMoveType( MOVETYPE_FLY )
   self:SetSolid( SOLID_NONE )
end

function ENT:Draw( )

	ply = self.Owner
	if CLIENT then
		if ply == LocalPlayer() then
			return false
		end
	end
  if not( IsValid( ply ) ) or not ply:Alive() then return end
  bone = ply:LookupBone("ValveBiped.Bip01_Head1") 
  if not bone then return end
  pos, ang = ply:GetBonePosition(bone)
  
		self:SetPos(pos + ply:EyeAngles():Right() * -5 + ply:EyeAngles():Up() * 6 + ply:EyeAngles():Forward() * 3 ) 
		self:SetAngles(ply:EyeAngles() + Angle(120,0,180) ) 
  
	self:SetupBones()
  self:DrawModel() 
  
end 