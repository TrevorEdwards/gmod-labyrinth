ENT.Base = "base_ai" 
ENT.Type = "ai" 
ENT.AutomaticFrameAdvance = true 
ENT.PrintName		= "Model Shop"
ENT.Author			= "TB002"
ENT.Information		= "Choose your model!"
ENT.Category		= "Labyrinth"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

 
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end