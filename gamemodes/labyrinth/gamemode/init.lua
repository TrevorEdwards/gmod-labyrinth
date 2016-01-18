AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_report.lua" )
AddCSLuaFile( "database/cl_database.lua" )
AddCSLuaFile( "datatables/humanmodels.lua" )
AddCSLuaFile( "datatables/minomodels.lua" )
AddCSLuaFile( "datatables/endgamesongs.lua" )
AddCSLuaFile( "datatables/abilities.lua" )

include( "shared.lua" )
include( "player.lua" )
include( "minigame.lua" )
include( "mazegenerator.lua" )
include( "datatables/randomrooms.lua" ) 
include( "datatables/minomodels.lua" ) 
include( "datatables/events.lua" ) 
include( "datatables/humanmodels.lua" ) 
include("database/database.lua")
include( "drachma.lua" )
include( "teleports.lua" )
include( "gamemanager.lua" )
include( "specialeffects.lua" )
include( "datatables/randomeffects.lua" )
include( "datatables/endgamesongs.lua" )

-- This gamemode was created by TB002.  Unless specifically granted permission by TB002, you may not modify, copy, rebrand, or mess with this gamemode.  You, of course, may host a server using this gamemode.  That's totally fine.

CreateConVar("lab_maze_base_length", "11")
CreateConVar("lab_maze_extension", ".14")
CreateConVar("lab_wall_min_size", "3")
CreateConVar("lab_wall_max_size", "4")
CreateConVar("lab_special_ratio", "0.04")
CreateConVar("lab_minotaur_ratio", "0.2")
CreateConVar("lab_random_effects", "1")
CreateConVar("lab_base_exit_time", "60")
CreateConVar("lab_exit_extension", "0")
CreateConVar("lab_collapse_time", "60")
CreateConVar("lab_readyup_time", "20")
CreateConVar("lab_braid_chance", ".6")
CreateConVar("lab_globaldrachmamultiplier", "1")

CreateConVar("lab_room_crates", "1")
CreateConVar("lab_room_fakewall", "0")
CreateConVar("lab_room_health", "0")
CreateConVar("lab_room_melon", "0")
CreateConVar("lab_room_pigeon", "0")
CreateConVar("lab_room_rollermine", "0")
CreateConVar("lab_room_turret", "0")
CreateConVar("lab_room_cscanner", "0")
CreateConVar("lab_room_annoyer", "0")
CreateConVar("lab_room_explosiontrap", "0")
CreateConVar("lab_room_firetrap", "1")
CreateConVar("lab_room_grenadetrap", "1")
CreateConVar("lab_room_tartrap", "1")
CreateConVar("lab_room_rollerminetrap", "1")
CreateConVar("lab_room_manhacktrap", "1")
CreateConVar("lab_room_blindtrap", "1")
CreateConVar("lab_room_drachma", "1")
CreateConVar("lab_room_manhack", "0")
CreateConVar("lab_room_melonmancer", "1")
CreateConVar("lab_room_gate", "0")
CreateConVar("lab_room_gate_sliding", "0")
CreateConVar("lab_room_gate_rotating", "0")
CreateConVar("lab_room_crusher", "1")
CreateConVar("lab_room_light", "0")
CreateConVar("lab_room_divider", "1")


CreateConVar("lab_eff_flood", "0")
CreateConVar("lab_eff_gravity", "1")
CreateConVar("lab_eff_bugbait", "1")
CreateConVar("lab_eff_plasticwalls", "0")
CreateConVar("lab_eff_squeakyfeet", "1")
CreateConVar("lab_eff_hungrymino", "0")
CreateConVar("lab_eff_zombies", "0")
CreateConVar("lab_eff_deterioratingwalls", "0")
CreateConVar("lab_eff_thirdperson", "0")

CreateConVar("lab_min_players", "2")
CreateConVar("lab_alltalk", "1")

util.AddNetworkString( "skillupgrade" )
util.AddNetworkString( "roundinfo" )
util.AddNetworkString( "drachma" )
util.AddNetworkString( "myrole" )
util.AddNetworkString( "readytime" )
util.AddNetworkString( "maxhealth" )
util.AddNetworkString( "selectmodel" )
util.AddNetworkString( "teleporterspawned" )
util.AddNetworkString( "blindness" )
util.AddNetworkString( "playermessage" )
util.AddNetworkString( "endtime" )
util.AddNetworkString( "thirdperson" )
util.AddNetworkString( "telepos" )
util.AddNetworkString( "helpmenu" )
util.AddNetworkString( "minigame" )
util.AddNetworkString( "endgamereport" )
util.AddNetworkString( "soundtrack" )
util.AddNetworkString( "readyplayers" )
util.AddNetworkString( "labyrinthexplore" )


