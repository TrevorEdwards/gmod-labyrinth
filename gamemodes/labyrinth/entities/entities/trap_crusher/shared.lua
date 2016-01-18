
ENT.PrintName		= "Crusher Trap"
ENT.Author			= "TB002"

if SERVER then
   AddCSLuaFile("shared.lua")
end

if CLIENT then
  
end


ENT.Type = "anim"
ENT.open = false
ENT.size = 1
ENT.thinktime = 5



function ENT:Initialize()
   self:SetModel( "models/hunter/plates/plate"..self.size.."x"..self.size..".mdl" )
	self:SetMaterial( "phoenix_storms/stripes" )
   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
   end
   self:SetMoveType(MOVETYPE_PUSH )
   self:SetSolid(SOLID_VPHYSICS)
	self:EmitSound( "vehicles/APC/apc_idle1.wav" )
	self:DrawShadow( true )
	 self.thinktime = math.random( 3, 8 )
end

function ENT:Think()

if SERVER then

	local entrad = self.size * 23
	if self.open == true then
		self:EmitSound( "doors/door_chainlink_move1.wav" )
		for i=1, 12 do
			timer.Simple( i/12, function()
				if IsValid( self ) then
					self:SetPos( self:GetPos() + Vector( 0, 0, -11.5) )
						for k,v in pairs( ents.FindInBox( self:GetPos() + Vector( -entrad, -entrad, -15) , self:GetPos() + Vector( entrad, entrad, 0 ) ) ) do
					
							if (v:IsPlayer() and v:Alive() ) or v:IsNPC() then 
								local crushdmg = DamageInfo()
									crushdmg:SetDamage(500)
						crushdmg:SetDamageType(DMG_CRUSH)
							crushdmg:SetAttacker(self)
						crushdmg:SetInflictor(self)
						crushdmg:SetDamageForce(Vector(0,0,-500))
						v:TakeDamageInfo(crushdmg)
						self:EmitSound( "HL1/fvox/major_fracture.wav" )
	
							end
						
						end
				end
			end)
		end
		self.open = !self.open
	else
		self:EmitSound( "doors/door_chainlink_move1.wav" )
		for i=1, 12 do
			timer.Simple( i/12, function()
				if IsValid( self ) then
					self:SetPos( self:GetPos() + Vector( 0, 0, 11.5 ) )
				end
			end)
			timer.Simple( self.thinktime - 1, function()
				if IsValid( self ) then
					self:EmitSound( "npc/turret_floor/deploy.wav", 80, 90 )
				end
			end)
		end
	
		self.open = !self.open
	end

	
	self:NextThink( CurTime() + self.thinktime )
	return true
end
end
 


