local Category = "Kermit"


local NPC = { 	Name = "Kermit", 
				Class = "npc_citizen",
				Model = "models/player/kermit.mdl",
				Health = "200",
				KeyValues = { citizentype = 4 },
				Category = Category	}

list.Set( "NPC", "kermit", NPC )

list.Set( "PlayerOptionsModel", "kermit",		"models/player/kermit.mdl" )
player_manager.AddValidModel( "kermit",		"models/player/kermit.mdl" )