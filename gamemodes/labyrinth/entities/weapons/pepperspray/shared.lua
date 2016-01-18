
if SERVER then
	AddCSLuaFile ("shared.lua")
	AddCSLuaFile ("init.lua")
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= false
	SWEP.HoldType			= "pistol"
else
	SWEP.BobScale			= 1
	SWEP.SwayScale			= 1
	SWEP.DrawCrosshair		= false
	SWEP.PrintName			= "Pepper Spray"
	SWEP.Slot = 0
	SWEP.SlotPos = 2
end

SWEP.Author			= "TB002"
SWEP.Contact		= ""
SWEP.Purpose		= "Blind the minotaur temporarily."
SWEP.Instructions	= "Aim at minotaur, shoot."

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false


SWEP.Category			= "Labyrinth"

SWEP.ViewModel			= "models/weapons/v_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Secondary.DefaultClip	= 0
SWEP.Primary.Automatic		= false 
SWEP.Primary.Delay		=  10
SWEP.Primary.Ammo			= "Pistol" 


function SWEP:PrimaryAttack()

	self.Weapon:EmitSound( "weapons/gauss/fire1.wav")
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Owner:SetAnimation( PLAYER_ATTACK1 );

	local effectdata = EffectData()
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetOrigin( self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 30 )
		effectdata:SetScale( 4 )
		util.Effect( "GlassImpact", effectdata )

	if SERVER then
		local targets = ents.FindInCone( self.Owner:GetPos(), self.Owner:EyeAngles():Forward(), 300, 20 )
		local hitcount = 0
		for k,v in pairs(targets) do
			if IsValid( v ) and v:IsPlayer() and GetRole( v ) == ROLE_MINOTAUR then
				PepperSpray( v )
				hitcount = hitcount + 1
			end
		end

		if hitcount == 0 then
			self.Owner:EmitSound( "vo/npc/male01/whoops01.wav" )
		else
			addDrachma( self.Owner, 2 * hitcount, " spraying a minotaur." )
			addEvent( "spray", {self.Owner} )
			self.Owner:databaseIncrementValue( "sprays" )
			self.Owner:databaseCheckRecord( "sprays" )
		end
		
		self:TakePrimaryAmmo( 1 ) 
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
		self.Owner:StripWeapon( "pepperspray" )
	end
end



function SWEP:Initialize()

	if SERVER then 
 		self:SetWeaponHoldType( self.HoldType ) 
 	end 
	self.ActivityTranslate = {}
	self.ActivityTranslate[ACT_HL2MP_IDLE] = ACT_HL2MP_IDLE_PISTOL
	self.ActivityTranslate[ACT_HL2MP_WALK] = ACT_HL2MP_WALK_PISTOL
	self.ActivityTranslate[ACT_HL2MP_RUN] = ACT_HL2MP_RUN_PISTOL
	self.ActivityTranslate[ACT_HL2MP_IDLE_CROUCH] = ACT_HL2MP_IDLE_CROUCH_PISTOL
	self.ActivityTranslate[ACT_HL2MP_WALK_CROUCH] = ACT_HL2MP_WALK_CROUCH_PISTOL
	self.ActivityTranslate[ACT_HL2MP_GESTURE_RANGE_ATTACK] = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
	self.ActivityTranslate[ACT_HL2MP_GESTURE_RELOAD] = ACT_HL2MP_GESTURE_RELOAD_PISTOL
	self.ActivityTranslate[ACT_HL2MP_JUMP] = ACT_HL2MP_JUMP_PISTOL
	self.ActivityTranslate[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_PISTOL
end
