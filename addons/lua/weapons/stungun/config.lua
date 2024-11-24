
/*
Stungun SWEP Created by Donkie (http://steamcommunity.com/id/Donkie/)
For personal/server usage only, do not resell or distribute!
*/

/*
GENERAL INFORMATION

Weaponclass: "stungun"
Ammotype: "ammo_stungun"
The stungun is only being tested on Sandbox, DarkRP (latest & 2.4.3) and TTT (latest) before releases.
*/

/*
CONFIG FILE
ONLY EDIT STUFF IN HERE
ANY EDITS OUTSIDE THIS FILE IS NOT MY RESPONSIBILITY
*/

/*****************
BASIC SECTION
******************/

//sollen die spieler die getazt wurden alles in der thirdperson form sehen oder in der first person, wenn thirdperson= true 
STUNGUN.Thirdperson = true

//falls ja sollen sie die möglichkeit haben durch das ducken zwischen first und thirdperson form zu wechseln ?
STUNGUN.AllowSwitchFromToThirdperson = true

//sollen andere spieler die stungun aufheben können ?
STUNGUN.AllowPhysgun = false

//sollen spieler die toolgun benutzen dürfen
STUNGUN.AllowToolgun = false

//Sollen getazte leute fallschaden kriegen ?
STUNGUN.Falldamage = true

//soll name und hp vom getazten spieler stehen ?
STUNGUN.ShowPlayerInfo = true

//sollen getazte spieler verwundbar sein während sie kampfunfähig sind?
STUNGUN.AllowDamage = true

//dürfen die spieler selbstmord begehen während sind paralyziert sind
STUNGUN.ParalyzeAllowSuicide = false

//dürfen spieler selbstmord begehen während sie gemuted sind
STUNGUN.MuteAllowSuicide = false

//wie viele sekunden soll es dauern bis ein getazter spieler wieder getazet werden kann? -1 um die funktion zu deaktivieren
STUNGUN.Immunity = 3

//dürfen sich auch spieler im team gegenseitig tazen?
//The check function is by default set to ignore police trying to taze police.
STUNGUN.AllowFriendlyFire = false

//Thirdperson holdtype. Put "revolver" to make him carry the gun in 2 hands, put "pistol" to make him one-hand the gun.
SWEP.HoldType = "revolver"

//wenn jemmand die waffe aufhebt was für eine ladung soll vorhanden sein ?
SWEP.Charge = 100

//Should we have infinite ammo (true) or finite ammo (false)?
//Finite ammo makes it spawn with 1 charge, unless you're running TTT in which you can specify how much ammo it should start with down below.
SWEP.InfiniteAmmo = false

//wie lang soll das nachladen der waffe dauern? (in sekunden)
SWEP.RechargeTime = 4

//How long range the weapon has. Players beyond this range won't get hit.
//To put in perspective, in darkrp, the above-head-playerinfo has a default range of 400.
SWEP.Range = 400

/*
There's two seperate times for this. This is so the person has a chance to escape but the robbers still have a chance to re-taze him.
Put the paralyzetime and mutetime at same to make the person able to talk exactly when he's able to get up.
Put the mutetime slightly higher than paralyze time to make him wait a few seconds before he's able to talk after he got up.
*/

//How many seconds the person is paralyzed = Unable to move.
STUNGUN.ParalyzedTime = 10

//How many seconds the person is mute/gagged = Unable to speak/chat.
STUNGUN.MuteTime = 12

//What teams are immune to the stungun? (if any).
local immuneteams = {
	TEAM_MAYOR, 
	TEAM_CHIEF
}

/*****************
ADVANCED SECTION
Contact me if you need help with any function.
******************/

/*
Hurt sounds
*/
local combinemodels = {["models/player/police.mdl"] = true, ["models/player/police_fem.mdl"] = true}
local females = {
	["models/player/alyx.mdl"] = true,["models/player/p2_chell.mdl"] = true,
	["models/player/mossman.mdl"] = true,["models/player/mossman_arctic.mdl"] = true}
function STUNGUN.PlayHurtSound( ply )
	local mdl = ply:GetModel()
	
	//Combine
	if combinemodels[mdl] or string.find(mdl, "combine") then
		return "npc/combine_soldier/pain"..math.random(1,3)..".wav"
	end
	
	//Female
	if females[mdl] or string.find(mdl, "female") then
		return "vo/npc/female01/pain0"..math.random(1,9)..".wav"
	end
	
	//Male
	return "vo/npc/male01/pain0"..math.random(1,9)..".wav"
end

/*
Custom same-team function.
*/
function STUNGUN.SameTeam(ply1, ply2)
	if STUNGUN.IsDarkRP then
		//Casesensitivity is a bitch. Backwards compatibility
		if ply1.isCP then
			if ply1:isCP() and ply2:isCP() then return true end
		elseif ply1.IsCP then
			if ply1:IsCP() and ply2:IsCP() then return true end
		end
	end
	
	//return (ply1:Team() == ply2:Team()) // Probably dont want this in DarkRP, nor TTT, but maybe your custom TDM gamemode.
end

/*
Custom Immunity function.
*/
function STUNGUN.IsPlayerImmune(ply)
	if type(immuneteams) == "table" and table.HasValue(immuneteams, ply:Team()) then return true end
	return false
end


/*****************
DarkRP Specific stuff
Only care about these if you're running it on a DarkRP server.
******************/

//Should the stungun charges be buyable in the f4 store?
//If yes, put in a number above 0 as price, if no, put -1 to disable.
STUNGUN.AddAmmoItem = 50

/*****************
TTT Specific stuff
Only care about these if you're running it on a TTT server.
******************/

//können opfer vom magnetostick aufgehoben werden können ?
SWEP.CanPickup = false

//standart muni.
SWEP.Ammo = 3

//Kind specifies the category this weapon is in. Players can only carry one of
//each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
//Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_EQUIP1

//If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
//be spawned as a random weapon.
SWEP.AutoSpawnable = false

//sollen traitor oder dete die waffe kaufen können 
//ROLE_DETECTIVE für dete ROLE_TRAITOR für traitor
SWEP.CanBuy = { ROLE_TRAITOR }

//InLoadoutFor is a table of ROLE_* entries that specifies which roles should
//receive this weapon as soon as the round starts. In this case, none.
SWEP.InLoadoutFor = nil

//If LimitedStock is true, you can only buy one per round.
SWEP.LimitedStock = false

//soll die waffe dropbar sein ? 
SWEP.AllowDrop = true
