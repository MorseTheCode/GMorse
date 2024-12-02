-- server config support for Flyby Sounds (fixed): https://steamcommunity.com/sharedfiles/filedetails/?id=3050439982

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "submenu_server_addons_flybysounds_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_flybysounds_settings")

    form:MakeHelp({
        label = "help_flybysound_minvolume",
    })

    form:MakeSlider({
        label = "label_sv_flybysound_minvol",
        serverConvar = "sv_flybysound_minvol",
        min = 0,
        max = 100,
        decimal = 0,
    })

    form:MakeHelp({
        label = "help_flybysound_speed",
    })

    form:MakeSlider({
        label = "label_sv_flybysound_minspeed",
        serverConvar = "sv_flybysound_minspeed",
        min = 0,
        max = 1500,
        decimal = 0,
    })

    form:MakeSlider({
        label = "label_sv_flybysound_maxspeed",
        serverConvar = "sv_flybysound_maxspeed",
        min = 0,
        max = 1500,
        decimal = 0,
    })

    form:MakeHelp({
        label = "help_flybysound_volume",
    })

    form:MakeSlider({
        label = "label_sv_flybysound_minshapevolume",
        serverConvar = "sv_flybysound_minshapevolume",
        min = 0,
        max = 500,
        decimal = 0,
    })

    form:MakeSlider({
        label = "label_sv_flybysound_maxshapevolume",
        serverConvar = "sv_flybysound_maxshapevolume",
        min = 0,
        max = 500,
        decimal = 0,
    })

    form:MakeCheckBox({
        label = "label_sv_flybysound_playersounds",
        serverConvar = "sv_flybysound_playersounds",
    })
end

function CLGAMEMODESUBMENU:ShouldShow()
    return ConVarExists("sv_flybysound_playersounds")
end
