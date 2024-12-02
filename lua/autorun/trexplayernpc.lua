local Category = "Dinosaur humanoids"
local NPC = {
		Name = "T. Rex red", 
		Class = "npc_citizen",
		KeyValues = { citizentype = 4 },
		Model = "models/trex_player/trex_player.mdl",
		Health = "350",
		Category = Category	
		}
list.Set( "NPC", "npc_trex_pr", NPC )

local Category = "Dinosaur humanoids"
local NPC = {
		 Name = "T. Rex", 
		Class = "npc_citizen",
		KeyValues = { citizentype = 4 },
		Model = "models/trex_player/trex_player_gray.mdl",
		Health = "350",
		Category = Category	
		}
list.Set( "NPC", "npc_trex_p", NPC )
local NPC = {
		Name = "T. Rex red hostile",
		Class = "npc_combine_s",
		Category = Category,
		Model = "models/trex_player/trex_player.mdl",
		Weapons = { "weapon_crowbar" },
		KeyValues = { SquadName = "overwatch"}
}
list.Set( "NPC", "npc_trex_prh", NPC )
local NPC = {
		Name = "T. Rex hostile",
		Class = "npc_combine_s",
		Category = Category,
		Model = "models/trex_player/trex_player_gray.mdl",
		Weapons = { "weapon_crowbar" },
		KeyValues = { SquadName = "overwatch"}
}
list.Set( "NPC", "npc_trex_ph", NPC )