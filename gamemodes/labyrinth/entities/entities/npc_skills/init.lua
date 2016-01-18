AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')


function ENT:SpawnFunction(ply, tr)

	if (!tr.Hit) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * -1
	
	local ent = ents.Create("npc_skills")
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	
	return ent
end


function ENT:Initialize( )
 
	self:SetModel( "models/odessa.mdl" ) 
	
	self:SetHullType( HULL_HUMAN ) 
	self:SetHullSizeNormal( )
	
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX ) 
	self:CapabilitiesAdd(CAP_TURN_HEAD )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE)
	self:SetUseType( SIMPLE_USE ) 
	self:DropToFloor()
 
	self:SetMaxYawSpeed( 90 ) 
 
end

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		umsg.Start("ShopNPCUsed", Caller) 
		umsg.End() 
	end
end