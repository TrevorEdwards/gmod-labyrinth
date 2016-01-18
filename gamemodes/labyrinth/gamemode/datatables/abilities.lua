HUMANABILITIES = {
	
	{
		name = "Dash",
		descrip = "Launch in the direction you're facing.",
		cooldown = 10,
		activate = function( ply )
			if !abilityRecharging( ply ) then
				ply:SetVelocity( ply:EyeAngles():Forward() * 540 )
				ply:EmitSound( "weapons/physcannon/energy_bounce"..math.random(1,2)..".wav" )
				ply:EmitSound( "labyrinth/human/dash"..math.random(1,3)..".wav" )
				setRecharge( ply, 10 )
			end
		end
	},

	{
		name = "Hide",
		descrip = "Cloak for a short duration.",
		cooldown = 25,
		activate = function( ply )
			if !abilityRecharging( ply ) then
				local hidetime = 4
				ply:SetRenderMode( RENDERMODE_TRANSALPHA )
				local col = ply:GetColor()
				ply:SetColor( Color( col.r, col.g, col.b, 0 ) )
				ply:DrawWorldModel(false)
				printPlayer( ply, "You are hiding.  You will stop hiding in "..hidetime.." seconds." )
				setRecharge( ply, 25 )
				ply.abilityactive = true
				ply:EmitSound( "labyrinth/human/hiding"..math.random(1,3)..".wav" )
				net.Start( "hiding" )
				net.Send( ply )
				timer.Simple( hidetime, function()
					if GetRoundState() == ROUND_PLAY and IsValid( ply ) and ply:Alive() and GetRole( ply ) > 0 and ply.abilityactive then
						local col = ply:GetColor()
						ply:SetColor( Color( col.r, col.g, col.b, 255 ) )
						ply:EmitSound( "labyrinth/human/nobody"..math.random(1,3)..".wav" )
						ply.abilityactive = false
						ply:DrawWorldModel(true)
					end
				end)
			end
		end
	},
	
	{
		name = "Recall",
		cooldown = 40,
		descrip = "Set a position, return to it at any time.",
		activate = function( ply )
			if !abilityRecharging( ply ) then
				local recalltime = 4
				ply.recpos = ply:GetPos()
				ply.ang = ply:EyeAngles()
				printPlayer( ply, "Recall location set.  Right click again to recall." )
				setRecharge( ply, 5000 )
				ply.abilityactive = true
			else
				if GetRoundState() == ROUND_PLAY and IsValid( ply ) and ply:Alive() and GetRole( ply ) > 0 and ply.abilityactive  then
					local recsound = "labyrinth/human/recall"..math.random(1,3)..".wav"
					local melon = ents.Create( "prop_physics" )
						melon:SetModel( "models/props_junk/watermelon01.mdl" )
						melon:SetPos( ply:GetPos() + Vector( 0, 0, 80 ))
						melon:Spawn()
						melon:EmitSound( recsound )
						local dirvec = ply.recpos - ply:GetPos()
						dirvec = dirvec * Vector( 1, 1, 0 )
						dirvec:Normalize()
						melon:GetPhysicsObject():ApplyForceCenter( dirvec * 3000 )
					ply:SetPos( ply.recpos )
					ply:SetEyeAngles( ply.ang )
					ply:EmitSound( recsound )
					ply.abilityactive = false
					setRecharge( ply, 40 )
				end
			end
		end
	},
	
	{
		name = "Switch",
		cooldown = 30,
		descrip = "Teleport to the opposite side of a wall.",
		activate = function( ply )
			if !abilityRecharging( ply ) then
				local trace = ply:GetEyeTrace()
				local target = trace.Entity

				if trace.HitPos:Distance( ply:GetShootPos() ) <= 200 then
					if IsValid( target) and target:GetClass() == "prop_physics" and  target.edge != nil and !target.edge then
						local dirvec = target:GetPos() - ply:GetPos() 
							dirvec:Normalize()
						local newpos =   target:GetPos() +  48 * dirvec 
						newpos = Vector( newpos.x, newpos.y, ply:GetPos().z )
						local block = false
						
						for k,v in pairs( ents.FindInSphere( newpos, 20 ) ) do
							if IsValid( v ) and ( (v:GetClass() == "prop_physics") or v:IsNPC() ) then
								block = true
							end
						end
						
						for k,v in pairs( ents.FindInSphere( newpos, 49 ) ) do
							if IsValid( v ) and ((v.edge != nil and v.edge) or v:GetClass() == "exit_beacon") then
								block = true
							end
						end
						
						if !block then
						
							local melon = ents.Create( "prop_physics" )
								melon:SetModel( "models/props_junk/watermelon01.mdl" )
								melon:SetColor( Color( 150, 255, 150 ) )
								melon:SetModelScale( 0.5, 0 )
								melon:SetPos( ply:GetPos() + Vector( 0, 0, 80 ))
								melon:Spawn()
						
							ply:SetPos( newpos )
							ply:EmitSound( "labyrinth/human/away"..math.random(1,3)..".wav" )
							setRecharge( ply, 30 )
						else
							printPlayer( ply, "Something is in the way!" )
						end
					end
				end
			
			
			end
		end
			
	}
}

