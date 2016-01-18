include("shared.lua")

function ENT:Draw()

    self.Entity:DrawModel()     
 
    
end
 

local function myMenu()

	drachma = databaseGetValue( "drachma" ) or -1
	speed = databaseGetValue( "speed" ) or -1
	health = databaseGetValue( "health" ) or -1
	speedcost = 8 + 2^speed
	healthcost = 8 + 2^health
	
  local DermaPanel = vgui.Create( "DFrame" )
  DermaPanel:SetPos( ScrW() / 2 - 210, ScrH() / 2 - 125 )
  DermaPanel:SetSize( 420, 250 )
  DermaPanel:SetTitle( "Skill Shop          Drachma: "..drachma ) 
  DermaPanel:SetVisible( true )
  DermaPanel:SetDraggable( true ) 
  DermaPanel:ShowCloseButton( true ) 
  DermaPanel:MakePopup()
 
  local PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent( DermaPanel )
	PropertySheet:SetPos( 10, 25 )
	PropertySheet:SetSize( 400, 200 )
  


local db1 = vgui.Create( "DButton", PropertySheet )
db1:SetText( "Upgrade Speed to level "..(speed + 1).." for "..speedcost.." Drachma." )
db1:SetPos( 0, 0 )
db1:SetSize( 400, 100 )
db1.DoClick = function ()
	IncSkill( "speed" )
	surface.PlaySound( "buttons/button9.wav" )
	DermaPanel:Close()
end

local db2 = vgui.Create( "DButton", PropertySheet )
db2:SetText( "Upgrade Health to level "..(health + 1).." for "..healthcost.." Drachma." )
db2:SetPos( 0, 100 )
db2:SetSize( 400, 100 )
db2.DoClick = function ()
	IncSkill( "health" )
	surface.PlaySound( "buttons/button9.wav" )
	DermaPanel:Close()
end


end

function IncSkill( skill )

  net.Start( "skillupgrade" )
  net.WriteString( skill )
  net.SendToServer()

end

usermessage.Hook("ShopNPCUsed",myMenu) 
 