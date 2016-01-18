local ply = FindMetaTable( "Player" )


function ply:SetGamemodeTeam( n )
	if n < 0 or n > 2 then return end
	
	self:SetTeam( n )
	self:SetNWInt( "role", n )
	
	if n == ROLE_MINOTAUR then
	
		self:SetupHands()
		self:Give( "weapon_crowbar" )
		self:SetColor(Color(255,255,255))
		SetProperModel( self )
	
	end
	
end

function SetProperHealth( ply, role, playNum )

	local minoBaseHp = 150
	local hpPerPoint = 2
	local minoHpPerPlayer = 4
	local humanBaseHp = 60
	
	if IsValid( ply ) then
	
		hpMax = 0
		if role == ROLE_PLAYER then
	
			hpMax = humanBaseHp + ply:GetNWInt( "health" ) * hpPerPoint
		
		elseif role == ROLE_MINOTAUR then
		
			hpMax = minoBaseHp + ply:GetNWInt( "health" ) * hpPerPoint + playNum * minoHpPerPlayer

		else
		
		end
		
		net.Start( "maxhealth" )
			net.WriteInt( hpMax, 10 )
		net.Send( ply )
		ply:SetHealth( hpMax )
			
	end
end

function SetProperModel( ply )

	if GetRole( ply ) == 2 then
		local model = ply:databaseGetValue( "minomodel" )
		
		if model == nil then
			model = "models/player/corpse1.mdl"
		end
		
		ply:SetModel( model )
		
	else
	
		local model = ply:databaseGetValue( "humanmodel" )
		
		if model == nil then
			model = "models/player/Group01/Male_01.mdl"
		end
		
		util.PrecacheModel( model )
		ply:SetModel( model )
	
	end
end

function GM:PlayerSetModel( ply )
	ply:SetModel( "models/player/Group01/Male_01.mdl" )
end

