
ENT.PrintName		= "Drachma Package"
ENT.Author			= "TB002"

if SERVER then
   AddCSLuaFile("shared.lua")
end

if CLIENT then
  
end


ENT.Type = "anim"
ENT.Model = Model("models/XQM/panel360.mdl")




function ENT:Initialize()
   self:SetModel(self.Model)
	self:SetMaterial( "labyrinth/drachma" )
	self:SetAngles( Angle( 0, 0, 180 ) )

   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
   end
   self:SetMoveType(MOVETYPE_NONE)
   self:SetSolid(SOLID_BBOX)


end

function ENT:StartTouch( ply )

	if SERVER then
	if IsValid ( ply ) and ply:IsPlayer() then
		ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0"..math.random(1,4)..".wav")
		
		if GAMEMODE.minigameactive then
			addDrachma( ply, 10 )
			ply:databaseIncrementValue( "minigamewins" )
			ply:databaseCheckRecord( "minigamewins" )
		else
			addDrachma( ply, math.random(1,4) )
		end
		sound.Play( "HL1/fvox/blip.wav", self:GetPos(), 75, 100, 1 )
		
		if GAMEMODE.minigameactive then
			TeleportToLobby( ply )
			EndMinigame()
		end
		
		self:Remove()
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


