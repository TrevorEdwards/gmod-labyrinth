
ENT.PrintName		= "Exit Beacon"
ENT.Author			= "TB002"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if SERVER then
   AddCSLuaFile("shared.lua")
end

if CLIENT then
  
end


ENT.Type = "anim"
ENT.Model = Model("models/hunter/blocks/cube4x4x05.mdl")



function ENT:Initialize()

   self:SetModel(self.Model)

   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
	  CreateGameTeleporterTimer()
	net.Start( "teleporterspawned" ) 
		net.WriteVector( self:GetPos() )
	net.Broadcast()
   end
   self:SetMoveType(MOVETYPE_NONE)
   self:SetSolid(SOLID_VPHYSICS)

   self:SetRenderMode( RENDERMODE_TRANSALPHA )
   self:SetMaterial( "phoenix_storms/Pro_gear_side" )
	self:SetColor( Color( 0, 0, 20, 254.3 ) )
	self:SetAngles( Angle( 0, 0, 90 ) )

end

function ENT:Shock()

	self:EmitSound("ambient/levels/labs/teleport_active_loop1.wav")

end

function ENT:Think()

	
	if SERVER then
	
		local myPos = self:GetPos()
		local choices = player.GetAll()
		
		for k,v in pairs(choices) do
			if IsValid( v ) then
				local plydist = myPos:Distance( v:GetPos() )
					if GetRole( v ) == ROLE_MINOTAUR then
						if plydist < 160 and GetRole( v ) == ROLE_MINOTAUR then
						printPlayer( v, "The exit teleporter is hurting you!  Move away!" )
						local dmginfo = DamageInfo()
						dmginfo:SetDamage(70)
						dmginfo:SetDamageType( DMG_SHOCK )
						dmginfo:SetAttacker(game.GetWorld())
						dmginfo:SetInflictor(game.GetWorld())
						dmginfo:SetDamageForce(Vector(100,0,0))
						v:TakeDamageInfo(dmginfo)
						v:EmitSound( "ambient/creatures/town_child_scream1.wav" )
						end
					end
			end
		end
		
		for i = 1, math.random(1,5) do
			local effectdata = EffectData()
			local randomvec = Vector( math.random(-40,40), math.random(-40,40), math.random(-40,40) )
			effectdata:SetStart( myPos + randomvec )
			effectdata:SetOrigin( myPos + randomvec )
			effectdata:SetScale( 6 )
			util.Effect( "cball_explode", effectdata )
		end
		
		self:EmitSound("ambient/levels/labs/teleport_preblast_suckin1.wav")
		local nextfire  = 2
		self:NextThink( CurTime() + nextfire )
	end
	
	
	return true
end

function ENT:StartTouch( ply )

	if SERVER then
		if ply:IsPlayer() and  GetRole( ply ) == ROLE_PLAYER then
			FoundExit( ply )
			self:EmitSound("ambient/levels/labs/teleport_weird_voices"..math.random(1,2)..".wav")
		end
	end
	
end


