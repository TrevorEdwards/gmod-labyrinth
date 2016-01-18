function SetRoundState( state )
   GAMEMODE.round_state = state
   net.Start( "roundinfo" )
   net.WriteInt( state, 3 )
   net.Broadcast()
end

function GetRoundState()
   return GAMEMODE.round_state
end

function SetMinoRoom( room )
   GAMEMODE.minoroom = room
end

function GetMinoRoom()
   return GAMEMODE.minoroom
end

function SetPlayerRoom( room )
   GAMEMODE.playerroom = room
end

function GetPlayerRoom()
   return GAMEMODE.playerroom
end

function SetExitRoom( room )
   GAMEMODE.exitroom = room
end

function GetExitRoom()
   return GAMEMODE.exitroom
end



function FoundExit( ply )
	if GetRole( ply ) == ROLE_PLAYER then
		printAnnounce( ply:Nick().." has escaped the labyrinth!" )
		addDrachma( ply, 8 )
		ply:databaseIncrementValue( "escapes" )
		ply:databaseCheckRecord( "escapes" )
		addEvent( "escape", {ply} )
		MakeNormal( ply )
		ply:KillSilent()
		ply:Spawn()
		TeleportToLobby( ply )
		CheckForEnd()
	else
		printPlayer( ply, "This is the exit, defend it from humans!" )
	end
end

function CheckReadyPlayers()

   if GetRoundState() == ROUND_PRE then
   
	local ready = 0
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
   
	local fails = {}
	for k,v in pairs( humanchoices ) do
		if not v:IsPlayer() then
			table.insert( fails, v )
		end
	end
	for k,v in pairs( fails ) do
		table.RemoveByValue( humanchoices, v )
	end
	
	local fails = {}
	for k,v in pairs( normalchoices ) do
		if not v:IsPlayer() then
			table.insert( fails, v )
		end
	end
	for k,v in pairs( fails ) do
		table.RemoveByValue( normalchoices, v )
	end
	
	local fails = {}
	for k,v in pairs( minotaurchoices ) do
		if not v:IsPlayer() then
			table.insert( fails, v )
		end
	end
	for k,v in pairs( fails ) do
		table.RemoveByValue( minotaurchoices, v )
	end
	
   ready = #humanchoices + #minotaurchoices + #normalchoices
   minplayer = GetConVar( "lab_min_players" ):GetInt()
   
		if ready >= minplayer then
				if timer.Exists( "gamestart" ) then
					timer.Destroy( "gamestart" )
				end
				RoundSetup()
		else
			printAnnounce( "Failed to start round.  Not enough players. ("..ready.."/"..minplayer..")" )
			GameStartTimer()
			
		end
	end
end

function GameStartTimer()

	if timer.Exists( "gamestart" ) then
		timer.Destroy( "gamestart" )
	end
	
	timer.Create( "gamestart", GetConVar( "lab_readyup_time" ):GetInt(), 1, function()
		CheckReadyPlayers()
	end)
	
		GAMEMODE.readyuptime = CurTime() + GetConVar( "lab_readyup_time" ):GetInt()
	 net.Start( "readytime" )
		net.WriteDouble( GetConVar( "lab_readyup_time" ):GetInt() )
	net.Broadcast( )

end


function SetRole(ply, role)

	if IsValid( ply ) then
	
		ply:SetGamemodeTeam( role )
		net.Start( "myrole" )
		net.WriteInt( role, 4 )
		net.Send( ply )
	
	end
	
end

function GetRole( ply )

	return ply:GetNWInt( "role" )
	
end


function CheckForAbort()

 local playing = 0 
 choices = player.GetAll()
   for _, v in pairs(choices) do
      if IsValid(v) && GetRole( v ) > 0   then
         playing = playing + 1
      end
   end
   
   if playing < GetConVar( "lab_min_players" ):GetInt() then
		Abort()
      return true
   end

   return false
end

