
ENT.PrintName		= "Melonmancer"
ENT.Author			= "TB002"

if SERVER then
   AddCSLuaFile("shared.lua")
end

if CLIENT then
  
end


ENT.Type = "anim"
ENT.Model = Model("models/props_trainstation/trashcan_indoor001a.mdl")
ENT.NUMBERS= {
	"npc/metropolice/vo/ten.wav",
	"npc/metropolice/vo/one.wav",
	"npc/metropolice/vo/two.wav",
	"npc/metropolice/vo/three.wav",
	"npc/metropolice/vo/four.wav",
	"npc/metropolice/vo/five.wav",
	"npc/metropolice/vo/six.wav",
	"npc/metropolice/vo/seven.wav",
	"npc/metropolice/vo/eight.wav",
	"npc/metropolice/vo/nine.wav",
	
	
}



function ENT:Initialize()
   self:SetModel(self.Model)
   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
   end
   self:SetMoveType(MOVETYPE_NONE)
   self:SetSolid(SOLID_BBOX)

   if SERVER then
      self:SetUseType(SIMPLE_USE)
   end
   
   self:EmitSound( "npc/scanner/scanner_combat_loop1.wav", 80, 90  )
   self.fires = 0
 
end

function ENT:Think()

if SERVER then
if self.fires == 0 then
	self:NextThink( CurTime() + 18 )
	self.fires = self.fires + 1
	return true
end
local melonamount = 1

if self.fires %10 != 0 then
	for i=1, melonamount do
	timer.Simple( .5 + i/melonamount, function()
		if IsValid( self ) then
		
			self:EmitSound( "weapons/physcannon/superphys_launch2.wav", 70, 130 )
			
			local mypos = self:GetPos() + (self:GetAngles():Forward() * 10) + Vector(0,0, 35)
			local effectdata = EffectData()
			effectdata:SetStart( mypos)
			effectdata:SetOrigin( self:GetPos() + Vector(0,0, 35) )
			effectdata:SetScale( 1 )
			util.Effect( "GlassImpact", effectdata )
			
			local melon = ents.Create( "prop_physics" )
				melon:SetModel( "models/props_junk/watermelon01.mdl" )
				melon:SetPos( mypos )
				melon:Spawn()
				melon:Activate()
				melon:GetPhysicsObject():ApplyForceCenter( ( (self:GetAngles():Forward() + Vector(0,0,.03)) * 20000 ) )
				
			timer.Simple( 2, function() ExplodeMelon( melon ) end )
		end
	end)
end

	for i = 0, 8 do
		timer.Simple( i/14, function()
		if IsValid( self ) then
		self:SetAngles( self:GetAngles() + Angle(0,10,0 ) )
		end
		end)
	end
	self:EmitSound( self.NUMBERS[self.fires % 10 + 1], 80, 90  )
	self.fires = self.fires + 1
	self:NextThink( CurTime() + 1.8 )
	return true
else
for i=1, 9 do
	timer.Simple( 2 + i/2.5, function()
		if IsValid( self ) then
		
			self:SetAngles( self:GetAngles() + Angle(0,40,0 ) )
			self:EmitSound( "weapons/physcannon/superphys_launch2.wav", 70, 130 )
			
			local mypos = self:GetPos() + (self:GetAngles():Forward() * 10) + Vector(0,0, 35)
			local effectdata = EffectData()
			effectdata:SetStart( mypos)
			effectdata:SetOrigin( self:GetPos() + Vector(0,0, 35) )
			effectdata:SetScale( 1 )
			util.Effect( "GlassImpact", effectdata )
			
			local melon = ents.Create( "prop_physics" )
				melon:SetModel( "models/props_junk/watermelon01.mdl" )
				melon:SetPos( mypos )
				melon:Spawn()
				melon:Activate()
				melon:GetPhysicsObject():ApplyForceCenter( ( self:GetAngles():Forward() * 20000 ) )
				
			timer.Simple( 2, function() ExplodeMelon( melon ) end )
				
			
		end
	end)
end

	self:EmitSound( self.NUMBERS[self.fires % 8 + 1] )
	self.fires = self.fires + 1
	self:NextThink( CurTime() + 12 )
	return true
end
end
end 
 
function ExplodeMelon( mel )

	if SERVER then
	if IsValid( mel ) then
			local explode = ents.Create( "env_explosion" )
			explode:SetPos( mel:GetPos() )
			explode:Spawn() 
			explode:SetKeyValue( "iMagnitude", "10" ) 
			explode:Fire( "Explode", 0, 0 )
		
		for k,v in pairs( ents.FindInSphere( mel:GetPos(),40) ) do
							if IsValid( v ) && v:GetClass() == "prop_physics" && v.edge != nil && !v.edge && v != choice then
								local effectdata = EffectData()
									effectdata:SetStart( v:GetPos() )
									effectdata:SetOrigin( v:GetPos() )
									effectdata:SetScale( 4 )
								util.Effect( "cball_explode", effectdata )
								v:EmitSound( "physics/concrete/concrete_break3.wav" )
								v:Remove()
							end
		end
			
		mel:Remove()
	end
	end

end


