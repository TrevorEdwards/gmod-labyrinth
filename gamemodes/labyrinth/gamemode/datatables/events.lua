EVENTS = {
	
	["humankill"] =
	{
		weight = 1,
		minotaurscoreadd = 2,
		description = function( args )
			return args[1]:Nick().." ate "..args[2]:Nick().."'s crowbar!"
		end
	},
	
	["escape"] =
	{
		weight = 4,
		humanscoreadd = 2,
		description = function( args )
			return args[1]:Nick().." escaped the Labyrinth!"
		end
	},
	
	["minokill"] =
	{
		weight = 3,
		humanscoreadd = 6,
		description = function( args )
			return args[1]:Nick().." slayed "..args[2]:Nick().."!"
		end
	},
	
	["melonkill"] =
	{
		weight = 3,
		positive = false,
		scoreadd = 2,
		description = function( args )
			return args[1]:Nick().." was hit by a flying prop!"
		end
	},
	
	["crushkill"] =
	{
		weight = 3,
		positive = false,
		scoreadd = 2,
		description = function( args )
			return args[1]:Nick().." got crushed!"
		end
	},
	
	["mysterykill"] =
	{
		weight = 3,
		positive = false,
		scoreadd = 2,
		description = function( args )
			return args[1]:Nick().." died in a stupid way!"
		end
	},
	
	["spray"] =
	{
		weight = 1,
		positive = true,
		scoreadd = 1,
		description = function( args )
			return args[1]:Nick().." knows how to use a spray can!"
		end
	}
	
}

function processEvents()
	
	table.SortByMember( GAMEMODE.events, "weight" )
	local humankills = 0
	local minokills = 0
	local escapes = 0
	local humanscore = 0
	local minoscore = 0
	local specialmessage = ""
	local sendtab = {}
	
	for k,v in pairs( GAMEMODE.events ) do
		
		local ev = v.eventtype 
		
		if ev == "humankill" then
			humankills = humankills + 1
		elseif ev == "minokill" then
			minokills = minokills + 1
		elseif ev == "escape" then
			escapes = escapes + 1
		end
		
		if EVENTS[ ev ].minotaurscoreadd != nil then
			minoscore = minoscore + EVENTS[ ev ].minotaurscoreadd
		end
		
		if EVENTS[ ev ].humanscoreadd != nil then
			humanscore = humanscore + EVENTS[ ev ].humanscoreadd
		end
		
		if EVENTS[ ev ].scoreadd != nil then
		
			if table.HasValue( GAMEMODE.humans, v.args[1] ) then
				if EVENTS[ ev ].positive then
					humanscore = humanscore + EVENTS[ ev ].scoreadd
				else
					minoscore = minoscore + EVENTS[ ev ].scoreadd
				end
			elseif table.HasValue( GAMEMODE.minotaurs, v.args[1] ) then
				if EVENTS[ ev ].positive then
					minoscore = minoscore + EVENTS[ ev ].scoreadd
				else
					humanscore = humanscore + EVENTS[ ev ].scoreadd
				end
			end
			
		end
	
		
	end
	
	if (humanscore + minoscore) == 0 then
		minoscore = 1
	end
	
	local winscore = (humanscore / (humanscore + minoscore)) * 100
	
	if winscore < 50 then
		addDrachmaTable( GAMEMODE.minotaurs, 10, " beating the humans!" )
		for k,v in pairs( GAMEMODE.minotaurs ) do
			if IsValid( v ) then
				v:databaseIncrementValue( "gamewins" )
				v:databaseCheckRecord( "gamewins" )
			end
		end
	elseif winscore > 50 then
		addDrachmaTable( GAMEMODE.humans, 10, " beating the minotaurs!" )
		for k,v in pairs( GAMEMODE.humans ) do
			if IsValid( v ) then
				v:databaseIncrementValue( "gamewins" )
				v:databaseCheckRecord( "gamewins" )
			end
		end
	end
	
	if winscore == nil then winscore = 50 end
	sendtab[ "winscore" ] = winscore
	sendtab[ "humankills" ] = "Humans killed by minotaurs: "..humankills
	sendtab[ "minokills" ] = "Minotaurs killed by humans: "..minokills
	sendtab[ "escapes" ] = "Escapes: "..escapes
	if humankills == 0 then
		specialmessage = "The minotaurs could not kill anyone with their crowbars!"
	elseif escapes == 0 then
		specialmessage = "Nobody escaped!"
	elseif #GAMEMODE.events > 0 then
		specialmessage = table.Random( GAMEMODE.events).description
	else
		specialmessage = "Nothing of interest happened."
	end
	
	sendtab[ "specialmessage" ] = specialmessage
	sendEvents( sendtab )
	
end

function sendEvents( sendevents )
	
	net.Start( "endgamereport" )
		net.WriteTable( sendevents )
	net.Broadcast()
	
end

function addEvent( name, argus )
	local theEvent = EVENTS[name]
	if theEvent == nil then return end
	
	local eventdata = {
		eventtype = name,
		weight = theEvent.weight,
		description = theEvent.description( argus ),
		args = argus
	}
	
	table.insert( GAMEMODE.events, eventdata )
end