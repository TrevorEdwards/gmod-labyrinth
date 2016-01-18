AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

IDLESOUNDS = {
	"vo/gman_misc/gman_riseshine.wav",
	"vo/gman_misc/gman_04.wav",
	"vo/gman_misc/gman_03.wav",
	"vo/gman_misc/gman_02.wav",
	"commentary/tf2-comment000.wav"
}

local MODELS = {
	"models/seagull.mdl",
	"models/pigeon.mdl",
	"models/crow.mdl"
}



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
	self:SetModel( table.Random( MODELS) )
	self:SetHullType( HULL_TINY ) 
	self:SetHullSizeNormal( )
	
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX ) 
	self:CapabilitiesAdd( CAP_MOVE_JUMP) 
	self:CapabilitiesAdd(CAP_TURN_HEAD )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE)
	self:CapabilitiesAdd( CAP_MOVE_GROUND)
	self:SetUseType( SIMPLE_USE ) 
	self:DropToFloor()
 
	self.nextannoy = CurTime()
	self:SetMaxYawSpeed( 200 )
 
end

function ENT:Think()
	if SERVER then
		local myPos = self:GetPos()
		local choices = player.GetAll()
		local closeply = choices[1]
		if IsValid( closeply ) then
			local closedist = myPos:Distance( closeply:GetPos() )
		else
			closedist = 1000000
			closeply = nil
		end
		for i = 2, #choices do
			local ply = choices[i]
			if IsValid( ply ) then
				local plydist = myPos:Distance( ply:GetPos() )
				if closedist != nil then
				if  plydist < closedist then
					closeply = ply
					closedist = plydist
				end
				end
			end
		end
		
		if IsValid( closeply ) && closeply != nil then
			if self.nextannoy < CurTime() then
				if closedist != nil then
				if closedist < 150 then
					if GetRole( closeply ) == ROLE_PLAYER then
						self:SetLastPosition( closeply:GetPos() )
						self:SetSchedule( SCHED_FORCED_GO_RUN )
						self:EmitSound( "npc/metropolice/vo/vacatecitizen.wav" )
						self.nextannoy = CurTime() + 3
					else
						self:SetLastPosition( closeply:GetPos() )
						self:SetSchedule( SCHED_FORCED_GO_RUN )
						self:EmitSound( "ambient/voices/squeal1.wav" )
						self.nextannoy = CurTime() + 1
					end
				else
					local emitsound = table.Random( IDLESOUNDS )
					self:EmitSound( emitsound )
					self.nextannoy = CurTime() + 25
				end
				end
			end
		end
		return true 
	end
end
