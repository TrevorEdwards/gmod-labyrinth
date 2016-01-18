
ENT.PrintName		= "Gate Trap"
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
	self:SetMaterial( "models/props_canal/canal_bridge_railing_01b" )
   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
   end
   self:SetMoveType(MOVETYPE_PUSH )
   self:SetSolid(SOLID_VPHYSICS)
    self.thinktime = math.random( 3, 8 )
end

function ENT:Think()

if SERVER then

	if self.open == true then
		self:EmitSound( "doors/door_metal_gate_move1.wav" )
		for i=1, 12 do
			timer.Simple( i/12, function()
				if IsValid( self ) then
					self:SetPos( self:GetPos() + Vector( 0, 0, -11.5 ) )
				end
			end)
		end
		self.open = !self.open
	else
		self:EmitSound( "doors/door_metal_gate_move1.wav" )
		for i=1, 12 do
			timer.Simple( i/12, function()
				if IsValid( self ) then
					self:SetPos( self:GetPos() + Vector( 0, 0, 11.5 ) )
				end
			end)
		end
	
		self.open = !self.open
	end

	
	self:NextThink( CurTime() + self.thinktime )
	return true
end
end
 


