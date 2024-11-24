-- server config support for Flyby Shake: https://steamcommunity.com/sharedfiles/filedetails/?id=3049449608

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "submenu_addons_flybyshake_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_flybyshake_settings")

    form:MakeSlider({
        label = "label_shakeflyby_distance",
        convar = "shakeflyby_distance",
        min = 0,
        max = 1500,
        decimal = 0,
    })

    form:MakeSlider({
        label = "label_shakeflyby_intensity",
        convar = "shakeflyby_intensity",
        min = 0,
        max = 100,
        decimal = 0,
    })

    form:MakeSlider({
        label = "label_shakeflyby_time",
        convar = "shakeflyby_time",
        min = 0,
        max = 1,
        decimal = 1,
    })

    if not GetConVar("sv_shakeflyby_turnoffinvehicle"):GetBool() then
        form:MakeCheckBox({
            label = "label_shakeflyby_turnoffinvehicle",
            convar = "shakeflyby_turnoffinvehicle",
        })
    end

    form:MakeCheckBox({
        label = "label_shakeflyby_debug",
        convar = "shakeflyby_debug",
    })
end

function CLGAMEMODESUBMENU:ShouldShow()
    return ConVarExists("shakeflyby_distance")
end