game.AddDecal( "HumanDecal", "labyrinth/human.vtf" )
game.AddDecal( "MinotaurDecal", "labyrinth/minotaur.vtf" )
game.AddDecal( "RandomDecal", "labyrinth/random.vtf" )

GM.Version = "2014.6.29"

function HelpMenu( ply )


	net.Start( "helpmenu" )
	local data = sdatabaseGet()
	local tab = sdatabaseGet()
	net.WriteTable( tab )
	net.Send( ply )
	
end

hook.Add( "ShowHelp", "helpmen", HelpMenu )

concommand.Add( "resetLabyrinth", function( ply, cmd, args, fullstring )

	if not IsValid( ply ) or (IsValid( ply ) and ply:IsAdmin()) then
		Abort()
	end
	
end)

concommand.Add( "testCommand", function( ply, cmd, args, fullstring )

	if not IsValid( ply ) or (IsValid( ply )) then
					
	end
	
end)



function GM:Initialize()

	self.BaseClass.Initialize( self )
	GAMEMODE.minoroom = nil
	GAMEMODE.playerroom = nil
	GAMEMODE.exitroom = nil
	GAMEMODE.squeakyfeet = false
	GAMEMODE.minigameactive = false
	GAMEMODE.thirdperson = false
	GAMEMODE.gameendsong = nil
	GAMEMODE.gamestartsong = nil
	GAMEMODE.soundtracksetting = 0
	GAMEMODE.readyuptime = 0
	GAMEMODE.noobreminder = 0
	GAMEMODE.soundtrackchange = 0
	GAMEMODE.zombies = false
	GAMEMODE.events = {}
	GAMEMODE.humans = {}
	GAMEMODE.minotaurs = {}
	RoundPre()
	sdatabaseCheck()
	MsgN("Labyrinth gamemode initializing...")
	
end

function GM:InitPostEntity()
	SpawnVendors()
	PaintDecals()
end

function SpawnVendors()

	skilltarget = ents.FindByName( "skillspot" )[1]
	local ent = ents.Create( "npc_skills" )
					ent:SetPos( skilltarget:GetPos() )
					ent:SetAngles( skilltarget:GetAngles() )
					ent:Spawn()
					ent:Activate()
					
	modeltarget = ents.FindByName( "modelspot" )[1]
	local ent = ents.Create( "npc_models" )
					ent:SetPos( modeltarget:GetPos() )
					ent:SetAngles( modeltarget:GetAngles() )
					ent:Spawn()
					ent:Activate()
					
	minigametarget = ents.FindByName( "minigamespot" )[1]
		local ent = ents.Create( "npc_minigame" )
			ent:SetPos( minigametarget:GetPos() )
			ent:SetAngles( minigametarget:GetAngles() )
			ent:Spawn()
			ent:Activate()

end

function PaintDecals()

	local traceworld = {}
		traceworld.start = Vector( 3380, 1950, 174 )
		traceworld.endpos = Vector( 3380, 1850, 174 )
		local trw = util.TraceLine(traceworld)
		local worldpos1 = trw.HitPos + trw.HitNormal * 5
		local worldpos2 = trw.HitPos - trw.HitNormal * 5
		util.Decal("HumanDecal",worldpos1,worldpos2)
	
	local traceworld = {}
		traceworld.start = Vector( 3055, 1950, 174 )
		traceworld.endpos = Vector( 3055, 1850, 174 )
		local trw = util.TraceLine(traceworld)
		local worldpos1 = trw.HitPos + trw.HitNormal * 5
		local worldpos2 = trw.HitPos - trw.HitNormal * 5
		util.Decal("RandomDecal",worldpos1,worldpos2)
		
	local traceworld = {}
		traceworld.start = Vector( 2750, 1950, 174 )
		traceworld.endpos = Vector( 2750, 1850, 174 )
		local trw = util.TraceLine(traceworld)
		local worldpos1 = trw.HitPos + trw.HitNormal * 5
		local worldpos2 = trw.HitPos - trw.HitNormal * 5
		util.Decal("MinotaurDecal",worldpos1,worldpos2)
		
