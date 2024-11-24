if SERVER then AddCSLuaFile() end

player_manager.AddValidModel("W3-Geralt-Default", "models/player/tfa_w3_geralt_default.mdl")
player_manager.AddValidHands("W3-Geralt-Default", "models/weapons/c_arms_w3_geralt_default.mdl", 0, "0000")

local Category = "The Witcher 3"

local function AddNPC( t, class )
	list.Set( "NPC", class or t.Class, t )
end

AddNPC( {
	Name = "Geralt ( Default )",
	Class = "npc_citizen",
	Category = Category,
	Model = "models/npc/tfa_w3_geralt_default.mdl",
	KeyValues = { citizentype = CT_UNIQUE, SquadName = "resistance" }
}, "npc_tfa_w3_geralt_default" )