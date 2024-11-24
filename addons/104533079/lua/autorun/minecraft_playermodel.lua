if SERVER then
	AddCSLuaFile()
	resource.AddFile("models/player/blockdude.mdl")
	resource.AddFile("materials/models/player/blockdude/blockdude.vmt")
end

local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end

AddPlayerModel( "minecraft", "models/player/blockdude.mdl" )