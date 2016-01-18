local ply = FindMetaTable("Player")
util.AddNetworkString( "database" )

PLYDATADEFAULTS = {
	
	["name"] = "Noob",
	["drachma"] = 0,
	["speed"] = 1,
	["health"] = 1,
	["humankills"] = 0,
	["minotaurkills"] = 0, 
	["minigamewins"] = 0,
	["gamewins"] = 0,
	["sprays"] = 0,
	["escapes"] = 0,
	["lifetimedrachma"] = 0,
	["drachmamultiplier"] = 1,
	["minomodel"] = "models/player/corpse1.mdl",
	["humanmodel"] = "models/player/Group01/Male_01.mdl",
	["models"] = { "models/player/Group01/Male_01.mdl", "models/player/corpse1.mdl" }
	
}

SERVERDATADEFAULTS = {
	
	["gamewins"] = 0,
	["gamewinsname"] = "TB002",
	["humankills"] = 0,
	["humankillsname"] = "TB002",
	["minotaurkills"] = 0,
	["minotaurkillsname"] = "TB002",
	["escapes"] = 0,
	["escapesname"] = "TB002",
	["minigamewins"] = 0,
	["minigamewinsname"] = "TB002",
	["lifetimedrachma"] = 0,
	["lifetimedrachmaname"] = "TB002",
	["sprays"] = 0,
	["spraysname"] = "TB002"
	
}

function sdatabaseDefault()
	sdatabaseSetValue( "humankills", 0 )
	sdatabaseSetValue( "humankillsname", "TB002" )
	sdatabaseSetValue( "minotaurkills", 0 )
	sdatabaseSetValue( "minotaurkillsname", "TB002" )
	sdatabaseSetValue( "escapes", 0 )
	sdatabaseSetValue( "escapesname", "TB002" )
	sdatabaseSetValue( "minigamewins", 0 )
	sdatabaseSetValue( "minigamewinsname", "TB002" )
	sdatabaseSetValue( "lifetimedrachma", 0 )
	sdatabaseSetValue( "lifetimedrachmaname", "TB002" )
	sdatabaseSetValue( "gamewins", 0 )
	sdatabaseSetValue( "gamewinsname", "TB002" )
	sdatabaseSetValue( "sprays", 0 )
	sdatabaseSetValue( "spraysname", "TB002" )
end

function scheckEntryExists( name )
	if sdatabaseGet()[name] == nil then
		sdatabaseSetValue( name, SERVERDATADEFAULTS[name] )
	end
end

function sdatabaseSet( tab )
	sdatabase = tab
end

function ply:databaseCheckRecord( name )

	local plyval = self:databaseGetValue( name )
	local servval = sdatabaseGetValue( name )
	if plyval > servval then
		sdatabaseSetValue( name, plyval )
		sdatabaseSetValue( name.."name", self:Nick() )
	end

		sdatabaseSave()
end

function sdatabaseSetValue( name, v)

	if not v then return end
	
	local d = sdatabaseGet()
	d[name] = v
	
	sdatabaseSave()

end

function sdatabaseRead()
	local str = file.Read(sdatabasePath(), "DATA")
	sdatabaseSet( util.KeyValuesToTable(str) )
end

function sdatabaseCheck()
	sdatabase = {}
	local f = sdatabaseExists()
	if f then
		sdatabaseRead()
	else
		sdatabaseCreate()
	end
end

function sdatabaseGetValue( name )
	local dab = sdatabaseGet()
	scheckEntryExists( name )
	return dab[name]
end



function sdatabaseGet()

	return sdatabase
end


function sdatabaseCreate()
	sdatabaseDefault()
	local b = file.CreateDir( sdatabaseFolders() )
	sdatabaseSave()
end

function sdatabaseSave()
	local str = util.TableToKeyValues(sdatabase)
	local f = file.Write(sdatabasePath(), str)
end

function sdatabaseExists()
	local datafile = file.Exists(sdatabasePath(), "DATA")
	return datafile
end

function sdatabaseFolders()

	return "labyrinth/server/"
end

