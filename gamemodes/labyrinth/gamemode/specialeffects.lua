function PepperSpray( ply )

	if IsValid( ply ) && GetRole( ply ) >= 1 then
		net.Start( "blindness" )
		net.WriteInt( 5, 8 )
		net.Send( ply )
		printPlayer( ply, "You have been sprayed with pepperspray!" )
		ply:EmitSound( "npc/zombie/zombie_pain"..math.random(1,6)..".wav" )
		ply:SetMaterial( "models/shiny" )
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
		local col = ply:GetColor()
		ply:SetColor( Color( 0, 255, 0, col.a ) )
		timer.Simple( 5, function()
			local col = ply:GetColor()
			ply:SetColor( Color( 255, 255, 255, col.a ) )
			ply:SetMaterial( "" )
		end )
	end
	
end

function Untar( ply )

	if IsValid( ply ) && GetRole( ply ) >= 1 && ply:Alive() then
		printPlayer( ply, "You shook the tar off of your feet!" )
		GAMEMODE:SetPlayerSpeed( ply, ply:GetWalkSpeed() + 60, ply:GetRunSpeed() + 100 )
		local col = ply:GetColor()
		ply:SetMaterial( "" )
		ply:SetColor( Color( 255, 255, 255, col.a ) )
		ply:SetMaterial( "" )
	end

end

function TarSpray( ply )

	if IsValid( ply ) && GetRole( ply ) >= 1 then
	
		GAMEMODE:SetPlayerSpeed( ply, ply:GetWalkSpeed() - 60, ply:GetRunSpeed() - 100 )
		printPlayer( ply, "You have been sprayed with tar!" )
		ply:EmitSound( "npc/zombie/zombie_pain"..math.random(1,6)..".wav" )
		timer.Simple( 5, function() Untar( ply ) end )
		ply:SetMaterial( "models/shiny" )
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
		local col = ply:GetColor()
		ply:SetColor( Color( 0, 0, 0, col.a ) )
		
	end
	
end

function checkEffectAllowed( convar )
	if GetConVar( convar ):GetInt() == 1 then return true else return false end
end