MAZEMATERIALS = {

	"models/props_debris/plasterwall009d",
	"models/props_pipes/pipemetal001a",
	"models/props_wasteland/quarryobjects01",
	"models/XQM//LightLinesGB",
	"models/XQM//SquaredMat",
	"models/XQM/BoxFull_diffuse",
	"models/props_canal/metalwall005b",
	"phoenix_storms/bluemetal"
	

}


function OpenWater()

	block = ents.FindByName( "waterblock" )[1]
	if IsValid( block ) then
		block:Fire("Open","",0)
	end

end

function GenerateMaze( )

len = math.floor( GetConVar( "lab_maze_base_length" ):GetInt() + GetConVar( "lab_maze_extension" ):GetFloat() * (#GAMEMODE.humans + #GAMEMODE.minotaurs) )
height = 97
propsize = math.random( GetConVar( "lab_wall_min_size" ):GetInt(), GetConVar( "lab_wall_max_size" ):GetInt() )
randomroomperroom = GetConVar( "lab_special_ratio" ):GetFloat()
randomeffects = GetConVar( "lab_random_effects" ):GetInt()


if len > 15 then len = 15 end
if GAMEMODE.minigameactive then len = 22 end

timer.Simple( 0.3, function()

timer.Simple( 0.2, function()

grid = {}
pool = {}
normalcells = {}
mazecells = {}
walls = {}
theSize = propsize
lightcounter = 0
lightcounterreset = 5

	
material = table.Random( MAZEMATERIALS )

-- Random Effects
	--raneff = table.Copy( RANDOMEFFECTS )
--	f--or i = 1, randomeffects do
		--	if #raneff > 0 then
		--	effect = table.Random( raneff )
			--while(effect != nil && checkEffectAllowed( effect.var ) != true && #raneff > 0) do
			--	table.RemoveByValue(raneff, effect)
				--effect = table.Random(raneff)
		--	end
			--if(effect != nil && checkEffectAllowed( effect.var )) then
			--	effect.activate()
			--	printAnnounce( effect.announce )
			--	table.RemoveByValue(raneff, effect)
		--	end
	--	end
--	end
------

propwidth = propsize * 47
proprad = propwidth / 2
properheight = (propwidth - 95) * (height / 180.0) + 95
startLoc = ents.FindByName( "mazecorner" )[1]
count = 0
--Create cell table, give each cell a position, visited status Done
for i = 1, len do
    grid[i] = {}
    for j = 1, len do
		px = i * propwidth
		py = j * propwidth
		cx = i * propsize * 48
		cy = j * propsize * 48
		local imod = len - i + 2
		local jmod = len - j + 2
		-- j is up/down
		-- i is left/right
        grid[i][j] = { 
				
				ctrpos = startLoc:GetPos() - Vector(px , py, 1 ),
				partOfMaze = false,
				attribute = ROOM_NORMAL,
				walls = {
					},
				rowx =i,
				rowy = j
			}
		-- left wall
			if i > 1  and grid[i-1][j] != nil and IsValid( grid[i-1][j].walls.wall2 ) then
					grid[i][j].walls.wall1 = grid[i-1][j].walls.wall2
					grid[i][j].walls.wall1.parent2 = grid[i][j]
					grid[i][j].walls.wall1.shared = true
				else
					grid[i][j].walls.wall1 = ents.Create( "prop_physics" )
					grid[i][j].walls.wall1:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
					grid[i][j].walls.wall1:SetPos( grid[i][j].ctrpos + Vector(proprad , 0 , proprad  ) )
					grid[i][j].walls.wall1:SetAngles(Angle(90,0,0))
					grid[i][j].walls.wall1:SetMaterial(material)
					grid[i][j].walls.wall1:Spawn()
					grid[i][j].walls.wall1:GetPhysicsObject():EnableMotion( false )
					grid[i][j].walls.wall1.parent = grid[i][j]
					grid[i][j].walls.wall1.location = LOCATION_LEFT
					grid[i][j].walls.wall1.exists = true
			end
			-- right wall
					grid[i][j].walls.wall2 = ents.Create( "prop_physics" )
					grid[i][j].walls.wall2:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
					grid[i][j].walls.wall2:SetPos( grid[i][j].ctrpos + Vector(-proprad , 0 , proprad  ) )
					grid[i][j].walls.wall2:SetAngles(Angle(90,0,0))
					grid[i][j].walls.wall2:SetMaterial(material)
					grid[i][j].walls.wall2:Spawn()
					grid[i][j].walls.wall2:GetPhysicsObject():EnableMotion( false )
					grid[i][j].walls.wall2.parent = grid[i][j]
					grid[i][j].walls.wall2.location = LOCATION_RIGHT
					grid[i][j].walls.wall2.exists = true
			-- bottom wall
			if j > 1 and grid[i][j - 1] != nil and IsValid( grid[i][j-1].walls.wall4 ) then
					grid[i][j].walls.wall3 = grid[i][j-1].walls.wall4
					grid[i][j].walls.wall3.parent2 = grid[i][j]
					grid[i][j].walls.wall3.shared = true
				else
					grid[i][j].walls.wall3 = ents.Create( "prop_physics" )
					grid[i][j].walls.wall3:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
					grid[i][j].walls.wall3:SetPos( grid[i][j].ctrpos + Vector(0 , proprad , proprad  ) )
					grid[i][j].walls.wall3:SetAngles(Angle(90,90,0))
					grid[i][j].walls.wall3:SetMaterial(material)
					grid[i][j].walls.wall3:Spawn()
					grid[i][j].walls.wall3:GetPhysicsObject():EnableMotion( false )
					grid[i][j].walls.wall3.parent = grid[i][j]
					grid[i][j].walls.wall3.location = LOCATION_BOTTOM
					grid[i][j].walls.wall3.exists = true
			end
			-- top wall
					grid[i][j].walls.wall4 = ents.Create( "prop_physics" )
					grid[i][j].walls.wall4:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
					grid[i][j].walls.wall4:SetPos( grid[i][j].ctrpos + Vector(0 , -proprad , proprad  ) )
					grid[i][j].walls.wall4:SetAngles(Angle(90,90,0))
					grid[i][j].walls.wall4:SetMaterial(material)
					grid[i][j].walls.wall4:Spawn()
					grid[i][j].walls.wall4:GetPhysicsObject():EnableMotion( false )
					grid[i][j].walls.wall4.parent = grid[i][j]
					grid[i][j].walls.wall4.location = LOCATION_TOP
					grid[i][j].walls.wall4.exists = true

			if lightcounter >= lightcounterreset or ( math.random(1,8) == 1 and lightcounter >= 2 ) then
				local ent = ents.Create( "trap_light" )
					ent:SetPos( grid[i][j].ctrpos + Vector( 0, 0, 158 ) )
					ent:Spawn()
					ent:Activate()
				lightcounter = 0
			else
				lightcounter = lightcounter + 1
			end
			table.insert( pool, grid[i][j] )
			table.insert( normalcells, grid[i][j] )	
    end
end

-- create entry room
	 orient = math.random( 1,2 )
	 spot = math.random( 1, len )
	if orient == 1 then
		px = spot * propwidth
		py = 0
	else
		px = 0
		py = spot * propwidth
	end
	
	entryroom = {
		ctrpos = startLoc:GetPos() - Vector(px , py, 1 ),
		partOfMaze = false,
		attribute = ROOM_NORMAL,
		walls = {
			
			}
	}
	
	if orient == 1 then
		entryroom.rowx = spot
		entryroom.rowy = 0
	else
		entryroom.rowx = 0
		entryroom.rowy = spot
	end
	entryroom.orientation = orient
	

					entryroom.walls.wall1 = ents.Create( "prop_physics" )
					entryroom.walls.wall1:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
					entryroom.walls.wall1:SetPos( entryroom.ctrpos + Vector(proprad , 0 , proprad  ) )
					entryroom.walls.wall1:SetAngles(Angle(90,0,0))
					entryroom.walls.wall1:SetMaterial(material)
					entryroom.walls.wall1:Spawn()
					entryroom.walls.wall1:GetPhysicsObject():EnableMotion( false )
					entryroom.walls.wall1.parent = entryroom
					entryroom.walls.wall1.location = LOCATION_LEFT
					entryroom.walls.wall1.exists = true
					entryroom.walls.wall1.edge = true
					
					entryroom.walls.wall2 = ents.Create( "prop_physics" )
					entryroom.walls.wall2:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
					entryroom.walls.wall2:SetPos( entryroom.ctrpos + Vector(-proprad , 0 , proprad  ) )
					entryroom.walls.wall2:SetAngles(Angle(90,0,0))
					entryroom.walls.wall2:SetMaterial(material)
					entryroom.walls.wall2:Spawn()
					entryroom.walls.wall2:GetPhysicsObject():EnableMotion( false )
					entryroom.walls.wall2.parent = entryroom
					entryroom.walls.wall2.location = LOCATION_RIGHT
					entryroom.walls.wall2.exists = true
					entryroom.walls.wall2.edge = true
					
					entryroom.walls.wall3 = ents.Create( "prop_physics" )
					entryroom.walls.wall3:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
					entryroom.walls.wall3:SetPos( entryroom.ctrpos + Vector(0 , proprad , proprad  ) )
					entryroom.walls.wall3:SetAngles(Angle(90,90,0))
					entryroom.walls.wall3:SetMaterial(material)
					entryroom.walls.wall3:Spawn()
					entryroom.walls.wall3:GetPhysicsObject():EnableMotion( false )
					entryroom.walls.wall3.parent = entryroom
					entryroom.walls.wall3.location = LOCATION_BOTTOM
					entryroom.walls.wall3.exists = true
					entryroom.walls.wall3.edge = true
					
					entryroom.walls.wall4 = ents.Create( "prop_physics" )
					entryroom.walls.wall4:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
					entryroom.walls.wall4:SetPos( entryroom.ctrpos + Vector(0 , -proprad , proprad  ) )
					entryroom.walls.wall4:SetAngles(Angle(90,90,0))
					entryroom.walls.wall4:SetMaterial(material)
					entryroom.walls.wall4:Spawn()
					entryroom.walls.wall4:GetPhysicsObject():EnableMotion( false )
					entryroom.walls.wall4.parent = entryroom
					entryroom.walls.wall4.location = LOCATION_TOP
					entryroom.walls.wall4.exists = true
					entryroom.walls.wall4.edge = true
	
			if orient == 1 then
				local wallsamp = grid[spot][1].walls.wall3
				wallsamp.exists = false
				wallsamp:Remove()
				
			else
				local wallsamp = grid[1][spot].walls.wall1
				wallsamp.exists = false
				wallsamp:Remove()
				
			end
			
			local ent = ents.Create( "trap_light" )
				ent:SetPos( entryroom.ctrpos + Vector( 0, 0, 158 ) )
				ent:Spawn()
				ent:Activate()
				ent:ChangeColor( Color( 50, 255, 50 ) )
				ent.flashlight:SetKeyValue( "appearance", 10 )
	
	table.insert( pool, entryroom )
	table.insert( normalcells, entryroom )		
	
	entryroom.attribute = ROOM_PLAYER
	SetPlayerRoom( entryroom )

	local ent = ents.Create( "human_marker" )
					ent:SetPos( entryroom.ctrpos )
					ent:SetMaterial(material)
					ent:Spawn()
					ent:Activate()
					ent:GetPhysicsObject():EnableMotion( false )
					
	local ent = ents.Create( "needle_package" )
				ent:SetPos( entryroom.ctrpos + Vector( 0, 0, 45) )
				ent:Spawn()
				ent:Activate()

	table.RemoveByValue(normalcells, entryroom)



-- pick a random cell, mark it as part of the maze, add its walls to the list
if len > 1 then
while #mazecells < len * len do
sample = pool[1]
table.RemoveByValue(pool, sample)
table.insert(mazecells, sample)
table.Add( walls, sample.walls )
	while(#walls > 0) do
		wallsamp = table.Random(walls)
		sampx = wallsamp.parent.rowx
		sampy = wallsamp.parent.rowy
if wallsamp.shared != true then
	table.RemoveByValue(walls, wallsamp)
	wallsamp:SetMaterial( material )
	wallsamp.edge = true
else
	if math.random(1,90) == 1 then
		wallsamp:SetMaterial( "models/shiny" )
		wallsamp:SetColor( Color( 0,0,200, 180 ) )
		wallsamp:SetRenderMode( RENDERMODE_TRANSALPHA )
	end
	wallsamp.edge = false
		nextCell = wallsamp.parent
		if table.RemoveByValue( pool, nextCell ) then
		
			table.insert(mazecells, nextCell)
			if math.random(1,8) == 1 then
				CreateDoorway( wallsamp )
			end
			wallsamp.exists = false
			wallsamp:Remove()
			table.Add( walls, nextCell.walls )
			table.RemoveByValue(walls, wallsamp)
		
		else
			nextCell = wallsamp.parent2
			if table.RemoveByValue( pool, nextCell ) then
				table.insert(mazecells, nextCell)
				if math.random(1,8) == 1 then
					CreateDoorway( wallsamp )
				end
				wallsamp.exists = false
				wallsamp:Remove()
				table.Add( walls, nextCell.walls )
				table.RemoveByValue(walls, wallsamp)
			else
				table.RemoveByValue(walls, wallsamp)
			end
		end
	end
end
end
end

---- Add partial braiding effect

	local braidprob = GetConVar( "lab_braid_chance" ):GetFloat() * 100

	for k,v in pairs( normalcells ) do
		local numwalls = 0
		local validwalls = {}
		for l,k in pairs ( v.walls ) do
			if k.exists then
				numwalls = numwalls + 1
				if not k.edge then
					table.insert( validwalls, k )
				end
			end
		end
		
		if numwalls == 3 then
			if braidprob >= math.random( 1, 100 )  then
				local deadwall = table.Random( validwalls )
				if IsValid( deadwall ) and deadwall.exists then
						CreateDoorway( deadwall )
					deadwall.exists = false
					deadwall:Remove()
				end
			end
		end
		
	end



---

-- Select rooms 
minoroom = grid[len][len]
minoroom.attribute = ROOM_MINOTAUR
SetMinoRoom( minoroom )

local ent = ents.Create( "weapon_package" )
				ent:SetPos( minoroom.ctrpos + Vector( 0, 0, 45) )
				ent:Spawn()
				ent:Activate()
				
table.RemoveByValue(normalcells, minoroom)

	local timemod = #(player.GetAll())
	if timemod == nil then timemod = 1 end
				timer.Create( "teleporter", math.floor( GetConVar( "lab_base_exit_time" ):GetInt() ), 1, function()
					CreateExit()
				end)
				
	
	orientation =  math.random(1,2)
	spot = math.random( 2, len - 1 )
	
	if orientation == 1 then
		px = spot * propwidth
		py = 0
	else
		px = 0
		py = spot * propwidth
	end
	
	exitroom = {
		ctrpos = startLoc:GetPos() + Vector( px, py, -1 )  - Vector( propwidth * (len + 1), propwidth * (len + 1), 0),
		partOfMaze = true,
		attribute = ROOM_NORMAL,
		walls = {
			
			}
		}
	if orientation == 1 then
		exitroom.rowx = spot
		exitroom.rowy = len + 1
	else
		exitroom.rowx = len + 1
		exitroom.rowy = spot
	end
	exitroom.spot = spot
	exitroom.orientation = orientation
	
	SetExitRoom( exitroom )

-- tar or pepper spray rooms

	ranroom = grid[ math.floor( len / 2)][ math.floor( len / 2 ) ]
	if ranroom != nil then
		local randomnumber = math.random( 1,2 )
		if randomnumber == 1 then
			local ent = ents.Create( "package_tar" )
					ent:SetPos(ranroom.ctrpos + Vector(0,0,48)) 
					ent:Spawn()
					ent:Activate()
		else
			local ent = ents.Create( "package_spray" )
					ent:SetPos(ranroom.ctrpos + Vector(0,0,48)) 
					ent:Spawn()
					ent:Activate()
		end
		ranroom.attribute = ROOM_SPECIAL
		table.RemoveByValue(normalcells, ranroom)
		
	end
	
-- speed boost rooms

ranroom = table.Random(normalcells)
	if ranroom != nil then
	
		local ent = ents.Create( "bonus_package" )
		ent:SetPos(ranroom.ctrpos + Vector(0,0,48)) 
		ent:Spawn()
		ent:Activate()
		ranroom.attribute = ROOM_SPECIAL
		table.RemoveByValue(normalcells, ranroom)
		
	end

-- Decide random rooms
if not GAMEMODE.minigameactive then
randomroom = math.Round( len * len * randomroomperroom )
if randomroom > (len * len - 3) then randomroom = (len * len - 3) end
if randomroom > 90 then randomroom = 90 end
i = 1
while i <= randomroom && #normalcells > 0 do
	ranroom = table.Random(normalcells)
	if(ranroom != nil) then
		effect = table.Random(RANDOMROOMS)
		while(effect != nil && checkEffectAllowed( effect.var ) != true && #RANDOMROOMS > 0) do
			effect = table.Random(RANDOMROOMS)
		end
		if(effect != nil && checkEffectAllowed( effect.var )) then
			if not GAMEMODE.zombies then
				effect.activate( ranroom.ctrpos )
			else
				local zombie = ents.Create( "npc_zombie" )
					zombie:SetPos( ranroom.ctrpos + Vector( 0, 0, 20 ) )
					zombie:Spawn()
			end
			if(effect.var != "lab_room_fakewall") then
				table.RemoveByValue(normalcells, ranroom)
				ranroom.attribute = ROOM_SPECIAL
			end
		end
	end
	i = i + 1
end
end

TeleportToMaze()
raiseMazeProps()

if ( not GAMEMODE.minigameactive ) and CheckForAbort() != true && GetRoundState() == ROUND_SETUP then
   timer.Create( "mazestart", 5, 1, function()
		RoundPlay()
	end)
   end

end)
end)
end

function raiseMazeProps()

	local playerroom = GetPlayerRoom()
	
	if playerroom.orientation == 1 then
		local targetwall = playerroom.walls.wall4
		
		for i = 20, 170 do
			timer.Simple( i/ 30, function()
				targetwall:SetPos( targetwall:GetPos() + Vector(0,0, proprad / 100 ) )
			end)
		end
				
	else
		local targetwall = playerroom.walls.wall2
		
		for i = 10, 170 do
			timer.Simple( i/ 30, function()
				targetwall:SetPos( targetwall:GetPos() + Vector(0,0, proprad / 100 ) )
			end)
		end
	end

end

function CreateExit()

	if not GAMEMODE.minigameactive then
	local exitroom = GetExitRoom()
	
			local ent = ents.Create( "trap_light" )
				ent:SetPos( exitroom.ctrpos + Vector( 0, 0, 158 ) )
				ent:Spawn()
				ent:Activate()
				ent:ChangeColor( Color( 50, 50, 255 ) )
				ent.flashlight:SetKeyValue( "appearance", 10 )
				
					exitroom.walls.wall1 = ents.Create( "prop_physics" )
					exitroom.walls.wall1:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
					exitroom.walls.wall1:SetPos( exitroom.ctrpos + Vector(proprad , 0 , proprad  ) )
					exitroom.walls.wall1:SetAngles(Angle(90,0,0))
					exitroom.walls.wall1:SetMaterial(material)
					exitroom.walls.wall1:Spawn()
					exitroom.walls.wall1:GetPhysicsObject():EnableMotion( false )
					exitroom.walls.wall1.parent = exitroom
					exitroom.walls.wall1.location = LOCATION_LEFT
					exitroom.walls.wall1.exists = true
					exitroom.walls.wall1.edge = true
					
					exitroom.walls.wall2 = ents.Create( "prop_physics" )
					exitroom.walls.wall2:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
					exitroom.walls.wall2:SetPos( exitroom.ctrpos + Vector(-proprad , 0 , proprad  ) )
					exitroom.walls.wall2:SetAngles(Angle(90,0,0))
					exitroom.walls.wall2:SetMaterial(material)
					exitroom.walls.wall2:Spawn()
					exitroom.walls.wall2:GetPhysicsObject():EnableMotion( false )
					exitroom.walls.wall2.parent = exitroom
					exitroom.walls.wall2.location = LOCATION_RIGHT
					exitroom.walls.wall2.exists = true
					exitroom.walls.wall2.edge = true
					
					exitroom.walls.wall3 = ents.Create( "prop_physics" )
					exitroom.walls.wall3:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
					exitroom.walls.wall3:SetPos( exitroom.ctrpos + Vector(0 , proprad , proprad  ) )
					exitroom.walls.wall3:SetAngles(Angle(90,90,0))
					exitroom.walls.wall3:SetMaterial(material)
					exitroom.walls.wall3:Spawn()
					exitroom.walls.wall3:GetPhysicsObject():EnableMotion( false )
					exitroom.walls.wall3.parent = exitroom
					exitroom.walls.wall3.location = LOCATION_BOTTOM
					exitroom.walls.wall3.exists = true
					exitroom.walls.wall3.edge = true
					
					exitroom.walls.wall4 = ents.Create( "prop_physics" )
					exitroom.walls.wall4:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
					exitroom.walls.wall4:SetPos( exitroom.ctrpos + Vector(0 , -proprad , proprad  ) )
					exitroom.walls.wall4:SetAngles(Angle(90,90,0))
					exitroom.walls.wall4:SetMaterial(material)
					exitroom.walls.wall4:Spawn()
					exitroom.walls.wall4:GetPhysicsObject():EnableMotion( false )
					exitroom.walls.wall4.parent = exitroom
					exitroom.walls.wall4.location = LOCATION_TOP
					exitroom.walls.wall4.exists = true
					exitroom.walls.wall4.edge = true
					
			if exitroom.orientation == 1 then
				local wallsamp = grid[len + 1 - GetExitRoom().spot][len].walls.wall4
				if IsValid( wallsamp ) then
					wallsamp.exists = false
					wallsamp:Remove()
				end
				
				local targetwall = exitroom.walls.wall3
				targetwall:EmitSound( "ambient/materials/metal_big_impact_scrape1.wav" )
				for i = 1, 40 do
					timer.Simple( i/ 10, function()
						targetwall:SetPos( targetwall:GetPos() + Vector(0,0, proprad / 30 ) )
					end)
				end
			else
				local wallsamp = grid[len][len + 1 - GetExitRoom().spot].walls.wall2
				if IsValid( wallsamp ) then
					wallsamp.exists = false
					wallsamp:Remove()
				end
				
				local targetwall = exitroom.walls.wall1
				targetwall:EmitSound( "ambient/materials/metal_big_impact_scrape1.wav" )
				for i = 1, 40 do
					timer.Simple( i/ 10, function()
						targetwall:SetPos( targetwall:GetPos() + Vector(0,0, proprad / 30 ) )
					end)
				end
			end
			
				local ent = ents.Create( "exit_beacon" )
					ent:SetPos( exitroom.ctrpos + Vector(0,0, 45) )
					ent:Spawn()
					ent:Activate()
					if exitroom.orientation == 2 then
						ent:SetAngles( Angle( 0, 90, 90 ) )
					end
					ent:GetPhysicsObject():EnableMotion( false )
					ent:Shock()
				printAnnounce( "The teleporter sphere has appeared!  Find it to escape!", ROLE_PLAYER )
				printAnnounce( "The teleporter sphere has appeared!  Prevent the humans from escaping!", ROLE_MINOTAUR )

	end
end

function CreateDoorway( previouswall )

	if math.random(1,12) == 1 then
		local ent = nil
		if math.random(1,2) == 1 then
			ent = ents.Create( "trap_gate" )
		else
			ent = ents.Create( "trap_gate_rotating" )
		end
		
		ent.size = propsize
			ent:SetPos( previouswall:GetPos() )
			ent:SetAngles( Angle( 0, previouswall:GetAngles().y + 90, 90 ) )
			ent:Spawn()
			
	elseif propsize == 3 then
	
		local top = ents.Create( "prop_physics" )
		top:SetModel( "models/hunter/plates/plate1x3.mdl" )
		top:SetPos( previouswall:GetPos() + Vector( 0, 0, 48 ) )
		top:SetAngles( previouswall:GetAngles() )
		top:SetMaterial(material)
		top:Spawn()
		top:GetPhysicsObject():EnableMotion( false )
		
		if math.random(1,2) == 1 then
		local right = ents.Create( "prop_physics" )
		right:SetModel( "models/hunter/plates/plate1x2.mdl" )
		right:SetPos( previouswall:GetPos() + previouswall:GetAngles():Right() * 47 + Vector(0,0, -23)  )
		right:SetAngles( Angle( 0 , previouswall:GetAngles().y + 90, 90 )  )
		right:SetMaterial(material)
		right:Spawn()
		right:GetPhysicsObject():EnableMotion( false )
		else
		local left = ents.Create( "prop_physics" )
		left:SetModel( "models/hunter/plates/plate1x2.mdl" )
		left:SetPos( previouswall:GetPos() + previouswall:GetAngles():Right() * -47 + Vector(0,0, -23) )
		left:SetAngles( Angle( 0, previouswall:GetAngles().y + 90, 90 ))
		left:SetMaterial(material)
		left:Spawn()
		left:GetPhysicsObject():EnableMotion( false )
		end
		
	elseif propsize == 4 then
	
		local top = ents.Create( "prop_physics" )
		top:SetModel( "models/hunter/plates/plate1x2.mdl" )
		top:SetPos( previouswall:GetPos() + Vector( 0, 0, 38 ) )
		top:SetAngles( previouswall:GetAngles() )
		top:SetMaterial(material)
		top:Spawn()
		top:GetPhysicsObject():EnableMotion( false )
		
		local right = ents.Create( "prop_physics" )
		right:SetModel( "models/hunter/plates/plate1x4.mdl" )
		right:SetPos( previouswall:GetPos() + previouswall:GetAngles():Right() * 70.5 )
		right:SetAngles( Angle( 0 , previouswall:GetAngles().y + 90, 90 )  )
		right:SetMaterial(material)
		right:Spawn()
		right:GetPhysicsObject():EnableMotion( false )
		
		local left = ents.Create( "prop_physics" )
		left:SetModel( "models/hunter/plates/plate1x4.mdl" )
		left:SetPos( previouswall:GetPos() + previouswall:GetAngles():Right() * -70.5 )
		left:SetAngles( Angle( 0, previouswall:GetAngles().y + 90, 90 ))
		left:SetMaterial(material)
		left:Spawn()
		left:GetPhysicsObject():EnableMotion( false )
	
	else
	
	end


end

--function SolveLabyrinth()

	--local startroom = GAMEMODE.playerroom
	--local exitroom = GAMEMODE.exitroom
	--local minoroom = GAMEMODE.minoroom
	--local path = { startroom }
	--local badpath = {}
	--local badbadpath = {}
--	local icount = 0
	--local maxcount = len*len*len
--	while (not table.HasValue( path, exitroom ) or not table.HasValue( path, minoroom )) and  icount < maxcount and #path > 0 do
	--	local curcell = path[ #path ]
		
	--	local w1e = !curcell.walls.wall1.exists
	--	local w2e = !curcell.walls.wall2.exists
	--	local w3e = !curcell.walls.wall3.exists
	--	local w4e = !curcell.walls.wall4.exists
		
	--	local foundnextcell = false
	--	local existcount = 0
		
		--while (not foundnextcell) and (w1e or w2e or w3e or w4e) do
		
		--	if w1e then
		--		existcount = existcount + 1
			--	local nextcell = grid[curcell.rowx - 1][curcell.rowy]
			--	if (not table.HasValue( path, nextcell )) and (not table.HasValue( badpath, nextcell )) then
			--		table.insert( path, nextcell )
			--		foundnextcell = true
			--	end
			--	w1e = false
		--	elseif w2e then
			--	existcount = existcount + 1
			--	local nextcell = grid[curcell.rowx + 1][curcell.rowy]
			--	if (not table.HasValue( path, nextcell )) and (not table.HasValue( badpath, nextcell )) then
			--		table.insert( path, nextcell )
			--		foundnextcell = true
			--	end
			
			--	w2e = false
			--elseif w3e then
			--	existcount = existcount + 1
			--	local nextcell = grid[curcell.rowx][curcell.rowy - 1]
			--	if (not table.HasValue( path, nextcell )) and (not table.HasValue( badpath, nextcell )) then
			--		table.insert( path, nextcell )
			--		foundnextcell = true
			--	end
			
		--		w3e = false
		--	elseif w4e then
			--	existcount = existcount + 1
		--		local nextcell = grid[curcell.rowx][curcell.rowy + 1]
			--	if (not table.HasValue( path, nextcell )) and (not table.HasValue( badpath, nextcell )) then
			--		table.insert( path, nextcell )
			--		foundnextcell = true
			--	end
			
			--	w4e = false
		--	end
			
	--	end
		
		
	--	if not foundnextcell then
		--	table.insert( badpath, curcell )
		--	table.remove( path, #path )
			
		--	if existcount == 1 then
		--		table.insert( badbadpath, curcell )
		--	end
		
	--	end
	
	--	icount = icount + 1
	--end
	--if table.HasValue( path, exitroom ) and table.HasValue( path, minoroom ) then
	
--	for k,v in pairs( path ) do
	
	--	local melon = ents.Create( "prop_physics" )
	--		melon:SetModel( "models/props_junk/watermelon01.mdl" )
	--		melon:SetPos( v.ctrpos + Vector( 0, 0, 5 ))
	--		melon:Spawn()
	
	--end
	-- remove some cells
--	local removeamount = (len*len - #path )*GetConVar( "lab_maze_removeratio" ):GetFloat()
	--local numremoved = 0
	--while #badbadpath > 0 and numremoved < removeamount do
	--	local cellsamp = nil
	--	cellsamp = table.Random( badbadpath )
		
	--	if cellsamp.attribute == ROOM_NORMAL then
		--	numremoved = numremoved + 1
			
		--	local w1e = !cellsamp.walls.wall1.exists
		--	local w2e = !cellsamp.walls.wall2.exists
		--	local w3e = !cellsamp.walls.wall3.exists
		--	local w4e = !cellsamp.walls.wall4.exists
			
			--if w1e then
			--	cellsamp.walls.wall1 = ents.Create( "prop_physics" )
			--	cellsamp.walls.wall1:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
			--	cellsamp.walls.wall1:SetPos( cellsamp.ctrpos + Vector(proprad , 0 , proprad  ) )
			--	cellsamp.walls.wall1:SetAngles(Angle(90,0,0))
			--	cellsamp.walls.wall1:SetMaterial(material)
			--	cellsamp.walls.wall1:Spawn()
			--	cellsamp.walls.wall1:GetPhysicsObject():EnableMotion( false )
			--	cellsamp.walls.wall1.parent = cellsamp
			--	cellsamp.walls.wall1.location = LOCATION_LEFT
			--	cellsamp.walls.wall1.exists = true
			--end
			
		--	if w2e then
		--		cellsamp.walls.wall2 = ents.Create( "prop_physics" )
		--		cellsamp.walls.wall2:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
		--		cellsamp.walls.wall2:SetPos( cellsamp.ctrpos + Vector(-proprad , 0 , proprad  ) )
		--		cellsamp.walls.wall2:SetAngles(Angle(90,0,0))
		--		cellsamp.walls.wall2:SetMaterial(material)
			--	cellsamp.walls.wall2:Spawn()
			--	cellsamp.walls.wall2:GetPhysicsObject():EnableMotion( false )
			--	cellsamp.walls.wall2.parent = cellsamp
			--	cellsamp.walls.wall2.location = LOCATION_RIGHT
			--	cellsamp.walls.wall2.exists = true
			--end
			
		--	if w3e then
		--		cellsamp.walls.wall3 = ents.Create( "prop_physics" )
			--	cellsamp.walls.wall3:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
		--		cellsamp.walls.wall3:SetPos( cellsamp.ctrpos + Vector(0 , -proprad , proprad  ) )
			--	cellsamp.walls.wall3:SetAngles(Angle(90,90,0))
			--	cellsamp.walls.wall3:SetMaterial(material)
			--	cellsamp.walls.wall3:Spawn()
			--	cellsamp.walls.wall3:GetPhysicsObject():EnableMotion( false )
			--	cellsamp.walls.wall3.parent = cellsamp
			--	cellsamp.walls.wall3.location = LOCATION_BOTTOM
			--	cellsamp.walls.wall3.exists = true
			--end
			
			--if w4e then
			--	cellsamp.walls.wall4 = ents.Create( "prop_physics" )
			--	cellsamp.walls.wall4:SetModel( "models/hunter/plates/plate"..propsize.."x"..propsize..".mdl" )
			--	cellsamp.walls.wall4:SetPos( cellsamp.ctrpos + Vector(0 , -proprad , proprad  ) )
			--	cellsamp.walls.wall4:SetAngles(Angle(90,90,0))
			--	cellsamp.walls.wall4:SetMaterial(material)
			--	cellsamp.walls.wall4:Spawn()
			--	cellsamp.walls.wall4:GetPhysicsObject():EnableMotion( false )
			--	cellsamp.walls.wall4.parent = cellsamp
			--	cellsamp.walls.wall4.location = LOCATION_TOP
			--	cellsamp.walls.wall4.exists = true
		--	end
			
	--	end
		
	--	for k,v in pairs( cellsamp.walls ) do
	--		v.edge = true
		--end
		
	--	cellsamp.attribute = ROOM_SPECIAL
	--	table.RemoveByValue( badpath, cellsamp )
	--	table.RemoveByValue( badbadpath, cellsamp )
--		table.RemoveByValue( normalcells, cellsamp )
--	end
--	end

--end
