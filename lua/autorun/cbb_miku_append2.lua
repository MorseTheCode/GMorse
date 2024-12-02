--Add Playermodel
player_manager.AddValidModel( "Tda Hatsune Miku Append (v2)", "models/captainbigbutt/vocaloid/miku_append.mdl" )
player_manager.AddValidHands( "Tda Hatsune Miku Append (v2)", "models/captainbigbutt/vocaloid/c_arms/miku_append.mdl", 0, "00000000" )

--Add NPC
local NPC =
{
	Name = "Tda Hatsune Miku Append (v2)",
	Class = "npc_citizen",
	KeyValues = { citizentype = 4 },
	Model = "models/captainbigbutt/vocaloid/npc/miku_append.mdl",
	Category = "Vocaloid"
}

list.Set( "NPC", "npc_cbb_mikuappend2", NPC )


-- Send this to clients automatically so server hosts don't have to
if SERVER then
	resource.AddWorkshop("309754452")
end