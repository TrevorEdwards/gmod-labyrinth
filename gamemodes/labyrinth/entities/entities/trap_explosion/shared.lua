
ENT.PrintName		= "Explosion Trap"
ENT.Author			= "TB002"

if SERVER then
   AddCSLuaFile("shared.lua")
end

if CLIENT then
  
end


ENT.Type = "anim"
ENT.Model = Model("models/hunter/plates/plate1x1.mdl")




function ENT:Initialize()
   self:SetModel(self.Model)

   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
   end
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_VPHYSICS)

   
   self.traptype = 0
	self:DrawShadow( false )
	 self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor( Color(255, 255, 255, 0 ) )
	self:SetMaterial( "models/shiny" )

end

function ENT:PhysicsCollide( data, physobj )
 
	ply = data.HitEntity
if ply:IsPlayer() and ply:KeyDown(IN_DUCK) then return false end
if (ply:IsPlayer() or ply:IsNPC()) && self:WaterLevel() < 3 then

	if data.Speed > 20  then
		if self.traptype == 0 then
			local pPos = self:GetPos() + Vector(0,0, 2)
			local explode = ents.Create( "env_explosion" )
			explode:SetPos( self:GetPos() )
			explode:SetOwner( self:GetOwner() ) 
			explode:Spawn() 
			explode:SetKeyValue( "iMagnitude", "100" ) 
			explode:Fire( "Explode", 0, 0 )
			sound.Play( "HL1/fvox/activated.wav", self:GetPos(), 75, 100, 1 )
			self:Remove()
		elseif self.traptype == 1 then
			ply:Ignite( 6, 20 )
			ply:EmitSound( "vo/npc/male01/pain0"..math.random(1,9)..".wav" )
			sound.Play( "HL1/fvox/activated.wav", self:GetPos(), 75, 100, 1 )
			self:Remove()
		elseif self.traptype == 2 then
			if math.random(1,2) == 1 then
				for i = 1, 3 do
				local ent = ents.Create( "npc_grenade_frag" )
					ent:SetPos( self:GetPos() + Vector( math.random(-25,25), math.random(-25,25), 50 + 2*i) ) 
					ent:Spawn()
					ent:Activate()
					local tim = math.random(3,6)
					ent:SetModelScale( 2, 2 )
					ent:Fire("SetTimer", tim )
				end
			else
				local ent = ents.Create( "grenade_helicopter" )
					ent:SetPos( self:GetPos() + Vector(0,0, 60) ) 
					ent:Spawn()
					ent:Activate()
					ent:Fire("ExplodeIn", 0 )
					ent:SetModelScale( 2, 1 )
			end
			sound.Play( "HL1/fvox/activated.wav", self:GetPos(), 75, 100, 1 )
			self:Remove()
		elseif self.traptype == 3 then
			for i = 1, 5 do
			local ent = ents.Create( "npc_rollermine" )
				ent:SetPos( self:GetPos() + Vector( math.random(-50,50), math.random(-50,50), 60 + 2*i) ) 
				ent:Spawn()
				ent:Activate()
			end
			ply:EmitSound( "vo/npc/male01/ohno.wav" )
			sound.Play( "HL1/fvox/activated.wav", self:GetPos(), 75, 100, 1 )
			self:Remove()
		
		elseif self.traptype == 4 then
		
			for i = 1, 5 do
			local ent = ents.Create( "npc_manhack" )
				ent:SetPos( self:GetPos() + Vector( math.random(-50,50), math.random(-50,50), 60 + 2*i) ) 
				ent:Spawn()
				ent:Activate()
			end
			ply:EmitSound( "vo/npc/male01/thehacks0"..math.random(1,2)..".wav")
			sound.Play( "HL1/fvox/activated.wav", self:GetPos(), 75, 100, 1 )
			self:Remove()
		
		elseif self.traptype == 5 then
			if ply:IsPlayer() then
				GAMEMODE:SetPlayerSpeed( ply, ply:GetWalkSpeed() - 60, ply:GetRunSpeed() - 100 )
				printPlayer( ply, "Tripped a tar trap!" )
				timer.Simple( 10, function() 
					if SERVER then
						Untar( ply ) 
					end
				
				end )
				sound.Play( "HL1/fvox/activated.wav", self:GetPos(), 75, 100, 1 )
				self:Remove()
			end
		else
			if ply:IsPlayer() then
				net.Start( "blindness" )
					net.WriteInt( 5, 8 )
				net.Send( ply )
				printPlayer( ply, "You have sprung a pepperspray trap!" )
				sound.Play( "HL1/fvox/activated.wav", self:GetPos(), 75, 100, 1 )
				self:Remove()
			end
		
		end
		
	end
 
 end
 
end