end

function GM:PlayerConnect( name, ip )
end



function GM:PlayerInitialSpawn( ply )

	SetRole( ply, ROLE_OBSERVER )
	ply:SetNoCollideWithTeammates( true )
	ply:ShouldDropWeapon( true )
	ply:SetCustomCollisionCheck( true )
	printPlayer( ply , "Welcome to labyrinth!  Press F1 for help!" )
	ply:databaseCheck()
	
	net.Start( "roundinfo" )
   net.WriteInt( GetRoundState() , 3 )
   net.Send( ply )
   
   	net.Start( "drachma" )
	net.WriteInt( ply:databaseGetValue( "drachma" ), 30 )
   net.Send( ply )
   
   if GetRoundState() == 1 then
   net.Start( "readytime" )
		net.WriteDouble( GAMEMODE.readyuptime - CurTime(), 8 )
	net.Send(  ply )
	end
   
   MakeNormal( ply )
   
   if #player.GetAll() < 2 then
	else
		if GAMEMODE.minigameactive then
			for k,v in pairs( player.GetAll() ) do
				if IsValid( v ) then
					TeleportToLobby( v )
				end
			end
			EndMinigame()
		end
   end
   
   PaintDecals()
   
end


function GM:ShouldCollide( ent1, ent2 )

	if( ent1:IsPlayer() && ent2:IsPlayer() && GetRole( ent1 ) == GetRole( ent2 ) ) then
		return false
	else
		return true
	end

end

function GM:PlayerAuthed( ply, steamID, uniqueID )
	ply:databaseCheck()
end

function GM:PlayerDisconnected( ply )
	ply:databaseDisconnect()
	local choices = player.GetAll()
	local mino = 0
	local human = 0
	for k,v in pairs(choices) do
		if IsValid( v ) then
			if GetRole( v ) == 2 then
				mino = mino + 1
			elseif GetRole( v ) == 1 then
				human = human + 1
			end
		end
	end
	
	if GetRoundState() > 1 then
		if human > 0 or mino > 0 then
			CheckForEnd()
		else
			CheckForAbort()
		end
	else
		if GAMEMODE.minigameactive then
			EndMinigame()
		end
	end
end


function GM:KeyPress( ply, key )

    if key == IN_RELOAD and GetRoundState() > 1 and GetRole( ply ) == ROLE_OBSERVER then
		if ply:GetObserverMode() == OBS_MODE_ROAMING then
			local validplys = {}
			for k,v in pairs( player.GetAll() ) do
				if IsValid( v ) and v:Alive() and GetRole( v ) > 0 then
					table.insert( validplys, v )
				end
			end
			
			 ply:Spectate( OBS_MODE_CHASE  )
			ply:SpectateEntity( table.Random( validplys ) )
		elseif ply:GetObserverMode() == OBS_MODE_CHASE then
			ply:Spectate( OBS_MODE_ROAMING )
		end
	elseif key == IN_JUMP && ply:Alive() && GetRole( ply ) == ROLE_OBSERVER then
		if GetRoundState() > ROUND_PRE then
			ply:KillSilent()
			GAMEMODE:PlayerSpawnAsSpectator( ply )
			printPlayer( ply, "Spectating.  Press reload to toggle spectating mode." )
		end
	
	end
end

