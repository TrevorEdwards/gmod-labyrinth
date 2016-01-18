ENT.Base = "base_ai"
ENT.Type = "ai" 
ENT.AutomaticFrameAdvance = true 
ENT.PrintName		= "Skill Shop"
ENT.Author			= "TB002"
ENT.Information		= "Edit your skills!"
ENT.Category		= "Labyrinth"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

 
function ENT:SetAutomaticFrameAdvance( bUsingAnim ) 
	self.AutomaticFrameAdvance = bUsingAnim
end