local database = {}

local function databaseReceive( tab )
	database = tab
end
net.Receive("database", function(len)
	local datatable = net.ReadTable()
	databaseReceive( datatable )
end)

function databaseTable()
	return database
end

function databaseGetValue( name )
	local d = databaseTable()
	return d[name]
end