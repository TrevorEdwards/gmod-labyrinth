
function addDrachma( ply, amount, reason, applymultiplier )
	if applymultiplier == nil then applymultiplier = true end
	if applymultiplier then
	local multy = ply:databaseGetValue( "drachmamultiplier" )
	local smulty = GetConVar( "lab_globaldrachmamultiplier" ):GetFloat()
	if multy != nil then
		amount = math.Round( amount * multy )
	end
	if smulty != nil then
		amount = math.Round( amount * smulty )
	end
	end
	local curPoints = ply:databaseGetValue( "drachma" )
	if curPoints == nil then return end
	local newPoints = curPoints + amount
	ply:databaseSetValue ( "drachma", newPoints )
	ply:databaseAddValue( "lifetimedrachma", amount )
	ply:databaseCheckRecord( "lifetimedrachma" )
	if reason == nil then
		printPlayer( ply, "You received "..amount.." drachma!" )
	else
		printPlayer( ply, "You received "..amount.." drachma for"..reason )
	end
	ply:databaseCheck()
	
	net.Start( "drachma" )
   net.WriteInt( ply:databaseGetValue( "drachma" ), 30 )
   net.Send( ply )
end

function addDrachmaTable( tab, amount, reason )
	for k,v in pairs( tab ) do
		addDrachma( v, amount, reason )
	end
end

function RemoveDrachma( ply, amount )
	drachma = ply:databaseGetValue( "drachma" )
		if drachma >= amount then
			ply:databaseSetValue( "drachma", drachma - amount )
			
			net.Start( "drachma" )
			net.WriteInt( ply:databaseGetValue( "drachma" ), 30 )
			net.Send( ply )
			return true
		else
			return false
		end
end

net.Receive( "skillupgrade", function( len, ply)

	drachma = ply:databaseGetValue( "drachma" )
	skill = net.ReadString()
	if skill == "speed" then
		speed = ply:databaseGetValue( "speed" )
		cost = 8 + 2^speed
		if RemoveDrachma( ply, cost ) then
		
			timer.Simple(2, function()
				vendor = ents.FindByClass( "npc_skills" )[1]
				if IsValid( vendor ) then
					vendor:EmitSound("vo/npc/male01/moan0"..math.random(1,5)..".wav")
				end
			end)
			
			ply:databaseSetValue( "speed", speed + 1 )
			printPlayer( ply, "Upgraded speed to "..(speed + 1).." for "..cost.." Drachma.")
			ply:databaseCheck()
			ply:EmitSound("vo/npc/male01/fantastic0"..math.random(1,2)..".wav")
		else
			printPlayer( ply, "Not enough Drachma." )
		end
	else
		health = ply:databaseGetValue( "health" )
		cost = 8 + 2^health
		if RemoveDrachma( ply, cost ) then
		
			timer.Simple(2 , function()
				vendor = ents.FindByClass( "npc_skills" )[1]
				if IsValid( vendor ) then
					vendor:EmitSound("vo/npc/male01/moan0"..math.random(1,5)..".wav")
				end
			end)
			
			ply:databaseSetValue( "health", health + 1 )
			printPlayer( ply, "Upgraded health to "..(health + 1).." for "..cost.." Drachma.")
			ply:databaseCheck()
			ply:EmitSound("vo/npc/male01/fantastic0"..math.random(1,2)..".wav")
		else
			printPlayer( ply, "Not enough Drachma." )
		end
	
	end


end)


