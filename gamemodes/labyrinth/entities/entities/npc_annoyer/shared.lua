ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = true 
ENT.PrintName		= "Annoying NPC"
ENT.Author			= "TB002"
ENT.Information		= "Annoying as cluck!"
ENT.Category		= "Labyrinth"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

 
function ENT:SetAutomaticFrameAdvance( bUsingAnim ) 
	self.AutomaticFrameAdvance = bUsingAnim
end