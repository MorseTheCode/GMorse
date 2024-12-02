local Category = "Adventure Time"

local NPC = {   Name = "Finn the Human",
                Class = "npc_citizen",
				Model = "models/zeldazelda117models/adventure time/finn/f_rd.mdl",
				KeyValues = { citizentype = 4 },
				Category = Category }
             
list.Set( "NPC", "npc_apsci_01", NPC )


local NPC = {   Name = "BMO",
                Class = "npc_citizen",
				Model = "models/freeman/bmo.mdl",
				KeyValues = { citizentype = 4 },
				Category = Category }
             
list.Set( "NPC", "npc_apsci_02", NPC )



local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end


AddPlayerModel( "Finn the Human", 					"models/zeldazelda117models/adventure time/finn/f_rd.mdl" )
AddPlayerModel( "BMO",			"models/freeman/bmo.mdl" )