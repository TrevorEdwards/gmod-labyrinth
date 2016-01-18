ENT.PrintName		= "Needle"
ENT.Author			= "TB002"
ENT.Type = "anim"

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

function ENT:Initialize()

        util.PrecacheModel("models/items/crossbowrounds.mdl")
        self:SetModel("models/items/crossbowrounds.mdl")
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:SetColor( Color( 0,0,0,0 ) )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        
        self:StartMotionController()
        
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		if SERVER then
			self:SetTrigger(true)
		end

        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
                phys:EnableCollisions(true)
                phys:EnableDrag(false)
                phys:EnableGravity(false)
                phys:SetMass(999)
                phys:Wake()
        end
        
        self.HitFlesh1 = Sound("weapons/crossbow/bolt_skewer1.wav")
        self.HitFlesh2 = Sound("physics/flesh/flesh_impact_bullet1.wav")
        self.HitSound = Sound("weapons/fx/rics/ric"..math.random(1,5)..".wav")
        self.Break = Sound("weapons/grenade/tick1.wav")

		if SERVER then
        self.Trail = util.SpriteTrail(self, 0, Color(250,250,250,45), false, 3, 1, 0.5, 1/32 * 0.5, "trails/smoke.vmt")
		end
        self.DieTime = CurTime() + 1
		
end

function ENT:Think()
        if self:WaterLevel() > 0 then self.DieTime = CurTime() - 1 end
        if self.DieTime then
                if self.DieTime < CurTime() then
                        self:DoExplode() 
                end
        end
        self:NextThink(CurTime())
        return true
end

function ENT:PhysicsUpdate(phys,deltatime)
        phys:Wake()
        phys:SetVelocityInstantaneous( self:GetAngles():Forward() * 1200 )
        phys:AddAngleVelocity( Vector(0,.35,0) ) //slowly arc
end

function ENT:DoExplode()
        self:EmitSound(self.Break,100,math.random(90,110))
		if SERVER then
			self.Trail:Fire("kill",1,0.001)
			self:Fire("kill",1,0.0001)
		end
end

function ENT:Touch(ent)

        if ent:IsPlayer() or ent:IsNPC() then
                if ent == self:GetOwner() or GetRole( ent ) == ROLE_MINOTAUR then return end
                self:EmitSound(self.HitFlesh1,100,math.random(130,140))
                self:EmitSound(self.HitFlesh2,100,math.random(130,140))
                ent:TakeDamage( 50, self:GetOwner(), self:GetOwner() )
                self:Remove()
        end
		
end

function ENT:PhysicsCollide( data, phys )

        if not self.HitWeld and not data.HitEntity:IsPlayer() then
		
			self:EmitSound(self.HitSound,50,math.random(110,140))
			
                if data.HitEntity:IsWorld() and not self.DieTime then
        
                      --  self.HitWeld = constraint.Weld( data.HitEntity, self, 0, 0, 0, true )
                        self.DieTime = CurTime() + .1
                        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
                        
                elseif not self.DieTime then
                
                        self.DieTime = CurTime() 
                        self:NextThink(CurTime()) 
                        self:EmitSound(self.HitSound,100,math.random(120,140))
                
                end
        end
end