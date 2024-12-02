local L = LANG.GetLanguageTableReference("en")

L["submenu_server_addons_vfire_title"] = "vFire"
L["submenu_addons_vfire_title"] = "vFire"
L["submenu_server_addons_flybyshake_title"] = "Flyby Shake"
L["submenu_addons_flybyshake_title"] = "Flyby Shake"
L["submenu_server_addons_flybysounds_title"] = "Flyby Sounds"

L["header_vfire_settings"] = "General vFire Settings"
L["header_vfire_spread"] = "vFire Spread Settings"
L["header_vfire_other"] = "Other vFire Settings"
L["header_flybysounds_settings"] = "Flyby Sounds Settings"
L["header_flybyshake_settings"] = "Flyby Shake Settings"

L["button_vfire_remove_all"] = "Remove active fires"

L["label_vfire_spread_boost"] = "Spread boost factor"
L["label_vfire_enable_damage"] = "Enable vFire damage"
L["label_vfire_enable_damage_in_vehicles"] = "Enable vFire damage in vehicles"
L["label_vfire_damage_multiplier"] = "vFire damage multiplier"
L["label_vfire_enable_explosion_fires"] = "Enable explosions creating vFire"
L["label_vfire_enable_explosion_effects"] = "Enable explosion effects"
L["label_vfire_enable_decals"] = "Enable vFire char decals"
L["label_vfire_decal_probability"] = "Char decal spawn chance"
L["label_vfire_enable_spread"] = "Enable vFire spread"
L["label_vfire_spread_delay"] = "Spread delay in seconds"
L["label_vfire_decay_rate"] = "vFire decay rate"
L["label_vfire_affect_npcs"] = "Enable vFire affecting NPCs"

L["help_vfire_spread"] = "vFire particles have a chance to spread that increases the fire area. It is possible to set the spread boost of new fires. Higher values will achieve faster, and stronger spread."

L["label_vfire_lod"] = "Level of detail (LOD)"
L["choice_vfire_lod_0"] = "Disable all vFire LODs"
L["choice_vfire_lod_1"] = "Automatic vFire LODs"
L["choice_vfire_lod_2"] = "Force vFire LODs on"
L["label_vfire_enable_glows"] = "Enable vFire glow effects"
L["label_vfire_enable_lights"] = "Enable vFire light effects (huge performance impact)"
L["label_vfire_light_brightness"] = "Brightness multiplier"

L["help_vfire_admin_settings"] = "Note: These are only the client side performance settings of vFire. To change the look and feel of vFire, head over to the server-addons sections of this menu"

L["label_sv_flybysound_minvol"] = "Minimum entity volume"
L["label_sv_flybysound_minspeed"] = "Speed lower bound"
L["label_sv_flybysound_maxspeed"] = "Speed upper bound"
L["label_sv_flybysound_minshapevolume"] = "Volume lower bound"
L["label_sv_flybysound_maxshapevolume"] = "Volume upper bound"
L["label_sv_flybysound_playersounds"] = "Players can trigger sound as well"

L["help_flybysound_minvolume"] = "Entities below the minimum volume do not create a sound at all."
L["help_flybysound_speed"] = "The upper and lower speed bounds for entities to in-/decrease the volume of the sound. Below the minimum speed it is inaudible."
L["help_flybysound_volume"] = "The upper and lower volume bounds for entities to in-/decrease the pitch of the sound."

L["label_sv_shakeflyby_turnoffinvehicle"] = "Disable shake if in vehicle"
L["label_shakeflyby_distance"] = "Maximum distance to trigger shake"
L["label_shakeflyby_intensity"] = "Shake intensity"
L["label_shakeflyby_time"] = "Shake duration"
L["label_shakeflyby_turnoffinvehicle"] = "Disable shake if in vehicle"
L["label_shakeflyby_debug"] = "Enable debug output"

L["help_shakeflyby_turnoffinvehicle"] = "Turning off the flyby shake in vehicles on the server, disables the corresponding client convar and removes it from the UI."
