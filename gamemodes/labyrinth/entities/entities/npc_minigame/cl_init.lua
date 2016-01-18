include("shared.lua")

function ENT:Draw()

    self.Entity:DrawModel()     
 
    
end
 

local function myMenu()

	
  local DermaPanel = vgui.Create( "DFrame" )
  DermaPanel:SetPos( ScrW() / 2 - 210, ScrH() / 2 - 125 )
  DermaPanel:SetSize( 420, 250 )
  DermaPanel:SetTitle( "Minigame Menu" ) 
  DermaPanel:SetVisible( true )
  DermaPanel:SetDraggable( true ) 
  DermaPanel:ShowCloseButton( true ) 
  DermaPanel:MakePopup()
 
  local PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent( DermaPanel )
	PropertySheet:SetPos( 10, 25 )
	PropertySheet:SetSize( 400, 200 )
  


local db1 = vgui.Create( "DButton", PropertySheet )
db1:SetText( "I want to play a minigame." )
db1:SetPos( 0, 0 )
db1:SetSize( 400, 75 )
db1.DoClick = function ()
	PlayMinigame()
	surface.PlaySound( "buttons/button9.wav" )
	DermaPanel:Close()
end

local db15 = vgui.Create( "DButton", PropertySheet )
db15:SetText( "I want to explore a big labyrinth until I die." )
db15:SetPos( 0, 75 )
db15:SetSize( 400, 75 )
db15.DoClick = function ()
	net.Start( "labyrinthexplore" )
	net.SendToServer()
	surface.PlaySound( "buttons/button9.wav" )
	DermaPanel:Close()
end

local db2 = vgui.Create( "DButton", PropertySheet )
db2:SetText( "Nevermind." )
db2:SetPos( 0, 150 )
db2:SetSize( 400, 50 )
db2.DoClick = function ()
	surface.PlaySound( "buttons/button9.wav" )
	DermaPanel:Close()
end


end

function PlayMinigame(  )

  net.Start( "minigame" )
  net.SendToServer()

end

usermessage.Hook("MinigameNPCUsed",myMenu) 
 