SWEP.ClassName = throwingneedles
SWEP.Category = "Labyrinth"
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "Throwing Needles"
SWEP.Base = "weapon_base"
SWEP.Author = "TB002"
SWEP.Instructions = "Throw needles at humans."
SWEP.ViewModel = "models/crossbow_bolt.mdl"
SWEP.WorldModel = "models/crossbow_bolt.mdl"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.Weight = 20
if CLIENT then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	else
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= false
end

SWEP.Primary = {
	
		["Ammo"] = "Pistol",
		["ClipSize"] = 1,
		["DefaultClip"] = 0,
		["Automatic"] = false,
		["Delay"] = 1
		
}


function SWEP:Initialize()


end

function SWEP:PrimaryAttack()

	self.Owner:SetAnimation( PLAYER_ATTACK1 );

	self:EmitSound( "weapons/slam/throw.wav", 50, 200 )
	if SERVER then
		local owner = self:GetOwner()
		local bolt = ents.Create("needle")
		bolt:SetPos(owner:GetShootPos())
		bolt:SetAngles(owner:EyeAngles())
		bolt:SetMaterial( "models/shiny" )
		bolt:SetColor( Color( 255, 0, 0 ) )
		bolt:SetOwner(owner)
		bolt:Spawn()
		bolt:SetVelocity(owner:EyeAngles():Forward()*100)
	end


	self:TakePrimaryAmmo( 1 ) 
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 

end

function SWEP:SecondaryAttack()

	return false

end

function SWEP:CalcViewModelView( wep, vm, oldAng, oldPos, pos, ang )

	local owner = self:GetOwner()
	local newang
	local newpos
		
	if IsValid( owner ) and owner:Alive() then
		if self:GetNextPrimaryFire() > CurTime() then
			local distmod = (self:GetNextPrimaryFire() - CurTime()) / self.Primary.Delay
			newpos = oldPos + owner:EyeAngles():Up() * -2 + owner:EyeAngles():Forward() * (20 * (1 - distmod) )  + owner:EyeAngles():Right() * 2
			newang = oldAng + Angle(180,10,00)
		else
			newpos = oldPos + owner:EyeAngles():Up() * -2  + owner:EyeAngles():Forward() * 20 + owner:EyeAngles():Right() * 1
			newang = oldAng + Angle(180,5,00)
		end
	end
	
	return newpos, newang

end

function SWEP:DrawWorldModel( )
		
	ply = self:GetOwner() or self:GetOwner():GetRagdollEntity()
  if not( IsValid( ply ) ) then return end
  bone = ply:LookupBone("ValveBiped.Bip01_R_Hand") -- Head.
  if not bone then return end
  pos, ang = ply:GetBonePosition(bone)
  
  self:SetPos(pos + Vector(0,0,2) ) 
  self:SetAngles(ang + Angle(0,15,0) ) 
	self:SetupBones()
  self:DrawModel() -- Might want to check it doesn't block the players view.
  
end