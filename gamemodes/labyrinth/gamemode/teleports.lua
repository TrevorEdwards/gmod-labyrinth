function TeleportToMaze()
	
	if GAMEMODE.minigameactive then
		for k,v in pairs( player.GetAll() ) do
			if IsValid( v ) then
				v:SetPos( GetPlayerRoom().ctrpos + Vector( 0, 0, 3 ) )
			end
		end
	end
	
	people = player.GetAll()
	
	for k,v in pairs(people) do
		if !IsValid(v) then
			table.RemoveByValue( people, v )
		end
	end
	
	hurom = GetPlayerRoom().ctrpos + Vector( 0, 0, 3 )
	minrom = GAMEMODE.minoroom.ctrpos + Vector(0,0,3)

	if  GetPlayerRoom() != nil && GetMinoRoom() != nil then
	for k,cat in pairs( people ) do
		if IsValid( cat ) then
			daRole = GetRole( cat )
				if daRole == 1 then
					cat:AllowFlashlight( true )
					cat:SetPos( hurom )
					if GAMEMODE.playerroom.orientation == 1 then
						cat:SetEyeAngles( Angle( 0, -89.8, 0 ) )
					else
						cat:SetEyeAngles( Angle( 0, -179.8, 0 ) )
					end
					
				elseif daRole == 2  then
					cat:AllowFlashlight( true )
					cat:SetPos( minrom )
					cat:Freeze( false )
					cat:SetEyeAngles( Angle( 0, 45, 0 ) )
					cat:Freeze( true )
						net.Start( "telepos" )
							local telpos = GetExitRoom().ctrpos
							net.WriteVector( telpos )
						net.Send( cat )
				else
				end
		end		
	end
	end

end

function TeleportToLobby( ply )

	starttarget = ents.FindByName( "spawnroom" )[1]
	if ply == nil then
		if starttarget != nil then
		local choices = player.GetAll()
		for k,v in pairs( choices ) do
			if IsValid( v ) and GetRole( v ) > 0 then
				v:SetPos(starttarget:GetPos())
				v:SetEyeAngles( starttarget:GetAngles() )
			end
			
		end

		end
		else
		if IsValid(ply) then
			ply:SetPos(starttarget:GetPos())
			ply:SetEyeAngles( starttarget:GetAngles() )
		end
	end
end