local function AddPlayerModel( name, model )

    list.Set( "PlayerOptionsModel", name, model )
    player_manager.AddValidModel( name, model )
    
end

-- Dante

AddPlayerModel( "Dante","models/lskovfoged/dmc4/dante/dante.mdl")