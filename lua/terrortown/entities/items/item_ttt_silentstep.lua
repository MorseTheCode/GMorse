if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/icon_silentstep.vmt")
	resource.AddFile("materials/vgui/ttt/perks/hud_silentstep.png")
end

ITEM.hud = Material("vgui/ttt/perks/hud_silentstep.png")
ITEM.EquipMenuData = {
	type = "item_passive",
	name = "item_silentstep_name",
	desc = "item_silentstep_desc",
}
ITEM.material = "vgui/ttt/icon_silentstep"
ITEM.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }

if SERVER then
	---
	---@param ply Player
	function ITEM:Equip(ply)
		ply:SetNWBool("ttt_silent_step", true)
	end

	---
	---@param ply Player
	function ITEM:Reset(ply)
		ply:SetNWBool("ttt_silent_step", false)
	end
end

hook.Add("PlayerFootstep", "TTTSilentStepNoSound", function(ply)
	---@cast ply Player
	if ply:GetNWBool("ttt_silent_step", false) then
		return true
	end
end)