function Abort()

	if timer.Exists( "teleporter" ) then
		timer.Destroy( "teleporter" )
	end
	
	if timer.Exists( "shiva" ) then
		timer.Destroy( "shiva" )
	end
	
	if timer.Exists( "mazestart" ) then
		timer.Destroy( "mazestart" )
	end
	
	if timer.Exists( "gameend" ) then
		timer.Destroy( "gameend" )
	end
	
	processEvents()
	GAMEMODE.thirdperson = false
	GAMEMODE.squeakyfeet = false
	GAMEMODE.gameendsong = nil
	GAMEMODE.gamestartsong = nil
	GAMEMODE.soundtracksetting = 0
	GAMEMODE.minigameactive = false
	GAMEMODE.zombies = false
	GAMEMODE.humans = {}
	GAMEMODE.minotaurs = {}
	GAMEMODE.events = {}
	TeleportToLobby()
	local choices = player.GetAll()
		for k,v in pairs(choices) do
			if (IsValid(v)) then
			MakeNormal( v )
			end
		end
     RoundPre()
	 timer.Simple( 6 , function()
		ResetEverything()
	 end)
end

function CheckForEnd()

local playing = 0 
 choices = player.GetAll()
   for _, v in pairs(choices) do
      if IsValid(v) && (GetRole( v ) == 1 )  then
         playing = playing + 1
      end
   end
   
   minos = 0
   for _, v in pairs(choices) do
      if IsValid(v) && GetRole( v ) == 2 and v:Alive()  then
         minos = minos + 1
      end
   end
   
   if playing == 0 then
		Abort()
      return true
	elseif minos == 0 then
		if !timer.Exists( "gameend" ) or timer.TimeLeft( "gameend" ) > GetConVar( "lab_collapse_time" ):GetInt() then
		if timer.Exists( "teleporter" ) then
			timer.Destroy( "teleporter" )
			CreateExit()
			CreateGameTeleporterTimer( GetConVar( "lab_collapse_time" ):GetInt() )
		else
			if timer.TimeLeft( "gameend" ) > GetConVar( "lab_collapse_time" ):GetInt() then
				CreateGameTeleporterTimer( GetConVar( "lab_collapse_time" ):GetInt() )
			end
				printAnnounce( "All of the minotaurs have been slain!  The exit sphere is destabilizing!" )
		end
		end
		
		
   end

   return false

end

function AssignRoles()

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
	
	local fails = {}
	for k,v in pairs( humanchoices ) do
		if not v:IsPlayer() then
			table.insert( fails, v )
		end
	end
	for k,v in pairs( fails ) do
		table.RemoveByValue( humanchoices, v )
	end
	
	local fails = {}
	for k,v in pairs( normalchoices ) do
		if not v:IsPlayer() then
			table.insert( fails, v )
		end
	end
	for k,v in pairs( fails ) do
		table.RemoveByValue( normalchoices, v )
	end
	
	local fails = {}
	for k,v in pairs( minotaurchoices ) do
		if not v:IsPlayer() then
			table.insert( fails, v )
		end
	end
	for k,v in pairs( fails ) do
		table.RemoveByValue( minotaurchoices, v )
	end
	
   local totalplayers = #humanchoices + #minotaurchoices + #normalchoices
   
	local nummino = math.floor( (totalplayers * GetConVar( "lab_minotaur_ratio" ):GetFloat() + 1 ) )
	if nummino == 0 then nummino = 1 end
	
		for i = 1, nummino do
			local pool = minotaurchoices
			
			if #minotaurchoices == 0 then
				
				if #normalchoices > 0 then
					pool = normalchoices
				elseif #humanchoices > 0 then
					pool = humanchoices
				else
					printAnnounce( "ERROR: Not enough players!" )
					return
				end
			
			end
			
			minotaur = table.Random( pool )
			table.RemoveByValue( pool, minotaur )
			if IsValid( minotaur ) then
				SetRole(minotaur, ROLE_MINOTAUR)
				SetProperHealth( minotaur, ROLE_MINOTAUR, math.Round( totalplayers / nummino)  )
				local minspeed = 200 +  minotaur:GetNWInt( "speed" )  + math.Round( totalplayers / nummino)
				GAMEMODE:SetPlayerSpeed( minotaur, minspeed, minspeed - 150 )
				minotaur:SetNoTarget( true )
				minotaur:SetEyeAngles( Angle( 0, 45, 0 ) )
				minotaur:Freeze( true )
				table.insert( GAMEMODE.minotaurs, minotaur )
				
			end
	end

	table.Add( humanchoices, minotaurchoices )
	table.Add( humanchoices, normalchoices )
	
	for k,v in pairs( humanchoices ) do
	
		if IsValid(v) then
			SetRole(v, ROLE_PLAYER)
			SetProperHealth( v, ROLE_PLAYER, totalplayers )
			local pspeed = 200 +  v:GetNWInt( "speed" ) 
			GAMEMODE:SetPlayerSpeed( v, pspeed, pspeed - 150 )
			SetProperModel( v )
			v:SetNoTarget( true )
			table.insert( GAMEMODE.humans, v )
		end
		
	end
	
