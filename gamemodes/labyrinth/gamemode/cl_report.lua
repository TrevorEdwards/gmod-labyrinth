surface.CreateFont( "ScoreboardDefault",
{
	font		= "Helvetica",
	size		= 22,
	weight		= 800
})

surface.CreateFont( "ScoreboardDefaultTitle",
{
	font		= "Helvetica",
	size		= 32,
	weight		= 800
})

infotable = nil

--
-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.
--
local INFO_LINE = 
{
	Init = function( self )	

		self.Name		= self:Add( "DLabel" )
		self.Name:Dock( FILL )
		self.Name:SetFont( "ScoreboardDefault" )
		self.Name:DockMargin( 8, 0, 0, 0 )

		self:Dock( TOP )
		self:DockPadding( 3, 3, 3, 3 )
		self:SetHeight( 32 + 3*2 )
		self:DockMargin( 2, 0, 2, 2 )

	end,

	Setup = function( self, pl )

		self.Player = pl

		self.Name:SetText( pl )

		self:Think( self )

		--local friend = self.Player:GetFriendStatus()
		--MsgN( pl, " Friend: ", friend )

	end,

	Think = function( self )


	end,

	Paint = function( self, w, h )

		draw.RoundedBox( 4, 0, 0, w, h, Color( 5,5,5, 255 ) )

	end,
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
INFO_LINE = vgui.RegisterTable( INFO_LINE, "DPanel" );

--
-- Here we define a new panel table for the scoreboard. It basically consists 
-- of a header and a scrollpanel - into which the player lines are placed.
--
local PROGRESS_BOARD = 
{
	Init = function( self )

		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 100 )

		self.Name = self.Header:Add( "DLabel" )
		self.Name:SetFont( "ScoreboardDefaultTitle" )
		self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Name:Dock( TOP )
		self.Name:SetHeight( 40 )
		self.Name:SetContentAlignment( 5 )
		self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )

		self.NumPlayers = self.Header:Add( "DLabel" )
		self.NumPlayers:SetFont( "ScoreboardDefault" )
		self.NumPlayers:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.NumPlayers:Dock( TOP )
	
		self.NumPlayers:SetSize( 300, 30 )
		self.NumPlayers:SetContentAlignment( 5 )
		self.Scores = self:Add( "DScrollPanel" )
		self.Scores:Dock( FILL )

	end,

	PerformLayout = function( self )

		self:SetSize( 700, 300 )
		self:SetPos( ScrW() / 2 - 350, 100 )

	end,

	Paint = function( self, w, h )

		draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 50, 200 ) )

	end,

	Think = function( self, w, h )
		if infotable == nil then return end
		if infotable["winscore"] > 50 then
			self.Name:SetText( "Humans Win!" )
			self.Name:SetTextColor( Color( 0, 255, 0, 255 ) )
		elseif infotable["winscore"] < 50 then
			self.Name:SetText( "Minotaurs Win!" )
			self.Name:SetTextColor( Color( 255, 0, 0, 255 ) )
		else
			self.Name:SetText( "Nobody Wins!" )
		end
		self.NumPlayers:SetText( "Human performance rating: "..math.floor( infotable["winscore"] ).."%" )
		self.NumPlayers:SetTextColor( Color( 255 * ( (100 - infotable["winscore"]) / 100), 255 * infotable["winscore"] / 100, 0, 255 ) )

		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		if not IsValid( hkScoreEntry ) then
			hkScoreEntry = vgui.CreateFromTable( INFO_LINE, hkScoreEntry )
			hkScoreEntry:Setup( infotable["humankills"] )
			self.Scores:AddItem( hkScoreEntry )
		end
		
		if not IsValid( mkScoreEntry ) then
			mkScoreEntry = vgui.CreateFromTable( INFO_LINE, mkScoreEntry )
			mkScoreEntry:Setup( infotable["minokills"] )
			self.Scores:AddItem( mkScoreEntry )
		end
		
		if not IsValid( esScoreEntry ) then
			esScoreEntry = vgui.CreateFromTable( INFO_LINE, esScoreEntry )
			esScoreEntry:Setup( infotable["escapes"] )
			self.Scores:AddItem( esScoreEntry )
		end
		
		if not IsValid( smScoreEntry ) then
			smScoreEntry = vgui.CreateFromTable( INFO_LINE, smScoreEntry )
			smScoreEntry:Setup( infotable["specialmessage"] )
			self.Scores:AddItem( smScoreEntry )
		end
		
	end,
}

PROGRESS_BOARD = vgui.RegisterTable( PROGRESS_BOARD, "EditablePanel" );

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
net.Receive( "endgamereport", function( len )

	if IsValid( LocalPlayer() ) then
		LocalPlayer():ConCommand("stopsound")
	end
	
	infotable = net.ReadTable( )
	
	if infotable[ "winscore" ] > 50 then
		timer.Simple( .3, function()
			surface.PlaySound( "music/HL1_song25_REMIX3.mp3" )
		end)
	elseif infotable[ "winscore" ] < 50 then
		timer.Simple( .3, function()
			surface.PlaySound( "music/stingers/industrial_suspense2.wav" )
		end)
	else
		timer.Simple( .3, function()
			surface.PlaySound( "music/radio1.mp3" )
		end)
	end
	
	
	if ( !IsValid( g_Reportboard ) ) then
		g_Reportboard = vgui.CreateFromTable( PROGRESS_BOARD )
	end

	if ( IsValid( g_Reportboard ) ) then
		g_Reportboard:Show()
		g_Reportboard:MakePopup()
		g_Reportboard:SetKeyboardInputEnabled( false )
		g_Reportboard:SetMouseInputEnabled( false )
	end
	
	timer.Simple( 6, function()
		ReportBoardHide()
	end)

end)

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
-----------------------------------------------------------]]
function ReportBoardHide()

	if ( IsValid( g_Reportboard ) ) then
		g_Reportboard:Hide()
		g_Reportboard = nil
		hkScoreEntry = nil
		mkScoreEntry = nil
		esScoreEntry = nil
		smScoreEntry = nil
	end

end


--[[---------------------------------------------------------
   Name: gamemode:HUDDrawScoreBoard( )
   Desc: If you prefer to draw your scoreboard the stupid way (without vgui)
-----------------------------------------------------------]]
function GM:HUDDrawScoreBoard()

end