MINOABILITIES = {
	
	{
		name = "Tar Explosion",
		cooldown = 30,
		descrip = "Slow humans in a small local radius.",
		activate = function( ply )
			if !abilityRecharging( ply ) then
				local hitcount = 0
				ply:EmitSound( "labyrinth/minotaur/tar"..math.random(1,2)..".wav" )
				for k,v in pairs(ents.FindInSphere( ply:GetPos(), 250 )) do
					if IsValid( v ) and v:IsPlayer() and GetRole( v ) == ROLE_PLAYER then
						TarSpray( v )
						hitcount = hitcount + 1
					end
				end
			local myPos = ply:GetPos() + Vector( 0, 0, 40 )
			local effectdata = EffectData()
			effectdata:SetStart( myPos )
			effectdata:SetOrigin( myPos )
			effectdata:SetScale( 6 )
			util.Effect( "cball_explode", effectdata )
			if hitcount == 0 then
				--ohno sound
			end
			setRecharge( ply, 30 )
			end
		end
	},
	
	{
		name = "Pepper Explosion",
		cooldown = 30,
		descrip = "Blind humans in a small local radius.",
		activate = function( ply )
			if !abilityRecharging( ply ) then
				local hitcount = 0
				ply:EmitSound( "labyrinth/minotaur/pepper"..math.random(1,2)..".wav" )
				for k,v in pairs(ents.FindInSphere( ply:GetPos(), 250 )) do
					if IsValid( v ) and v:IsPlayer() and GetRole( v ) == ROLE_PLAYER then
						PepperSpray( v )
						hitcount = hitcount + 1
					end
				end
			local myPos = ply:GetPos() + Vector( 0, 0, 40 )
			local effectdata = EffectData()
			effectdata:SetStart( myPos )
			effectdata:SetOrigin( myPos )
			effectdata:SetScale( 6 )
			util.Effect( "cball_explode", effectdata )
			if hitcount == 0 then
				--ohno sound
			end
			setRecharge( ply, 30 )
			end
		end
	},
	
	{
		name = "Lift",
		cooldown = 18,
		descrip = "Lift and disorient humans with a short cooldown.",
		activate = function( ply )
			if !abilityRecharging( ply ) then
			local targets = ents.FindInCone( ply:GetPos(), ply:EyeAngles():Forward(), 360, 30 )
			local hitcount = 0
			ply:EmitSound( "labyrinth/minotaur/lift"..math.random(1,3)..".wav" )
			for k,v in pairs(targets) do
				if IsValid( v ) then
					if v:IsPlayer() and GetRole( v ) == ROLE_PLAYER then
						v:Freeze( true )
						v:Freeze( false )
						v:SetVelocity( Vector( 0, 0, 800 ) )
						v:SetEyeAngles( Angle( math.random( -89, 89 ), math.random( -180, 180 ), 0 ) )
						v:ViewPunch( Angle(-10,0,0) )
						v:EmitSound( "physics/concrete/boulder_impact_hard"..math.random(1,4)..".wav" )
						hitcount = hitcount + 1
					elseif v:GetClass() == "prop_physics" then
						v:GetPhysicsObject():ApplyForceCenter( Vector( 0, 0, 500 * v:GetPhysicsObject():GetMass()   ) )
						v:EmitSound( "physics/concrete/boulder_impact_hard"..math.random(1,4)..".wav" )
					end
				end
			end
			setRecharge( ply, 18 )
			end
			
		end
	},
	
	{
		name = "Remodel",
		cooldown = 17,
		descrip = "Destroy walls of the Labyrinth.",
		activate = function( ply )
			if !abilityRecharging( ply ) then
				
				local trace = ply:GetEyeTrace()
				local target = trace.Entity

				if trace.HitPos:Distance( ply:GetShootPos() ) <= 300 then
					if IsValid( target) and target:GetClass() == "prop_physics" and  target.edge != nil and !target.edge then
						
						for k,v in pairs( ents.FindInSphere( target:GetPos(),5) ) do
							if IsValid( v ) && v.edge != nil && !v.edge && v != choice then
								v:Remove()
							end
						end
						
						local effectdata = EffectData()
								effectdata:SetStart( target:GetPos() )
								effectdata:SetOrigin( target:GetPos() )
								effectdata:SetScale( 4 )
								util.Effect( "cball_explode", effectdata )
								target:EmitSound( "physics/concrete/concrete_break3.wav" )
					
						ply:EmitSound( "labyrinth/minotaur/remodel"..math.random(1,2)..".wav" )
						setRecharge( ply, 17 )
					else
						printPlayer( ply, "Invalid target." )
					end
				else
					printPlayer( ply, "No target in range." )
				end
			end
		end
	},
	
	{
		name = "Blood Scent",
		cooldown = 45,
		descrip = "See human's last positions for a short time.",
		activate = function( ply )
			if !abilityRecharging( ply ) then
				local tab = {}
				for k,v in pairs( player:GetAll() ) do
					if IsValid( v ) and GetRole( v ) == ROLE_PLAYER then
						table.insert( tab, #tab + 1, { v, v:GetPos() } )
					end
				end
				
				net.Start( "bloodscent" )
					net.WriteTable( tab )
				net.Send( ply )
				ply:EmitSound( "npc/fast_zombie/fz_scream1.wav" )
				setRecharge( ply, 45 )
			end
			
		end
	}
}
