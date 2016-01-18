include("shared.lua")

function ENT:Draw()

    self.Entity:DrawModel()       
 
    
end
 

local function myMenu()

	

  local DermaPanel = vgui.Create( "DFrame" )
  DermaPanel:SetPos( ScrW() / 2 - 400, ScrH() / 2 - 250 )
  DermaPanel:SetSize( 800, 500 )
  DermaPanel:SetTitle( "Model Shop" ) 
  DermaPanel:SetVisible( true )
  DermaPanel:SetDraggable( true )
  DermaPanel:ShowCloseButton( true ) 
  DermaPanel:MakePopup()
 
  local PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent( DermaPanel )
	PropertySheet:SetPos( 10, 25 )
	PropertySheet:SetSize( 780, 450 )
  
local HumanPanel = vgui.Create( "DScrollPanel", PropertySheet )
HumanPanel:SetPos( 25, 50 )
HumanPanel:SetSize( 640, 400 )
HumanPanel.Paint = function() 
    surface.SetDrawColor( 50, 50, 50, 255 ) 
    surface.DrawRect( 0, 0, HumanPanel:GetWide(), HumanPanel:GetTall() )
end

local MinoPanel = vgui.Create( "DScrollPanel", PropertySheet )
MinoPanel:SetPos( 25, 50 )
MinoPanel:SetSize( 640, 400 )
MinoPanel.Paint = function() 
    surface.SetDrawColor( 50, 50, 50, 255 ) 
    surface.DrawRect( 0, 0, MinoPanel:GetWide(), MinoPanel:GetTall() )
end

local curhmod = databaseGetValue( "humanmodel" )
local curmmod = databaseGetValue( "minomodel" )
local modh1 = HUMANMODELS[1].model
local modm1 = MINOMODELS[1].model

if !modm1 then  modh1 = "models/props_junk/watermelon01.mdl" end
if !modh1 then  modh1 = "models/props_junk/watermelon01.mdl" end
if !curmmod then curmmod = modh1 end
if !curhmod then curmmod = modm1 end

local MModelPanel = vgui.Create( "DPanel", MinoPanel )
MModelPanel:SetPos( 662, 0 )
MModelPanel:SetSize( 100, 200 )

local MModelShower = vgui.Create( "DModelPanel", MModelPanel )
MModelShower:SetSize( 100,200 )
MModelShower:SetModel( modm1 )
MModelShower:SetFOV( 35 )

local MeModelPanel = vgui.Create( "DPanel", MinoPanel )
MeModelPanel:SetPos( 662, 200 )
MeModelPanel:SetSize( 100, 200 )

local MeModelShower = vgui.Create( "DModelPanel", MeModelPanel )
MeModelShower:SetSize( 100,200 )
MeModelShower:SetModel( curmmod )
MeModelShower:SetFOV( 35 )


local HModelPanel = vgui.Create( "DPanel", HumanPanel )
HModelPanel:SetPos( 662, 0 )
HModelPanel:SetSize( 100, 200 )

local HModelShower = vgui.Create( "DModelPanel", HModelPanel )
HModelShower:SetSize( 100,200 )
HModelShower:SetFOV( 35 )
HModelShower:SetModel( modh1 )

local HeModelPanel = vgui.Create( "DPanel", HumanPanel )
HeModelPanel:SetPos( 662, 200 )
HeModelPanel:SetSize( 100, 200 )

local HeModelShower = vgui.Create( "DModelPanel", HeModelPanel )
HeModelShower:SetSize( 100,200 )
HeModelShower:SetFOV( 35 )
HeModelShower:SetModel( curhmod )


for i = 1, 6 do
	for j = 1, 5 do
		data = HUMANMODELS[i + (j - 1) * 6]
		if data != nil then
		
			local db = vgui.Create( "DButton", HumanPanel )
			db:SetText( data.name.." "..data.cost.."d" )
			db:SetPos( ( i - 1) * 110, ( j - 1) * 90 )
			db:SetSize( 110, 90 )
			db.Number = i + (j - 1) * 6
			db.model = data.model
			if table.HasValue( databaseGetValue( "models" ), data.model ) then
				if data.model == databaseGetValue( "humanmodel" ) then
					db:SetColor( Color( 0,0,150 ) )
				else
					db:SetColor( Color( 0,150,0 ) )
				end
			else
				db:SetColor( Color( 155,0,0 ) )
			end
			db.DoClick = function ()
				SelectModel( db.Number, 0)
				surface.PlaySound( "buttons/button9.wav" )
				DermaPanel:Close()
			end
			
			db.DoRightClick = function()
				HModelShower:SetModel( db.model )
			end
		
		end
	end
end


for i = 1, 6 do
	for j = 1, 5 do
		data = MINOMODELS[i + (j - 1) * 6]
		if data != nil then
		
			local db = vgui.Create( "DButton", MinoPanel )
			db:SetText( data.name.." "..data.cost.."d." )
			db:SetPos( ( i - 1) * 110, ( j - 1) * 90 )
			db:SetSize( 110, 90 )
			db.Number = i + (j - 1) * 6
			db.model = data.model
			if table.HasValue( databaseGetValue( "models" ), data.model ) then
				if data.model == databaseGetValue( "minomodel" ) then
					db:SetColor( Color( 0,0,150 ) )
				else
					db:SetColor( Color( 0,150,0 ) )
				end
			else
				db:SetColor( Color( 155,0,0 ) )
			end
			db.DoClick = function ()
				SelectModel( db.Number, 1)
				surface.PlaySound( "buttons/button9.wav" )
				DermaPanel:Close()
			end
			
			db.DoRightClick = function()
				MModelShower:SetModel( db.model )
			end
		
		end
	end
end

PropertySheet:AddSheet( "Human Models", HumanPanel, "gui/silkicons/user", false, false, "Buy Human Models" )
PropertySheet:AddSheet( "Minotaur Models", MinoPanel, "gui/silkicons/user", false, false, "Buy Minotaur Models" )
end

function SelectModel( model, kind )

  net.Start( "selectmodel" )
  net.WriteInt( model, 16 )
  net.WriteInt( kind, 4 )
  net.SendToServer()

end

usermessage.Hook("ModelNPCUsed",myMenu) 
 