-- server config support for Flyby Shake: https://steamcommunity.com/sharedfiles/filedetails/?id=3049449608

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "submenu_server_addons_flybyshake_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_flybyshake_settings")

    form:MakeHelp({
        label = "help_shakeflyby_turnoffinvehicle",
    })

    form:MakeCheckBox({
        label = "label_sv_shakeflyby_turnoffinvehicle",
        serverConvar = "sv_shakeflyby_turnoffinvehicle",
    })
end

function CLGAMEMODESUBMENU:ShouldShow()
    return ConVarExists("sv_shakeflyby_turnoffinvehicle")
end
