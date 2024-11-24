local Category = "ELMO"

local NPC = { Name = "Elmo",
			Class = "npc_citizen",
			Model = "models/elmo.mdl",
			Health = "100",
			KeyValues = { citizentype = 1, SquadName = "resistance" },
			Category = Category }

list.Set( "NPC", "npc_elmo", NPC )



local Category = "ELMO"
local NPC = { Name = "Elmo Hostile",
			Class = "npc_combine_s",
			Model = "models/elmo_hostile.mdl",
			Health = "100",
			KeyValues = { SquadName = "teste", Numgrenades = 2 },
			Weapons = { "weapon_smg1","weapon_ar2","weapon_shotgun" },
			Category = Category }

list.Set( "NPC", "npc_elmo_hostile", NPC )


