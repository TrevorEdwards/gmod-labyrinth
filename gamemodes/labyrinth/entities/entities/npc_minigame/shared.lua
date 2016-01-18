ENT.Base = "base_ai"
ENT.Type = "ai" 
ENT.AutomaticFrameAdvance = true 
ENT.PrintName		= "Minigame NPC"
ENT.Author			= "TB002"
ENT.Information		= "Play dat game!"
ENT.Category		= "Labyrinth"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

 
function ENT:SetAutomaticFrameAdvance( bUsingAnim ) 
	self.AutomaticFrameAdvance = bUsingAnim
end