net.Receive( "selectmodel", function( len, ply)

	drachma = ply:databaseGetValue( "drachma" )
	unlockedmodels = ply:databaseGetValue( "models" )
	model = net.ReadInt( 16 )
	kind = net.ReadInt( 4 )
	
	if kind == 0 then
		data = HUMANMODELS[model]
	else
		data = MINOMODELS[model]
	end
	
	if data and unlockedmodels and drachma then
		if table.HasValue( unlockedmodels, data.model ) then
			if kind == 0 then
				ply:databaseSetValue( "humanmodel" , data.model )
				printPlayer( ply, "Set human model to "..data.name.. "." )
			else
				ply:databaseSetValue( "minomodel" , data.model )
				printPlayer( ply, "Set minotaur model to "..data.name.. "." )
			end
			ply:databaseCheck()
			SetProperModel( ply )
		else
			cost = data.cost
			if RemoveDrachma( ply, cost ) then
			
				if cost >= 100 then
					timer.Simple(3, function()
						alyx = ents.FindByClass( "npc_models" )[1]
						alyx:EmitSound( "vo/k_lab/al_buyyoudrink0"..math.random(1,3)..".wav" )
					end)
				end
				
				table.insert( unlockedmodels, #unlockedmodels + 1, data.model )
				ply:databaseSetValue( "models", unlockedmodels )
				ply:EmitSound("vo/npc/male01/fantastic0"..math.random(1,2)..".wav")
			
				if kind == 0 then
					ply:databaseSetValue( "humanmodel" , data.model )
				else
					ply:databaseSetValue( "minomodel" , data.model )
				end
				printPlayer( ply, "Unlocked and equipped "..data.name.. "." )
				ply:databaseCheck()
				SetProperModel( ply )
			else
				printPlayer( ply, "Not enough Drachma." )
			end
		end
	end
end)

concommand.Add( "giveDrachma", function( ply, cmd, args, fullstring )

	if not IsValid( ply ) or (IsValid( ply ) and ply:IsAdmin()) then
	local name = args[1]
	local amount = args[2]
	local recip = nil
	for k,v in pairs( player.GetAll() ) do
	
		if IsValid( v ) and v:IsPlayer() and string.find( v:Nick(), name, 0, false ) != nil then
			recip = v
		end
		
	end
	
	if IsValid( recip ) and recip:IsPlayer() then
		print( "Gave "..recip:Nick().." "..amount.." drachma." )
		addDrachma( recip, amount, " some reason.", false )
		
	else
		print( "Failed to find specified player." )
	end
	end
	
	

end)

concommand.Add( "giveDrachmaSID", function( ply, cmd, args, fullstring )

	if not IsValid( ply ) or (IsValid( ply ) and ply:IsAdmin()) then
	local name = args[1]
	local amount = args[2]
	local recip = nil
	if amount == nil then return end
	for k,v in pairs( player.GetAll() ) do
	
		if IsValid( v ) and v:IsPlayer() and string.find( v:SteamID(), name, 0, false ) != nil then
			recip = v
		end
		
	end
	
	if IsValid( recip ) and recip:IsPlayer() then
		print( "Gave "..recip:Nick().." "..amount.." drachma." )
		addDrachma( recip, amount )
		
	else
		print( "Failed to find specified player." )
	end
	end

end)

concommand.Add( "setDrachmaMultiplier", function( ply, cmd, args, fullstring )

	if not IsValid( ply ) or (IsValid( ply ) and ply:IsAdmin()) then
	local name = args[1]
	local amount = args[2]
	local recip = nil
	for k,v in pairs( player.GetAll() ) do
	
		if IsValid( v ) and v:IsPlayer() and string.find( v:Nick(), name, 0, false ) != nil then
			recip = v
		end
		
	end
	
	if IsValid( recip ) and recip:IsPlayer() then
		print( "Set "..recip:Nick().."'s drachma multiplier to "..amount )
		recip:databaseSetValue ( "drachmamultiplier", amount )
		printPlayer( recip, "Your drachma multiplier has been set to "..amount.."." )
		
	else
		print( "Failed to find specified player." )
	end
	end

end)

concommand.Add( "setDrachmaMultiplierSID", function( ply, cmd, args, fullstring )

	if not IsValid( ply ) or (IsValid( ply ) and ply:IsAdmin()) then
	local name = args[1]
	local amount = args[2]
	local recip = nil
	if amount == nil then return end
	for k,v in pairs( player.GetAll() ) do
	
		if IsValid( v ) and v:IsPlayer() and string.find( v:SteamID(), name, 0, false ) != nil then
			recip = v
		end
		
	end
	
	if IsValid( recip ) and recip:IsPlayer() then
		print( "Set "..recip:Nick().."'s drachma multiplier to "..amount )
		recip:databaseSetValue ( "drachmamultiplier", amount )
		printPlayer( recip, "Your drachma multiplier has been set to "..amount.."." )
		
	else
		print( "Failed to find specified player." )
	end
	end

end)