function PlayerDied( ply, attacker, dmg )
	
	if ply:HasWeapon( "weapon_crowbar" ) then
	
		local ent = ents.Create( "weapon_package" )
		ent:SetPos( ply:GetPos() + Vector( 0, 0, 45) )
		ent:Spawn()
		ent:Activate()
		
	end
	
	if GetRoundState() == ROUND_SETUP then
		SetRole( ply, ROLE_OBSERVER )
		CheckForEnd()
	end
	
	
	
	if GetRoundState() == ROUND_PLAY then
	
		if GetRole( ply ) == ROLE_MINOTAUR then
			ply:EmitSound( "npc/zombie/zombie_die"..math.random(1,3)..".wav", 100, 80 )
		else
			ply:EmitSound( "ambient/voices/m_scream1.wav", 100, 80 )
		end
		
		choices = player.GetAll()
		team1 = GetRole( ply )
		if attacker:IsPlayer() then
		
			team2 = GetRole( attacker )
			
			if team1 == ROLE_MINOTAUR and team2 == ROLE_PLAYER then
				addDrachma( attacker, 6 )
				attacker:databaseIncrementValue( "minotaurkills" )
				attacker:databaseCheckRecord( "minotaurkills" )
				printAnnounce( attacker:Nick().." slayed "..ply:Nick().."!" )
				addEvent( "minokill", {ply, attacker } )
			elseif team1 == ROLE_PLAYER and team2 == ROLE_MINOTAUR then
				addDrachma( attacker, 4 )
				attacker:EmitSound( "labyrinth/minotaur/kill"..math.random(1,5)..".wav" )
				attacker:databaseIncrementValue( "humankills" )
				attacker:databaseCheckRecord( "humankills" )
				printAnnounce( ply:Nick().." was ganked by "..attacker:Nick().."!" )
				addEvent( "humankill", {ply, attacker } )
			elseif team1 == ROLE_MINOTAUR then
				addEvent( "minokill", {ply, ply } )
			elseif team1 == ROLE_PLAYER then
				addEvent( "humankill", {ply, ply } )
			end
			
		elseif attacker:GetClass() == "prop_physics" then
			printAnnounce( ply:Nick().." thought he was stronger than he was!" )
			addEvent( "propkill", {ply } )
		elseif attacker:GetClass() == "trap_crusher" then
			printAnnounce( ply:Nick().." felt squished!" )
			addEvent( "crushkill", {ply} )
		else
			printAnnounce( ply:Nick().." died like an idiot!" )
			addEvent( "mysterykill", {ply } )
		end
		
		if team1 == ROLE_MINOTAUR then
			addDrachmaTable( GAMEMODE.humans, 4 )
		
		elseif team1 == ROLE_PLAYER then
			addDrachmaTable( GAMEMODE.minotaurs, 2 )
		end
	
		SetRole( ply, ROLE_OBSERVER )
		CheckForEnd()
	end
	
	if GetRoundState() == ROUND_PRE then
		if GAMEMODE.minigameactive then
			EndMinigame()
		end
	end
	 
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount )
 
	if ( ent:IsPlayer() ) then
		if amount != nil and amount > 6 then
			if IsValid( attacker ) and attacker:IsPlayer() and GetRole( attacker ) == ROLE_MINOTAUR and GetRole( ent ) == ROLE_PLAYER then
				ent:EmitSound( "vo/npc/male01/pain0"..math.random(1,9)..".wav" )
			elseif GetRole( ent ) == ROLE_PLAYER then
			
			elseif GetRole( ent ) == ROLE_MINOTAUR then
				ent:EmitSound( "npc/zombie_poison/pz_pain"..math.random(1,3)..".wav" )
			end
		end
		
		hook.Call("PlayerTakeDamage", self, ent, inflictor, attacker, amount)
		
		if GetRole( ent ) == ROLE_PLAYER and ent:Health() <= 26 and ent:Alive() and ( (not ent.heartbeat) or ent.heartbeat == nil ) then
			ent:EmitSound( "player/breathe1.wav" )
			ent:EmitSound( "player/heartbeat1.wav", 80, 110 )
			ent.hearbeat = true
		end
	end
 
end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, filter )

	if GetRole( ply ) == ROLE_PLAYER then 
		ply:EmitSound( "player/footsteps/concrete"..math.random(1,4)..".wav", 100, 90 )
	elseif GetRole( ply ) == ROLE_MINOTAUR then
		ply:EmitSound( "player/footsteps/concrete"..math.random(1,4)..".wav", 150, 35 )
		return true 
	else
		return true
	end
end
 
hook.Add( "PlayerDeath", "roundchecker", PlayerDied )

function printAnnounce( msg, role)
local choices = player.GetAll()
	for k,v in pairs(choices) do
		if (IsValid(v)) then
			if role == nil then
				printPlayer( v, msg )
			else
				if role == GetRole( v ) then
					printPlayer( v, msg )
				end
			end
		end
	end
end

function printPlayer( ply, msg )
	net.Start( "playermessage" )
	net.WriteString( msg )
	net.Send( ply )
end

