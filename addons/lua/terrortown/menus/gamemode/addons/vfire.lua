-- server config support for vFire: https://steamcommunity.com/sharedfiles/filedetails/?id=1525218777

local TryT = LANG.TryTranslation

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "submenu_addons_vfire_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_vfire_settings")

    form:MakeHelp({
        label = "help_vfire_admin_settings",
    })

    form:MakeComboBox({
        label = "label_vfire_lod",
        convar = "vfire_lod",
        choices = {
            { title = TryT("choice_vfire_lod_0"), value = 0 },
            { title = TryT("choice_vfire_lod_1"), value = 1 },
            { title = TryT("choice_vfire_lod_2"), value = 2 },
        },
    })

    local enbGlow = form:MakeCheckBox({
        label = "label_vfire_enable_glows",
        convar = "vfire_enable_glows",
    })

    local enbLight = form:MakeCheckBox({
        label = "label_vfire_enable_glows",
        convar = "vfire_enable_glows",
        master = enbGlow,
    })

    form:MakeSlider({
        label = "label_vfire_light_brightness",
        convar = "vfire_light_brightness",
        min = 0,
        max = 2,
        decimal = 1,
        master = enbLight,
    })
end

function CLGAMEMODESUBMENU:ShouldShow()
    return vFireInstalled
end
