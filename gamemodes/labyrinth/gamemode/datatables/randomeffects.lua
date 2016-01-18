RANDOMEFFECTS = {

	{
	announce = "Gravity is reduced!",
	var = "lab_eff_gravity",
	activate = function()
	local choices = player.GetAll()
	for k,v in pairs(choices) do
		if (IsValid(v)) then
			v:SetGravity( 0.35 )
		end
	end
	end
	},
	
	{
	announce = "The labyrinth is flooding!",
	var = "lab_eff_flood",
	activate = function()
		OpenWater()
	end
	},
	
	{
	announce = "The labyrinth has had an infection!",
	var = "lab_eff_zombies",
	activate = function()
		GAMEMODE.zombies = true
	end
	},
	
	{
	announce = "Everybody has eyes in the back of his head!",
	var = "lab_eff_thirdperson",
	activate = function()
		GAMEMODE.thirdperson = true
		net.Start( "thirdperson" )
		net.WriteInt( 1, 4 )
		net.Broadcast()
	end
	},
	
	{
	announce = "The minotaur has wet feet!",
	var = "lab_eff_squeakyfeet",
	activate = function()
		GAMEMODE.squeakyfeet = true
	end
	},
	
	{
	announce = "The walls are made of glass!",
	var = "lab_eff_plasticwalls",
	activate = function()
		color = Color( 255, 255, 255, 80 )
	end
	},
	
	{
	announce = "The walls are deteriorating!",
	var = "lab_eff_deterioratingwalls",
	activate = function()
		timer.Simple( 8, function()
			if GetRoundState() == ROUND_PLAY then
			 destructablewalls = ents.FindByClass( "prop_physics" )
			roomsdestroyed = 0
				timer.Create( "shiva", .5, (len * len) / 3, function()
					local choice = table.Random( destructablewalls )
					while (choice.edge == nil or choice.edge) and #destructablewalls > 0 do
						table.RemoveByValue( destructablewalls, choice )
						choice = table.Random( destructablewalls )
					end
						table.RemoveByValue( destructablewalls, choice )
							if IsValid( choice ) && GetRoundState() == ROUND_PLAY && !choice.edge then
								for k,v in pairs( ents.FindInSphere( choice:GetPos(),5) ) do
									if IsValid( v ) && v.edge != nil && !v.edge && v != choice then
										v:Remove()
									end
								end
								
								local effectdata = EffectData()
								effectdata:SetStart( choice:GetPos() )
								effectdata:SetOrigin( choice:GetPos() )
								effectdata:SetScale( 4 )
								util.Effect( "cball_explode", effectdata )
								choice:EmitSound( "physics/cardboard/cardboard_box_break"..math.random(1,3)..".wav" )
								choice:Remove()
							end
						roomsdestroyed = roomsdestroyed + 1
				end)
			end
		end)
		end
	},
	
	{
	announce = "The minotaur is ravenously hungry!",
	var = "lab_eff_hungrymino",
	activate = function()
		local choices = player.GetAll()
		for k,v in pairs(choices) do
			if (IsValid(v) && GetRole( v ) == ROLE_MINOTAUR) then
				v:EmitSound("npc/zombie_poison/pz_breathe_loop2.wav", 40, 70)
			end
		end
	end
	},
	
	{
	announce = "The bug bait army attacks!",
	var = "lab_eff_bugbait",
	activate = function()
		choices = player.GetAll()
		for k,v in pairs(choices) do
			if IsValid(v) && GetRole( v ) == ROLE_PLAYER then
				v:Give( "weapon_bugbait" )
			end	
		end
	end
	}
}