end

function RoundPre()
	SetRoundState(ROUND_PRE)
	GameStartTimer()
end

function RoundSetup()
	SetRoundState(ROUND_SETUP)
   AssignRoles()
   GenerateMaze()
   
end

function RoundPlay()
		for k,v in pairs( player.GetAll() ) do
			if IsValid( v ) then
				v:Freeze( false )
				if GetRole( v ) == ROLE_PLAYER then
					v:SetNoTarget( false )
				elseif GetRole( v ) == ROLE_MINOTAUR then
				
					local lhorn = ents.Create( "lminohorn" )
					lhorn:SetOwner( v ) 
					lhorn:SetPos( v:GetPos() )
					lhorn:Spawn()
		
					local rhorn = ents.Create( "rminohorn" )
					rhorn:SetOwner( v ) 
					rhorn:SetPos( v:GetPos() )
					rhorn:Spawn()
					
				end
			end
		end
		SetRoundState( ROUND_PLAY )
		SelectSoundtrack( 0 )
		printAnnounce( "The game has begun!  Survive until the teleporter sphere appears!", ROLE_PLAYER )
		printAnnounce( "The game has begun!  Kill the humans before they can escape!", ROLE_MINOTAUR )
end

function SelectSoundtrack( soundtype )

	local songchoice = nil
	
	if soundtype == 0 then
		if GAMEMODE.gamestartsong == nil then
			GAMEMODE.gamestartsong = table.Random( GAMESTARTSONGS )
			songchoice = GAMEMODE.gamestartsong
		else
			songchoice = GAMEMODE.gamestartsong
		end
	else
		if GAMEMODE.gameendsong == nil then
			GAMEMODE.gameendsong = table.Random( MINOTAURSONGS )
			songchoice = GAMEMODE.gameendsong
		else
			songchoice = GAMEMODE.gameendsong
		end
	end
	
	local tab = { }
	tab[1] = songchoice
	tab[2] = soundtype
	net.Start( "soundtrack" )
		net.WriteTable( tab )
	net.Broadcast()

end

function ResetEverything()

game.CleanUpMap()
SpawnVendors()
PaintDecals()

end

function CreateGameTeleporterTimer( collapsetime )

	if collapsetime == nil then 
		collapsetime = GetConVar( "lab_collapse_time" ):GetInt()
	end

	net.Start( "endtime" )
		net.WriteDouble( CurTime() + collapsetime, 32 )
	net.Broadcast()
	
	if timer.Exists( "gameend" ) then
		timer.Destroy( "gameend" )
	end
	
  if !timer.Exists( "gameend" ) then
	timer.Create( "gameend", collapsetime, 1, function()
		if GetRoundState() == ROUND_PLAY then
			local choices = player.GetAll()
			local humannum = 0
			local minos = {}
			for k,v in pairs( choices ) do
				if IsValid( v ) then
					if GetRole( v ) == ROLE_PLAYER then
						humannum = humannum + 1
					elseif GetRole( v ) == ROLE_MINOTAUR then
						minos[ #minos + 1 ] = v
					else
					
					end
				end
			end
			printAnnounce(  "The teleporter has collapsed on itself!" )
			Abort()
		end
	end)

	end
end

function MakeNormal( ply )

	if IsValid( ply ) then
		SetRole(ply, ROLE_OBSERVER)
		ply:KillSilent()
		ply:SetGravity( 1 )
		ply:StripWeapons()
		ply.ready = false
		ply.heartbeat = false
		ply:Freeze( false )
		ply:SetNoTarget( false )
		ply:Extinguish()
		SetProperModel( ply )
		ply:SetColor( Color( 255,255,255,255 ) )
		ply:SetMaterial( "" )
		if IsValid( ply.flashlight ) then
			ply.flashlight:Remove()
		end
		ply:Flashlight( false )
		ply:AllowFlashlight( false )
		ply:SetObserverMode( OBS_MODE_NONE )
		GAMEMODE:SetPlayerSpeed( ply, 300, 150 )
		if !ply:Alive() then ply:Spawn() end
	end

end