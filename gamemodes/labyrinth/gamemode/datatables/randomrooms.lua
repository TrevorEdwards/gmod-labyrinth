
 
 RANDOMROOMS = {

	{
	var = "lab_room_annoyer",
	activate = function( roompos )
	local ent = ents.Create( "npc_annoyer" )
				ent:SetPos( roompos + Vector( 0, 0, 30 ) ) 
				ent:SetColor( Color(200,0,20) )
				ent:Spawn()
				ent:Activate()
	end
	},
	
	{
	var = "lab_room_light",
	activate = function( roompos )
	local ent = ents.Create( "trap_light" )
				ent:SetPos( roompos + Vector( 0, 0, 158 ) )
				ent:Spawn()
				ent:Activate()
	end
	},
	
	{
	var = "lab_room_explosiontrap",
	activate = function( roompos )
				
		local traceworld = {}
		traceworld.start = roompos + Vector(0,0,10) 
		traceworld.endpos = traceworld.start + (Vector(0,0,-1) * 8000) 
		local trw = util.TraceLine(traceworld)
		local worldpos1 = trw.HitPos + trw.HitNormal * 5
		local worldpos2 = trw.HitPos - trw.HitNormal * 5
		util.Decal("Scorch",worldpos1,worldpos2)
		
		local ent = ents.Create( "trap_explosion" )
				ent:SetPos( roompos + Vector(0,0,3) ) 
				ent:Spawn()
				ent:Activate()
				ent:GetPhysicsObject():EnableMotion( false )
	end
	},
	
	{
	var = "lab_room_firetrap",
	activate = function( roompos )
	local traceworld = {}
		traceworld.start = roompos + Vector(0,0,10) 
		traceworld.endpos = traceworld.start + (Vector(0,0,-1) * 8000) 
		local trw = util.TraceLine(traceworld)
		local worldpos1 = trw.HitPos + trw.HitNormal * 5
		local worldpos2 = trw.HitPos - trw.HitNormal * 5
		util.Decal("Scorch",worldpos1,worldpos2)
	local ent = ents.Create( "trap_explosion" )
				ent:SetPos( roompos + Vector(0,0,3) ) 
				ent:Spawn()
				ent:Activate()
				ent:GetPhysicsObject():EnableMotion( false )
				ent.traptype = 1
	end
	},
	
	{
	var = "lab_room_grenadetrap",
	activate = function( roompos )
	local traceworld = {}
		traceworld.start = roompos + Vector(0,0,10) 
		traceworld.endpos = traceworld.start + (Vector(0,0,-1) * 8000) 
		local trw = util.TraceLine(traceworld)
		local worldpos1 = trw.HitPos + trw.HitNormal * 5
		local worldpos2 = trw.HitPos - trw.HitNormal * 5
		util.Decal("Scorch",worldpos1,worldpos2)
	local ent = ents.Create( "trap_explosion" )
				ent:SetPos( roompos + Vector(0,0,3) ) 
				ent:Spawn()
				ent:Activate()
				ent:GetPhysicsObject():EnableMotion( false )
				ent.traptype = 2
	end
	},
	
	{
	var = "lab_room_rollerminetrap",
	activate = function( roompos )
	local traceworld = {}
		traceworld.start = roompos + Vector(0,0,10) 
		traceworld.endpos = traceworld.start + (Vector(0,0,-1) * 8000) 
		local trw = util.TraceLine(traceworld)
		local worldpos1 = trw.HitPos + trw.HitNormal * 5
		local worldpos2 = trw.HitPos - trw.HitNormal * 5
		util.Decal("Scorch",worldpos1,worldpos2)
	local ent = ents.Create( "trap_explosion" )
				ent:SetPos( roompos + Vector(0,0,3) ) 
				ent:Spawn()
				ent:Activate()
				ent:GetPhysicsObject():EnableMotion( false )
				ent.traptype = 3
	end
	},
	
	{
	var = "lab_room_manhacktrap",
	activate = function( roompos )
	local traceworld = {}
		traceworld.start = roompos + Vector(0,0,10) 
		traceworld.endpos = traceworld.start + (Vector(0,0,-1) * 8000) 
		local trw = util.TraceLine(traceworld)
		local worldpos1 = trw.HitPos + trw.HitNormal * 5
		local worldpos2 = trw.HitPos - trw.HitNormal * 5
		util.Decal("Scorch",worldpos1,worldpos2)
	local ent = ents.Create( "trap_explosion" )
				ent:SetPos( roompos + Vector(0,0,3) ) 
				ent:Spawn()
				ent:Activate()
				ent:GetPhysicsObject():EnableMotion( false )
				ent.traptype = 4
	end
	},
	
	{
	var = "lab_room_tartrap",
	activate = function( roompos )
	local traceworld = {}
		traceworld.start = roompos + Vector(0,0,10) 
		traceworld.endpos = traceworld.start + (Vector(0,0,-1) * 8000) 
		local trw = util.TraceLine(traceworld)
		local worldpos1 = trw.HitPos + trw.HitNormal * 5
		local worldpos2 = trw.HitPos - trw.HitNormal * 5
		util.Decal("Scorch",worldpos1,worldpos2)
	local ent = ents.Create( "trap_explosion" )
				ent:SetPos( roompos + Vector(0,0,3) )  
				ent:Spawn()
				ent:Activate()
				ent:GetPhysicsObject():EnableMotion( false )
				ent.traptype = 5
	end
	},
	
	{
	var = "lab_room_blindtrap",
	activate = function( roompos )
	local traceworld = {}
		traceworld.start = roompos + Vector(0,0,10) 
		traceworld.endpos = traceworld.start + (Vector(0,0,-1) * 8000) 
		local trw = util.TraceLine(traceworld)
		local worldpos1 = trw.HitPos + trw.HitNormal * 5
		local worldpos2 = trw.HitPos - trw.HitNormal * 5
		util.Decal("Scorch",worldpos1,worldpos2)
	local ent = ents.Create( "trap_explosion" )
				ent:SetPos( roompos + Vector(0,0,3) ) 
				ent:Spawn()
				ent:Activate()
				ent:GetPhysicsObject():EnableMotion( false )
				ent.traptype = 6
	end
	},

	
	{
	var = "lab_room_drachma",
	activate = function( roompos )
	local ent = ents.Create( "package_drachma" )
				ent:SetPos(roompos + Vector(0,0,48)) 
				ent:Spawn()
				ent:Activate()
	end
	},
	
	{
	var = "lab_room_turret",
	activate = function( roompos )
	local ent = ents.Create( "npc_turret_floor" )
				ent:SetPos(roompos + Vector(0,0,3)) 
				if ranroom.walls.wall1.exists == false then
				ent:SetAngles(Angle(0,0,0))
				elseif ranroom.walls.wall2.exists == false then
				ent:SetAngles(Angle(0,180,0))
				elseif ranroom.walls.wall2.exists == false then
				ent:SetAngles(Angle(0,270,0))
				else
				ent:SetAngles(Angle(0,90,0))
				end
				ent:Spawn()
				ent:Activate()
	end
	},
	
	{
	var = "lab_room_pigeon",
	activate = function( roompos )
	local ent = ents.Create( "npc_pigeon" )
				ent:SetPos(roompos + Vector(0,0,20)) 
				ent:Spawn()
				ent:Activate()
	end
	},
	
	{
	var = "lab_room_manhack",
	activate = function( roompos )
	for i = 1, 3 do
		local ent = ents.Create( "npc_manhack" )
				ent:SetPos(roompos + Vector(0,0,10 + 5 * i)) 
				ent:Spawn()
				ent:Activate()
		end
	end
	},
	
	{
	var = "lab_room_cscanner",
	activate = function( roompos )
	local ent = ents.Create( "npc_cscanner" )
				ent:SetPos(roompos + Vector(0,0,10)) 
				ent:Spawn()
				ent:Activate()
	end
	},
	
	{
	var = "lab_room_melonmancer",
	activate = function( roompos )
	local ent = ents.Create( "trap_melonmancer" )
				ent:SetPos(roompos + Vector(0,0,10)) 
				ent:Spawn()
				ent:Activate()
	end
	},
	
	{
	var = "lab_room_health",
	activate = function( roompos )
	local ent = ents.Create( "item_healthkit" )
				ent:SetPos(roompos + Vector(0,0,20)) 
				ent:Spawn()
				ent:Activate()
	end
	},
	
	{
	var = "lab_room_crates",
	activate = function( roompos )
	cornerpos = roompos - Vector(proprad - 27,proprad - 27,0)
	for i = 1, theSize do
			for j = 1, theSize do
				if math.random(1,3) == 1 then
					local ent = ents.Create( "prop_physics" )
					ent:SetPos(cornerpos + Vector((i-1) * 48,(j-1) * 48,30)) 
					ent:SetAngles(Angle(0,0,90))
					ent:SetModel( "models/props_junk/wood_crate002a.mdl" )
					ent:Spawn()
					ent:Activate()
				end
			end
	end
	end
	},
	
	{
	var = "lab_room_melon",
	activate = function( roompos )
	local ent = ents.Create( "prop_physics" )
				ent:SetPos(roompos + Vector(0,0,20)) 
				ent:SetModel( "models/props_junk/watermelon01.mdl" )
				ent:Spawn()
				ent:Activate()
	end
	},
	
	{
	var = "lab_room_fakewall",
	activate = function( roompos )
	local ent = ents.Create( "prop_physics" )
		
		local colorconst = .6
		if ranroom.walls.wall1.exists == false then
			ent:SetModel( "models/hunter/plates/plate"..theSize.."x"..theSize..".mdl" )
			ent:SetPos( roompos + Vector(proprad , 0 , proprad  ) )
			ent:SetAngles(Angle(90,0,0))
			ent:SetMaterial("models/props_c17/frostedglass_01a")
			ent:Spawn()
			ent:GetPhysicsObject():EnableMotion( false )
			ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
		elseif ranroom.walls.wall2.exists == false then
			ent:SetModel( "models/hunter/plates/plate"..theSize.."x"..theSize..".mdl" )
			ent:SetPos( roompos + Vector(-proprad , 0 , proprad  ) )
			ent:SetAngles(Angle(90,0,0))
			ent:SetMaterial("models/props_c17/frostedglass_01a")
			ent:Spawn()
			ent:GetPhysicsObject():EnableMotion( false )
			ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
		elseif ranroom.walls.wall3.exists == false then
			ent:SetModel( "models/hunter/plates/plate"..theSize.."x"..theSize..".mdl" )
			ent:SetPos( roompos + Vector(0 , proprad , proprad  ) )
			ent:SetAngles(Angle(90,90,0))
			ent:SetMaterial("models/props_c17/frostedglass_01a")
			ent:Spawn()
			ent:GetPhysicsObject():EnableMotion( false )
			ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
		elseif ranroom.walls.wall4.exists == false then
			ent:SetModel( "models/hunter/plates/plate"..theSize.."x"..theSize..".mdl" )
			ent:SetPos( roompos + Vector(0 , -proprad , proprad   ) )
			ent:SetAngles(Angle(90,90,0))
			ent:SetMaterial("models/props_c17/frostedglass_01a")
			ent:Spawn()
			ent:GetPhysicsObject():EnableMotion( false )
			ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
		else
		end
	end
	},
	
	{
	var = "lab_room_crusher",
	activate = function( roompos )
	local ent = ents.Create( "trap_crusher" )
				ent.size = theSize
				ent:SetPos(roompos + Vector( 0, 0, 3) ) 
				ent:Spawn()
				ent:Activate()
	end
	},
	
	{
	var = "lab_room_gate",
	activate = function( roompos )
	local ent = ents.Create( "trap_gate" )
		
		if ranroom.walls.wall1.exists == false then
			ent.size = theSize
			ent:SetPos( roompos + Vector(proprad , 0 , proprad  ) )
			ent:SetAngles(Angle(90,0,0))
			ent:Spawn()
			ent:SetAngles(Angle(90,0,0))
		elseif ranroom.walls.wall2.exists == false then
			ent.size = theSize
			ent:SetPos( roompos + Vector(-proprad , 0 , proprad  ) )
			ent:SetAngles(Angle(90,0,0))
			ent:Spawn()
			ent:SetAngles(Angle(90,0,0))
		elseif ranroom.walls.wall3.exists == false then
			ent.size = theSize
			ent:SetPos( roompos + Vector(0 , proprad , proprad  ) )
			ent:SetAngles(Angle(90,90,0))
			ent:Spawn()
			ent:SetAngles(Angle(90,90,0))
		elseif ranroom.walls.wall4.exists == false then
			ent.size = theSize
			ent:SetPos( roompos + Vector(0 , -proprad , proprad   ) )
			ent:SetAngles(Angle(90,90,0))
			ent:Spawn()
			ent:SetAngles(Angle(90,90,0))
		else
		end
		
		for k,v in pairs( ents.FindInSphere( roompos, theSize * 60 ) ) do
			if IsValid( v ) then
				local class = v:GetClass()
				if class == "human_marker" or class == "trap_crusher" or class == "trap_gate_rotating" or class == "trap_gate_sliding" then
					if IsValid( ent ) then
						ent:Remove()
					end
				end
			end
		end
		
	end
	},
	
	{
	var = "lab_room_gate_sliding",
	activate = function( roompos )
	local ent = ents.Create( "trap_gate_sliding" )
		
		if ranroom.walls.wall1.exists == false then
			ent.size = theSize
			ent.rottype = 1
			ent:SetPos( roompos + Vector(proprad , 0 , proprad  ) )
			ent:SetAngles(Angle(90,0,0))
			ent:Spawn()
			ent:Activate()
			ent:SetAngles(Angle(90,0,0))
		elseif ranroom.walls.wall2.exists == false then
			ent.size = theSize
			ent.rottype = 1
			ent:SetPos( roompos + Vector(-proprad , 0 , proprad  ) )
			ent:SetAngles(Angle(90,0,0))
			ent:Spawn()
			ent:Activate()
			ent:SetAngles(Angle(90,0,0))
		elseif ranroom.walls.wall3.exists == false then
			ent.size = theSize
			ent.rottype = 2
			ent:SetPos( roompos + Vector(0 , proprad , proprad  ) )
			ent:SetAngles(Angle(90,90,0))
			ent:Spawn()
			ent:Activate()
			ent:SetAngles(Angle(90,90,0))
		elseif ranroom.walls.wall4.exists == false then
			ent.size = theSize
			ent.rottype = 2
			ent:SetPos( roompos + Vector(0 , -proprad , proprad   ) )
			ent:SetAngles(Angle(90,90,0))
			ent:Spawn()
			ent:Activate()
			ent:SetAngles(Angle(90,90,0))
		else
		end
		
		for k,v in pairs( ents.FindInSphere( roompos, theSize * 110 ) ) do
			if IsValid( v ) then
				local class = v:GetClass()
				if class == "human_marker" or class == "trap_crusher" or class == "trap_gate" or class == "trap_gate_rotating" then
					if IsValid( ent ) then
						ent:Remove()
					end
				end
			end
		end
		
		
	end
	},
	
	{
	var = "lab_room_gate_rotating",
	activate = function( roompos )
	local ent = ents.Create( "trap_gate_rotating" )
		
		if ranroom.walls.wall1.exists == false then
			ent.size = theSize
			ent:SetPos( roompos + Vector(proprad , 0 , proprad  ) )
			ent:SetAngles(Angle(90,0,0))
			ent:Spawn()
			ent:Activate()
			ent:SetAngles(Angle(90,0,0))
		elseif ranroom.walls.wall2.exists == false then
			ent.size = theSize
			ent:SetPos( roompos + Vector(-proprad , 0 , proprad  ) )
			ent:SetAngles(Angle(90,0,0))
			ent:Spawn()
			ent:Activate()
			ent:SetAngles(Angle(90,0,0))
		elseif ranroom.walls.wall3.exists == false then
			ent.size = theSize
			ent:SetPos( roompos + Vector(0 , proprad , proprad  ) )
			ent:SetAngles(Angle(90,90,0))
			ent:Spawn()
			ent:Activate()
			ent:SetAngles(Angle(90,90,0))
		elseif ranroom.walls.wall4.exists == false then
			ent.size = theSize
			ent:SetPos( roompos + Vector(0 , -proprad , proprad   ) )
			ent:SetAngles(Angle(90,90,0))
			ent:Spawn()
			ent:Activate()
			ent:SetAngles(Angle(90,90,0))
		else
		end
		
		for k,v in pairs( ents.FindInSphere( roompos, theSize * 60 ) ) do
			if IsValid( v ) then
				local class = v:GetClass()
				if class == "human_marker" or class == "weapon_package" or class == "trap_crusher" or class == "trap_gate" or class == "trap_gate_sliding" then
					if IsValid( ent ) then
						ent:Remove()
					end
				end
			end
		end
		
	end
	},
	
	{
	var = "lab_room_rollermine",
	activate = function( roompos )
	for i = 1, 3 do
		local ent = ents.Create( "npc_rollermine" )
				ent:SetPos(roompos + Vector(0,0,10 + 5 * i)) 
				ent:Spawn()
				ent:Activate()
	end
	end
	},
	
	{
	var = "lab_room_divider",
	activate = function( roompos )
	local mymat = table.Random( MAZEMATERIALS )
	local ent = ents.Create( "prop_physics" )
	
		local pattern = nil
		local w1 = ranroom.walls.wall1.exists
		local w2 = ranroom.walls.wall2.exists
		local w3 = ranroom.walls.wall3.exists
		local w4 = ranroom.walls.wall4.exists
		
		local tab = nil
		if theSize % 2 == 0 then
			tab = EVENDIVIDERS
		else
			tab = ODDDIVIDERS
		end
		
		local pattern = nil
		if (w1 and w2) and not (w3 or w4 ) then
			 pattern = table.Random( tab.leftright )
		elseif (w3 and w4) and not (w1 or w2 ) then
			 pattern = table.Random( tab.topbottom )
		else
			 pattern = table.Random( tab.generic )
		end
		if pattern.flag != true or GAMEMODE.thirdperson == false  then
		for k,v in pairs( pattern.walls ) do
			local ent = ents.Create( "prop_physics" )
			local s1 = math.floor( v.size1 * theSize) + v.size1add
			local s2 = math.floor( v.size2 * theSize) + v.size2add
				ent:SetModel( "models/hunter/plates/plate"..s1.."x"..s2..".mdl" )		
			--ent:SetPos( roompos + Vector(proprad , 0 , proprad  ) )
			local posadd = Vector( 0, 0, 0 )
			if v.positionadd != nil then 
				posadd = v.positionadd
			else
				posadd = Vector(0, 0, 0 )
			end
			
			ent:SetPos( roompos + proprad * v.position + posadd)
			ent:SetAngles( v.angle )
			ent:SetMaterial( mymat )
			ent:Spawn()
			ent:GetPhysicsObject():EnableMotion( false )
			ent.edge = false
			if pattern.flag == true then
				ent.edge = true
			end
		end
		end
	end
	}
	
}
 
 EVENDIVIDERS = {
	 
	leftright = {
	{
		walls = {	
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(-.5 , 1 , 1  ),
			angle = Angle(0,0,90)
		},
	
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(.5 , -1 , 1  ),
			angle = Angle(0,0,90)
		}
		}
		}
		 
	 
	},
		
	topbottom = {
	
	{
		walls = {	
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(1 , .55 , 1  ),
			angle = Angle(0,90,90)
		},
	
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(-1 , -.55 , 1  ),
			angle = Angle(0,90,90)
		},
		
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector( 0, 0 , 1  ),
			angle = Angle(0,90,90)
		}
		}
		}
	 
	},
		
	generic = {
	{
		walls = {	
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position = Vector(0 , 0 , 1  ),
			angle = Angle(0,0,90)
		},
	
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position = Vector(0 , 0 , 1  ),
			angle = Angle(0,90,90)
		}
		}
	},
		
	{
			flag = true,
				walls = {	
		{
			size1 = 1,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position = Vector(0 , 0 , 0  ),
			positionadd = Vector(0,0,50),
			angle = Angle(0,0,0)
		},
		
		{
			size1 = 1,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(.99 , 0 , 1  ),
			positionadd = Vector(0,0,50),
			angle = Angle(0,90,90)
		},
	
		{
			size1 = 1,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(-.99 , 0, 1  ),
			positionadd = Vector(0,0,50),
			angle = Angle(0,90,90)
		},
		
		{
			size1 = 1,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(0 , .99 , 1  ),
			positionadd = Vector(0,0,50),
			angle = Angle(0,0,90)
		},
	
		{
			size1 = 1,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(0 , -.99, 1  ),
			positionadd = Vector(0,0,50),
			angle = Angle(0,0,90)
		}
		}
	
		 
		}
	 
	}
	 
 }
 
  ODDDIVIDERS = {
	 
	leftright = {
	{
		walls = {	
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector( .6, 1 , 1  ),
			angle = Angle(0,0,90)
		},
	
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector( -.6, -1 , 1  ),
			angle = Angle(0,0,90)
		},
		
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector( 0, 0 , 1  ),
			angle = Angle(0,0,90)
		}
		}
		 
	}
	
	},
		
	topbottom = {
	{
		walls = {	
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(1 , -.6 , 1  ),
			angle = Angle(0,90,90)
		},
	
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(-1 , .6 , 1  ),
			angle = Angle(0,90,90)
		},
		
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(0 , 0 , 1  ),
			angle = Angle(0,90,90)
		}
		}
		 
		}
	},
		
	generic = {
		
	{
		walls = {	
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position = Vector(0 , 0 , 1  ),
			angle = Angle(0,0,90)
		},
	
		{
			size1 = 1/2,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position = Vector(0 , 0 , 1  ),
			angle = Angle(0,90,90)
		}
		}
		 
		},
		
		{
			flag = true,
			walls = {	
		{
			size1 = 1,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position = Vector(0 , 0 , 0  ),
			positionadd = Vector(0,0,50),
			angle = Angle(0,0,0)
		},
		
		{
			size1 = 1,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(.99 , 0 , 1  ),
			positionadd = Vector(0,0,50),
			angle = Angle(0,90,90)
		},
	
		{
			size1 = 1,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(-.99 , 0, 1  ),
			positionadd = Vector(0,0,50),
			angle = Angle(0,90,90)
		},
		
		{
			size1 = 1,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(0 , .99 , 1  ),
			positionadd = Vector(0,0,50),
			angle = Angle(0,0,90)
		},
	
		{
			size1 = 1,
			size1add = 0,
			size2 = 1,
			size2add = 0,
			position =  Vector(0 , -.99, 1  ),
			positionadd = Vector(0,0,50),
			angle = Angle(0,0,90)
		}
	
		}
		}
	}
}
	 
  
 