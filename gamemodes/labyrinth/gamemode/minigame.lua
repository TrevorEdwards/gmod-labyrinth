function StartMinigame( ply )
	if GAMEMODE.minigameactive or GetRoundState() > ROUND_PRE or #player.GetAll() > 1 then 
		return false
	end
	ply:SetHealth( 1 )
	GAMEMODE.minigameactive = true
	-- generate the tunnel including three melon cannon things
	local len = 38
	local startLoc = ents.FindByName( "mazecorner" )[1]
	local material = "models/props_wasteland/quarryobjects01"
	local propsize = 3
	local propwidth = 3 * 47
	local proprad = propwidth / 2
	
	for i = 1, len do
		local ctrpos = startLoc:GetPos() - Vector(i * (propwidth) , 0, 1 )
		
		local ent = ents.Create( "trap_light" )
			ent:SetPos( ctrpos + Vector( 0, 0, 158 ) )
			ent:Spawn()
			ent:Activate()
		
		local wally = ents.Create( "prop_physics" )
		wally:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
		wally:SetPos( ctrpos + Vector(0 , proprad - 5 , proprad  ) )
		wally:SetAngles( Angle(90,90,0) )
		wally:SetMaterial(material)
		wally:Spawn()
		wally:GetPhysicsObject():EnableMotion( false )
		
		local wally2 = ents.Create( "prop_physics" )
		wally2:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
		wally2:SetPos( ctrpos + Vector( 0 , -proprad + 5 , proprad  ) )
		wally2:SetAngles( Angle(90,90,0) )
		wally2:SetMaterial(material)
		wally2:Spawn()
		wally2:GetPhysicsObject():EnableMotion( false )
		if i == 1 then
			local wally = ents.Create( "prop_physics" )
		wally:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
		wally:SetPos( ctrpos + Vector(proprad , 0 , proprad  ) )
		wally:SetAngles( Angle(90,0,0) )
		wally:SetMaterial(material)
		wally:Spawn()
		wally:GetPhysicsObject():EnableMotion( false )
		end
		
		if i == len then
		
				local wally = ents.Create( "prop_physics" )
		wally:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
		wally:SetPos( ctrpos + Vector(-proprad , 0 , proprad  ) )
		wally:SetAngles( Angle(90,0,0) )
		wally:SetMaterial(material)
		wally:Spawn()
		wally:GetPhysicsObject():EnableMotion( false )
		
		-- place a drachma at the end
		local drachma = ents.Create( "package_drachma" )
		drachma:SetPos( ctrpos + Vector( 450, 0, 65 ) )
		drachma:Spawn()
		
		local cannon = ents.Create( "minigame_meloncannon" )
		cannon:SetPos( ctrpos + Vector( 0, 42, 15 ) )
		cannon:Spawn()
		
		local cannon = ents.Create( "minigame_meloncannon" )
		cannon:SetPos( ctrpos + Vector( 0, 0, 15 ) )
		cannon:Spawn()
		
		local cannon = ents.Create( "minigame_meloncannon" )
		cannon:SetPos( ctrpos + Vector( 0, -42, 15 ) )
		cannon:Spawn()
		
		local controller = ents.Create( "minigame_meloncontroller" )
		controller:SetPos( ctrpos + Vector( 0, 0, 100 ) )
		controller:Spawn()
		
		end
	end
	-- teleport the player in, set angles
	ply:SetPos( startLoc:GetPos() + Vector( -120, 0, 3) )
	ply:SetEyeAngles( Angle( 0, 180, 0 ) )
	local sound = table.Random( MINIGAMESONGS )
	ply:EmitSound( sound )
	ply:Freeze( true )
	printPlayer( ply, "Get ready" )
	timer.Simple( 6, function()
		ply:Freeze( false )
		if GAMEMODE.minigameactive then
			printPlayer( ply, "Go!" )
		end
	end)
	-- reset map when player dies or when coin grabbed GM.minigameactive
end

function EndMinigame()

	if GAMEMODE.minigameactive and GetRoundState() == ROUND_PRE then
		timer.Simple( 1, function()
			ResetEverything()
		end )
		GAMEMODE.minigameactive = false
	end
	
end