function GM:Tick()
local ply = nil
local players = nil


	if GetRoundState() == ROUND_PRE then
		
		local humanselects = ents.FindByName( "humanselects" )[1]
		local humanselecte = ents.FindByName( "humanselecte" )[1]
		local normalselects = ents.FindByName( "normalselects" )[1]
		local normalselecte = ents.FindByName( "normalselecte" )[1]
		local minotaurselects = ents.FindByName( "minotaurselects" )[1]
		local minotaurselecte = ents.FindByName( "minotaurselecte" )[1]
		if not IsValid( humanselects ) or not IsValid( minotaurselecte ) then return end
	
		local humanchoices = ents.FindInBox( humanselects:GetPos(), humanselecte:GetPos() )
		local minotaurchoices = ents.FindInBox( minotaurselects:GetPos(), minotaurselecte:GetPos() )
		local normalchoices = ents.FindInBox( normalselects:GetPos(), normalselecte:GetPos() )
		
		local readycount = 0
		for k,v in pairs( humanchoices ) do
			if IsValid( v ) and v:IsPlayer() and v:Alive() then
				readycount = readycount + 1
			end
		end
		
		for k,v in pairs( minotaurchoices ) do
			if IsValid( v ) and v:IsPlayer() and v:Alive() then
				readycount = readycount + 1
			end
		end
		
		for k,v in pairs( normalchoices ) do
			if IsValid( v ) and v:IsPlayer() and v:Alive() then
				readycount = readycount + 1
			end
		end
		
		if readycount != sentreadyplayers then
			sentreadyplayers = readycount
			net.Start( "readyplayers" )
				net.WriteInt( sentreadyplayers, 10 )
			net.Broadcast()
		end
	end
	if GAMEMODE.noobreminder < CurTime() then
	
		local lastply = nil
		local foundnum = 0
		local randomlottery = math.random( 1, 90 )
		
		for k,v in pairs( player:GetAll() ) do
			if IsValid( v ) then
				lastply = v
				foundnum = foundnum + 1
				if GetRole( v ) == ROLE_OBSERVER then
					printPlayer( v, "Press F1 for help!" )
				end
				if randomlottery == 1 then
					addDrachma( v , 50, " being lucky!" )
				end
			end
		end
		
		if foundnum == 1 then
			if IsValid( lastply ) then
				addDrachma( lastply , 1, " being the only one on the server!" )
			end
		end
		GAMEMODE.noobreminder = CurTime() + 30
	
	end
	
	if GetRoundState() == ROUND_PLAY and GAMEMODE.soundtrackchange <= CurTime() then
		local nearbyhuman = false
		for k,v in pairs( GAMEMODE.minotaurs ) do
		if IsValid( v ) and v:Alive() then
			for i,j in pairs( ents.FindInSphere( v:GetPos(), 270 ) ) do
				if IsValid( j ) and j:IsPlayer() and GetRole( j ) == ROLE_PLAYER then
				
				local tracedata = {
					start = v:EyePos(),
					endpos = j:EyePos(),
					filter = function( ent )
					if ( IsValid( ent ) and ent:GetClass() == "prop_physics" ) then 
						return true 
					end
					end
				}
				local tr = util.TraceLine( tracedata )
				
				if not IsValid( tr.Entity ) then
					nearbyhuman = true
				else
				end
				end
			end
		end
		end
		
		if nearbyhuman and GAMEMODE.soundtracksetting == 0 then
			SelectSoundtrack( 1 )
			GAMEMODE.soundtracksetting = 1
			GAMEMODE.soundtrackchange = CurTime() + 8
		elseif (not nearbyhuman) and GAMEMODE.soundtracksetting == 1 then
			SelectSoundtrack( 0 )
			GAMEMODE.soundtracksetting = 0
			GAMEMODE.soundtrackchange = CurTime() + 1
		end
	end
	
	
   choices = player.GetAll()
   for i= 1, #choices do
      ply = choices[i]
      if ply:Alive() then
         if ply:WaterLevel() == 3 && GetRole( ply ) == ROLE_PLAYER then
          if ply.drown then
               if ply.drown < CurTime() then
                  local waterdamage = DamageInfo()
                 waterdamage:SetDamage(10)
                 waterdamage:SetDamageType(DMG_DROWN)
                 waterdamage:SetAttacker(game.GetWorld())
                 waterdamage:SetInflictor(game.GetWorld())
                  waterdamage:SetDamageForce(Vector(0,0,1))

                  ply:TakeDamageInfo(waterdamage)
			ply:EmitSound( "player/pl_drown"..math.random(1,3)..".wav" )

                  ply.drown = CurTime() + 2
               end
            else
               ply.drown = CurTime() + 4
            end
         else
            ply.drown = nil
         end
      end
   end