function sdatabasePath()

	return sdatabaseFolders() .. "database.txt"
	
end

function ply:ShortSteamID()

	local id = self:SteamID()
	local id = tostring(id)
	local id = string.Replace(id, "STEAM_0:0:", "")
	local id = string.Replace(id, "STEAM_0:1:", "")
	return id
	
end

--make sure all of these are copied to data defaults
function ply:databaseDefault()

	self:databaseSetValue( "name", self:Nick() )
	self:databaseSetValue( "drachma", 0 )
	self:databaseSetValue( "speed", 1 )
	self:databaseSetValue( "health", 1 )
	self:databaseSetValue( "humankills", 0 )
	self:databaseSetValue( "minotaurkills", 0 )
	self:databaseSetValue( "minigamewins", 0 )
	self:databaseSetValue( "gamewins", 0 )
	self:databaseSetValue( "sprays", 0 )
	self:databaseSetValue( "escapes", 0 )
	self:databaseSetValue( "lifetimedrachma", 0 )
	self:databaseSetValue( "drachmamultiplier", 1 )
	self:databaseSetValue( "minomodel" , "models/player/corpse1.mdl" )
	self:databaseSetValue( "humanmodel" , "models/player/Group01/Male_01.mdl" )
	local i = {}
	i[1] = "models/player/Group01/Male_01.mdl"
	i[2] = "models/player/corpse1.mdl"
	self:databaseSetValue( "models", i )
	HelpMenu( self )
	
end


function ply:databaseNetworkedData()


	local drachma = self:databaseGetValue( "drachma" )
	local speed = self:databaseGetValue( "speed" )
	local health = self:databaseGetValue( "health" )
	self:SetNWInt("drachma", drachma)
	self:SetNWInt("speed", speed)
	self:SetNWInt("health", health)
	
	
end


function ply:databasePath()

	return self:databaseFolders() .. "database.txt"
	
end

function ply:databaseSet( tab )
	self.database = tab
	
	
end

function ply:databaseRead()
	local str = file.Read(self:databasePath(), "DATA")
	self:databaseSet( util.KeyValuesToTable(str) )
end

function ply:databaseGet()

	return self.database
end

function ply:checkEntryExists( name )
	if not IsValid( self ) then return end
	if self:databaseGet()[name] == nil then
		self:databaseSetValue( name, PLYDATADEFAULTS[name] )
	end
end

function ply:databaseCheck()
	self.database = {}
	local f = self:databaseExists()
	if f then
		self:databaseRead()
	else
		self:databaseCreate()
	end
	self:databaseSend()
	self:databaseNetworkedData()
end
	


function ply:databaseSend()
	net.Start( "database" )
		net.WriteTable( self:databaseGet() )
	net.Send( self )
	
end

function ply:databaseDisconnect()
	self:databaseSave()
end

function ply:databaseExists()
	local datafile = file.Exists(self:databasePath(), "DATA")
	return datafile
end


function ply:databaseSave()
	local str = util.TableToKeyValues(self.database)
	local f = file.Write(self:databasePath(), str)
	self:databaseSend()
end

function ply:databaseCreate()
	self:databaseDefault()
	local b = file.CreateDir( self:databaseFolders() )
	self:databaseSave()
end


function ply:databaseSetValue( name, v )
	if not v then return end
	
	local d = self:databaseGet()
	d[name] = v
	
	self:databaseSave()
end

function ply:databaseAddValue( name, v )
	if not v then return end
	self:checkEntryExists( name )
	
	local d = self:databaseGet()
	d[name] = d[name] + v
	
	self:databaseSave()
end

function ply:databaseIncrementValue( name )
	
	local d = self:databaseGet()
	self:checkEntryExists( name )
	
	d[name] = d[name] + 1
	
	self:databaseSave()
end

function ply:databaseFolders()

	return "labyrinth/players/"..self:ShortSteamID().."/"
end

function ply:databaseGetValue( name )
	if not IsValid( self ) then return end
	local dab = self:databaseGet()
	self:checkEntryExists( name )
	return dab[name]
end