local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end

list.Set( "PlayerOptionsModel", "Tom", "models/tomjerry/tom.mdl" )
player_manager.AddValidModel( "Tom", "models/tomjerry/tom.mdl" )

list.Set( "PlayerOptionsModel", "Jerry", "models/tomjerry/jerry.mdl" )
player_manager.AddValidModel( "Jerry", "models/tomjerry/jerry.mdl" )