end


function GM:PlayerCanHearPlayersVoice( listener, talker )

	if GetConVar( "lab_alltalk" ):GetInt() == 1 then return true end

	if IsValid( listener ) and IsValid( talker ) then
		lrole = GetRole( listener )
		trole = GetRole( talker )
		
		
		if lrole == trole then
			return true
		elseif lrole == 0 then
			return true
		elseif trole == 0 then
			return false
		else
			if listener:GetPos():Distance(talker:GetPos()) < 500 then
				return true
			else
				return false
			end
		end
	end

	return true

end

function GM:PlayerCanSeePlayersChat( text, teamOnly, listener, speaker )

	
	if IsValid( listener ) and IsValid( speaker ) then
		lrole = GetRole( listener )
		trole = GetRole( speaker )
		
		if teamOnly then 
		
			return (lrole == trole or lrole == 0)
			
		elseif GetConVar( "lab_alltalk" ):GetInt() == 1 then 
		
			return true
			
		end
		
		
		if lrole == trole then
			return true
		elseif lrole == 0 then
			return true
		elseif trole == 0 then
			return false
		else
			if listener:GetPos():Distance(speaker:GetPos()) < 500 then
				return true
			else
				return false
			end
		end
	end

	return true

end

function GM:AllowPlayerPickup( ply, ent)
	return false
end

function GM:PlayerSwitchFlashlight(ply, SwitchOn)

	if GetRole( ply ) == ROLE_MINOTAUR then
		if ply.noisetimer == nil or ply.noisetimer <= CurTime() then
			ply:EmitSound( "npc/zombie/zombie_voice_idle"..math.random(1,8)..".wav", 100, 50 )
		if not IsValid( ply.flashlight ) or ply.flashlight == nil then
			ply.flashlight = ents.Create( "env_projectedtexture" )
			ply.flashlight:SetParent( ply )
			ply.flashlight:SetLocalPos( Vector( 0, 0, 150 ) )
			ply.flashlight:SetAngles(  Angle( 90, 0, 0 ) )
			ply.flashlight:SetKeyValue( "enableshadows", 0 )
			ply.flashlight:SetKeyValue( "farz", 750 )
			ply.flashlight:SetKeyValue( "nearz", 4 )
			ply.flashlight:SetKeyValue( "lightfov", 145 )
			local c = Color( 230, 25, 25 )
			ply.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r, c.g, c.b ) )
			ply.flashlight:Spawn()
		else
			ply.flashlight:Remove()
			ply.flashlight = nil
		end
			ply.noisetimer = CurTime() + 1.8
		end
	elseif GetRole( ply ) == ROLE_PLAYER then
		if ply.noisetimer == nil or ply.noisetimer <= CurTime() then
			ply.noisetimer = CurTime() + 1.8
			return true
		end
	end
end
 
net.Receive( "minigame" , function( len, ply )
	StartMinigame( ply )
end)

net.Receive( "labyrinthexplore" , function( len, ply )
	
	if (not GAMEMODE.minigameactive) and #player.GetAll() < 2 then
	
		GAMEMODE.minigameactive = true
	
		ply.flashlight = ents.Create( "env_projectedtexture" )
		ply.flashlight:SetParent( ply )
		ply.flashlight:SetLocalPos( Vector( 0, 0, 150 ) )
		ply.flashlight:SetAngles(  Angle( 90, 0, 0 ) )
		ply.flashlight:SetKeyValue( "enableshadows", 0 )
		ply.flashlight:SetKeyValue( "farz", 750 )
		ply.flashlight:SetKeyValue( "nearz", 4 )
		ply.flashlight:SetKeyValue( "lightfov", 145 )
		local c = Color( 230, 230, 230 )
		ply.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r, c.g, c.b ) )
		ply.flashlight:Spawn()
	
		GenerateMaze()
	end
end)

-- Garry decided to put a giant error above players' heads, this code fixes it (Credit to Deathrun coder Mr. Gash)
function GM:PlayerSetHandsModel( ply, ent )
 
 	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
 	local info = player_manager.TranslatePlayerHands( simplemodel )
 	if ( info ) then
		ent:SetModel( info.model )
 		ent:SetSkin( info.skin )
 		ent:SetBodyGroups( info.body )
	end
 
 end
---------------
