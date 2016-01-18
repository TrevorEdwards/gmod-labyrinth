include( "shared.lua" )
include( "database/cl_database.lua" )
include( "datatables/minomodels.lua" )
include( "datatables/humanmodels.lua" )
include( "datatables/endgamesongs.lua" )
include( "datatables/abilities.lua" )
include( "cl_scoreboard.lua" )
include( "cl_report.lua" )

-- This gamemode was created by TB002.  Unless specifically granted permission by TB002, you may not modify, copy, rebrand, or mess with this gamemode.  You, of course, may host a server using this gamemode.  That's totally fine.


client = LocalPlayer( );
players = 0
minPlayer = 2
readytime = 0
round = 1
drachma = 0
ready = false
role = "Observer"
maxhealth = 100
tele = 0
sight = 0
curmessage = ""
queue = {}
messageexpire = 0
slidex = 0
endTime = 0
thirdperson = false
telepos = nil
enablemusic = true
musictype = 0
readyplayers = 0
humanpositions = {}

surface.CreateFont( "DefaultFont", {
	font = "Arial",
	size = 16,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

if ENDGAMESONGS != nil then
for k,v in pairs(ENDGAMESONGS) do
	if file.Exists( "sound/"..v, "GAME" ) then
		util.PrecacheSound( v )
	end
end
end
  
util.PrecacheSound( "commentary/tf2-comment000.wav" )

  local playerList = nil
  local scorepanel = nil


function NumToRole( number )
	if number <= 0 then return "Observer"
	else if number == 1 then return "Human"
	else return "Minotaur"
	end
	end
end


function GM:HUDShouldDraw( name )
    if ( name == "CHudHealth" or name == "CHudAmmo" or name == "CHudWeapon" or name == "CHudBattery" ) then
        return false
    end
    return true
end


function GM:HUDPaint( )

	if role == "Observer" then
	 bcol = Color(25,25,100,0)
	elseif role == "Human" then
	 bcol = Color(25,100,25,0)
	else
	 bcol = Color(100,25,25,0)
	end
 

	Scrw, Scrh = ScrW(), ScrH()
	RelativeX, RelativeY = 0, Scrh
	xPos = 25
	yPos = ScrH() - 125
	draw.RoundedBox(5, xPos, yPos, 250, 100, bcol)
	

	if round == 1 then
		local nexttime = math.floor( readytime - CurTime() + 1)
		if nexttime < 0 then
			nexttime = 0
		end
		draw.SimpleText( "Pregame", "Trebuchet24", xPos + 15, ScrH() - 100, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "Drachma: "..drachma, "TargetID", xPos + 15, ScrH() - 80, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "Next game starts in: "..nexttime, "TargetID", xPos + 15, ScrH() - 60, Color(0,255,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "Ready players: "..readyplayers, "TargetID", xPos + 15, ScrH() - 40, Color(0,255,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
		
		local humancenter = Vector( 3376, 1760, 100)
		local normalcenter = Vector( 3058, 1760, 100)
		local minocenter = Vector( 2746, 1760, 100)
		
		humancenter = humancenter:ToScreen()
		normalcenter = normalcenter:ToScreen()
		minocenter = minocenter:ToScreen()
		
		draw.DrawText( "Stand here to be a human!", "TargetID", humancenter.x, humancenter.y, Color( 255, 255, 255, 255 ), 1 )
		draw.DrawText( "Stand here to random!", "TargetID", normalcenter.x, normalcenter.y, Color( 255, 255, 255, 255 ), 1 )
		draw.DrawText( "Stand here to be a minotaur!", "TargetID", minocenter.x, minocenter.y, Color( 255, 255, 255, 255 ), 1 )
		
		-- end blood scent
	
	
	elseif round == 2 then
	
		draw.SimpleText( "Setup", "Trebuchet24", xPos + 15, ScrH() - 100, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "Drachma: "..drachma, "TargetID", xPos + 15, ScrH() - 80, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "The game will start soon.", "TargetID", xPos + 15, ScrH() - 60, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

		if role == "Minotaur" then
			draw.SimpleText( role, "Trebuchet24", ScrW() - 100, 50, Color(230,0,0, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif role == "Human" then
			draw.SimpleText( role, "Trebuchet24", ScrW() - 100, 50, Color(0,230,0, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
	elseif round == 3 then
	
	if endTime > CurTime() then
		local bordersize = 6
		local posx = 25
		local posy = 50
		local font = "DefaultFont"
		local textColor = Color(255,255,255)
		local timecounter = "Time Left: "..(math.floor( endTime - CurTime() ) + 1)
		draw.WordBox( bordersize, posx, posy, timecounter, font, bcol, textColor )
	end
	
	if LocalPlayer():Alive() then
	if telepos != nil then
		local teleangle = -LocalPlayer():EyeAngles().y + (LocalPlayer():GetPos() - telepos):Angle().y
		surface.SetMaterial( Material( "icon16/arrow_down.png", "nocull" ) )
		surface.SetDrawColor( color_white )
		surface.DrawTexturedRectRotated( xPos + 190, yPos + 50, 50, 60, teleangle )
		draw.SimpleText( "Exit Sphere", "TargetID", xPos + 150 , ScrH() - 105, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end
		colrb = hp / maxhealth * 255
	else
		colrb = 255
	end
	
	draw.SimpleText( "", "Trebuchet24", xPos + 15, ScrH() - 100, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( "Drachma: "..drachma, "TargetID", xPos + 15, ScrH() - 80, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	if role == "Minotaur" then
		draw.SimpleText( role, "Trebuchet24", ScrW() - 100, 50, Color(230,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	elseif role == "Human" then
		draw.SimpleText( role, "Trebuchet24", ScrW() - 100, 50, Color(0,230,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	else
		draw.SimpleText( role, "Trebuchet24", ScrW() - 100, 50, Color(230,230,230), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end
	
	if LocalPlayer():Alive() && (role == "Human" or role == "Minotaur") then draw.SimpleText( "HP:"..LocalPlayer():Health(), "TargetID", xPos + 15, ScrH() - 60, Color(255,colrb,colrb), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP ) end

		
	else
	
	end
	
	if checkExpire() then
		if slidex < 40 then
			slidex = slidex + .5
		end
		local bordersize = 6
		local posx = xPos + 250 
		local posy = yPos + 50
		local font = "DefaultFont"
		local textColor = Color(255,255,255)
		draw.WordBox( bordersize, posx + slidex, posy, curmessage, font, bcol, textColor )
	end

	
	-- target ID's from gmod's base code, put here since they stopped working, but they are a default function
	
	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end
	
	local text = "ERROR"
	local text2 = ""
	local font = "Trebuchet24"
	
	if (trace.Entity:IsPlayer()) and trace.Entity:GetColor().a > 20 then
	
		text = trace.Entity:Nick()
		
	else
		return
	end
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	
	local MouseX, MouseY = gui.MousePos()
	
	if ( MouseX == 0 && MouseY == 0 ) then
	
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	
	end
	
	local x = MouseX
	local y = MouseY
	
	x = x - w / 2
	y = y + 30
	
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )
	
	y = y + h + 5
	local font = "Trebuchet18"
	if trace.Entity:Health() > 0 then
		local text = trace.Entity:Health()
	
		surface.SetFont( font )
		local w, h = surface.GetTextSize( text )
		local x =  MouseX  - w / 2
	
		draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
		draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
		draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )
	end
	
	local w, h = surface.GetTextSize( text2 )
	y = y + h
		local x =  MouseX  - w / 2
	draw.SimpleText( text2, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text2, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text2, font, x, y, self:GetTeamColor( trace.Entity ) )
	
end


--- post processing

local function specialprocessing()
	if round >= 2 && LocalPlayer():Alive() then 
	hp = LocalPlayer():Health()
	if hp < 40 then
		hpmod = hp / 40
	else
		hpmod = 1
	end
	postproccessor = {}
	if role == "Human" then
		postproccessor[ "$pp_colour_addr" ] = 0
		postproccessor[ "$pp_colour_addg" ] = 0
		postproccessor[ "$pp_colour_addb" ] = 0
		postproccessor[ "$pp_colour_brightness" ] = -.06 - sight
		postproccessor[ "$pp_colour_contrast" ] = 1 - ( 1 - hpmod ) * .3 + math.sin( CurTime() * 3 ) * musictype * .6
		postproccessor[ "$pp_colour_colour" ] = (1 - ( 1 - hpmod ) )
		postproccessor[ "$pp_colour_mulr" ] = .4 * math.sin( CurTime()  * 3) * musictype + .5 * musictype
		postproccessor[ "$pp_colour_mulg" ] = 0 - math.cos( CurTime()  * 3) * musictype * .3
		postproccessor[ "$pp_colour_mulb" ] = tele * 2 * (1 - hpmod ) - musictype
		DrawColorModify( postproccessor )
	elseif role == "Minotaur" then
		postproccessor[ "$pp_colour_addr" ] = musictype * .06
		postproccessor[ "$pp_colour_addg" ] = 0
		postproccessor[ "$pp_colour_addb" ] = 0
		postproccessor[ "$pp_colour_brightness" ] = -.06 - sight
		postproccessor[ "$pp_colour_contrast" ] = 1.1 * ( 1 - sight ) - musictype * .5
		postproccessor[ "$pp_colour_colour" ] = 0.1
		postproccessor[ "$pp_colour_mulr" ] = .5 + musictype
		postproccessor[ "$pp_colour_mulg" ] = 0.05 - musictype * .5
		postproccessor[ "$pp_colour_mulb" ] = 0.05 - musictype * .5
		DrawColorModify( postproccessor )
	else
	
	end
 
	end
end
hook.Add( "RenderScreenspaceEffects", "RenderColorModifyPOO", specialprocessing )

function addMessageToQueue( message )
	if #queue > 0 or curmessage != "" then
		if !table.RemoveByValue( queue, message ) and curmessage != message then
			queue[ #queue + 1 ] = message
			messageexpire = messageexpire - ( messageexpire - CurTime() ) * (3 / 5 )
		end
	else
		slidex = 0
		surface.PlaySound( "UI/buttonclick.wav" )
		local song = table.Random( MINOTAURSONGS )
		curmessage = message
		messageexpire = CurTime() + 4
	end
end

function checkExpire()
	if curmessage != "" then
		if messageexpire < CurTime() then
			if #queue > 0 then
				slidex = 0
				surface.PlaySound( "UI/buttonclick.wav" )
				curmessage = queue[1]
				table.remove( queue, 1 )
				messageexpire = CurTime() + ( 4 / (#queue + 1) )
			else
				curmessage = ""
			end
		end
		return true
	else
		return false
	end
end


net.Receive( "soundtrack", function()

	local info = net.ReadTable()
	PlaySoundtrack( info[1], info[2] )

end)

net.Receive( "readyplayers", function()

	readyplayers = net.ReadInt( 10 )
end)

function PlaySoundtrack( filepath, soundtype)

	musictype = soundtype
	if not enablemusic then return end

	if soundtype == 0 then
		
		if mystartsound == nil then
			startsound = Sound(filepath)
			mystartsound = CreateSound( LocalPlayer(), startsound )
			mystartsound:Play()
			mystartsound:ChangeVolume( .55, 0 )
		else
			if mystartsound:IsPlaying() then
				mystartsound:ChangeVolume( .55, 2 )
			else
				mystartsound:Play()
			end
	
			if myendsound != nil and myendsound:IsPlaying() then
				myendsound:ChangeVolume( 0.01, 2 )
			end
		
		end
	
	else
	
		if myendsound == nil then
			endsound = Sound(filepath)
			myendsound = CreateSound( LocalPlayer(), endsound )
			myendsound:Play()
			myendsound:ChangeVolume( .66, 0 )
			if mystartsound != nil and mystartsound:IsPlaying() then
				mystartsound:ChangeVolume( 0.01, 2 )
			end
		else
			if myendsound:IsPlaying() then
				myendsound:ChangeVolume( .66, 2 )
			else
				myendsound:Play()
			end
	
			if mystartsound != nil and mystartsound:IsPlaying() then
				mystartsound:ChangeVolume( 0.01, 2 )
			end
		
		end
	
	
	end

end

net.Receive("roundinfo", function(len)
	lr = round
	round = net.ReadInt( 3 )
	if round == 1 then
		surface.PlaySound( "buttons/button5.wav" )
		tele = 0
		sight = 0
		endTime = 0
		thirdperson = false
		telepos = nil
		mystartsound = nil
		musictype = 0
		myendsound = nil
	elseif round == 2 then
		players = 0
		ready = false
		sight = 0
		endTime = 0
		thirdperson = false
		surface.PlaySound( "ambient/materials/metal_big_impact_scrape1.wav" )
		
	else
		if role == "Minotaur" then surface.PlaySound( "labyrinth/gamestartmino.wav" ) end
		if role == "Human" then surface.PlaySound( "labyrinth/gamestarthuman.wav" ) end
		local song = table.Random( GAMESTARTSONGS )
	end
	
	if round == 1 and lr == 3 then
		surface.PlaySound( "labyrinth/gameover.wav" )
	end
	
end)

net.Receive("drachma", function(len)
	drachma = net.ReadInt( 30 )
end)

net.Receive("playermessage", function(len)
	local message = net.ReadString(  )
	addMessageToQueue( message )
end)

net.Receive("endtime", function(len)
	endTime = net.ReadDouble( 32 )
end)

net.Receive("blindness", function(len)
	time = net.ReadInt( 8 )
	if sight == 0 then
		sight = 1
		timer.Simple( time, function()
			sight = 0
		end)
	end
end)

net.Receive("readytime", function(len)
	readytime = CurTime() + net.ReadDouble( 32 )
end)

net.Receive( "helpmenu", function( len )
	

	 local DermaPanel = vgui.Create( "DFrame" )
	 
	DermaPanel:SetSize(ScrW() * 0.95, ScrH() * 0.95)
  DermaPanel:SetPos((ScrW() - DermaPanel:GetWide()) / 2, (ScrH() - DermaPanel:GetTall()) / 2)
  DermaPanel:SetTitle( "Player Menu" ) 
  DermaPanel:SetVisible( true )
  DermaPanel:SetDraggable( true )
  DermaPanel:MakePopup()
  
	if databaseGetValue( "lifetimedrachma" ) != nil and databaseGetValue( "lifetimedrachma" )  < 10 and role == "Observer" then
	DermaPanel:ShowCloseButton( false ) 
		timer.Simple( 7, function()
					DermaPanel:ShowCloseButton( true ) 
			end )
	else
		DermaPanel:ShowCloseButton( true ) 
	end
  
  local PropertySheet = vgui.Create( "DPropertySheet", DermaPanel )
	PropertySheet:SetParent( DermaPanel )
	PropertySheet:SetSize(ScrW() * 0.9, ScrH() * 0.9)
	PropertySheet:SetPos((ScrW() - PropertySheet:GetWide()) / 4, (ScrH() - PropertySheet:GetTall()) / 2)
	
	local HelpPanel = vgui.Create( "HTML", PropertySheet )
	HelpPanel:SetSize(ScrW() * 0.9, ScrH() * 0.9)
	HelpPanel:SetPos((ScrW() - HelpPanel:GetWide()) / 4, (ScrH() - HelpPanel:GetTall()) / 2)
	HelpPanel:OpenURL("http://motd.ftwgamer.com/labyrinth-help.php")
	HelpPanel.Paint = function() 
    surface.SetDrawColor( 50, 50, 50, 255 ) 
    surface.DrawRect( 0, 0, HelpPanel:GetWide(), HelpPanel:GetTall() )
	end
	
	local SettingsPanel = vgui.Create( "DForm", PropertySheet )
		SettingsPanel:SetSize(ScrW() * 0.9, ScrH() * 0.9)
	SettingsPanel:SetPos((ScrW() - SettingsPanel:GetWide()) / 4, (ScrH() - SettingsPanel:GetTall()) / 2)
		SettingsPanel:SetName( "Settings" )
		SettingsPanel:Button( "Toggle Music", "ToggleMusic" )
	
	local StatsPanel = vgui.Create( "DListView", PropertySheet )
		StatsPanel:AddColumn( "Stat" )
		StatsPanel:AddColumn( "Your amount" )
		StatsPanel:AddColumn( "Record amount" )
		StatsPanel:AddColumn( "Record Holder" )
		StatsPanel:SetSize(ScrW() * 0.9, ScrH() * 0.9)
	StatsPanel:SetPos((ScrW() - StatsPanel:GetWide()) / 4, (ScrH() - StatsPanel:GetTall()) / 2)
		StatsPanel:SetName( "Settings" )
		
		local serverstats = net.ReadTable()
		local mytab = databaseTable()
		StatsPanel:AddLine( "Human Kills", mytab["humankills"],  serverstats["humankills"],  serverstats["humankillsname"] )
		StatsPanel:AddLine( "Minotaur Kills", mytab["minotaurkills"], serverstats["minotaurkills"],  serverstats["minotaurkillsname"] )
		StatsPanel:AddLine( "Sprays", mytab["sprays"], serverstats["sprays"],  serverstats["spraysname"] )
		StatsPanel:AddLine( "Minigame Wins", mytab["minigamewins"], serverstats["minigamewins"],  serverstats["minigamewinsname"] )
		StatsPanel:AddLine( "Labyrinth Escapes", mytab["escapes"], serverstats["escapes"],  serverstats["escapesname"] )
		StatsPanel:AddLine( "Labyrinth Wins", mytab["gamewins"], serverstats["gamewins"],  serverstats["gamewinsname"] )
		StatsPanel:AddLine( "Lifetime Drachma", mytab["lifetimedrachma"], serverstats["lifetimedrachma"],  serverstats["lifetimedrachmaname"] )
	
	PropertySheet:AddSheet( "Help", HelpPanel, "gui/silkicons/user", false, false, "Have questions answered." )
	PropertySheet:AddSheet( "Settings", SettingsPanel, "gui/silkicons/user", false, false, "Set things." )
	PropertySheet:AddSheet( "Stats", StatsPanel, "gui/silkicons/user", false, false, "Brag about stuff people don't care about." )

  
  
end)

net.Receive("myrole", function(len)
	role = NumToRole( net.ReadInt( 4 ) )
	if role == "Human" then
		surface.PlaySound( "labyrinth/human/human"..math.random(1,2)..".wav" )
	elseif role == "Minotaur" then
		surface.PlaySound( "labyrinth/minotaur/minotaur.wav" )
	else
		thirdperson = false
	end
end)


net.Receive( "telepos", function( len )
	telepos = net.ReadVector( )
end)


net.Receive("teleporterspawned", function(len)
	--local telepos = net.ReadVector( )
	
	local song = table.Random( MINOTAURSONGS )
		
	if role == "Minotaur" then surface.PlaySound( "labyrinth/teleporterappearedminos.wav" ) end
	if role == "Human" then surface.PlaySound( "labyrinth/teleporterappearedhumans.wav" ) end
	
	tele = 1
end)

net.Receive("maxhealth", function(len)
	maxhealth = net.ReadInt( 10 )
end)



function ToggleMusic( ply, command, arguments )
	if enablemusic then addMessageToQueue( "Disabled music." ) end
	if !enablemusic then addMessageToQueue( "Enabled music." ) end
	enablemusic = !enablemusic
end

 
concommand.Add( "ToggleMusic", ToggleMusic )