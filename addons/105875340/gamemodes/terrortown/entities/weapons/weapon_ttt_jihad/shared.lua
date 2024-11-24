if SERVER then
    AddCSLuaFile( "shared.lua" )
    resource.AddFile("materials/vgui/ttt/IED_icon.vtf")
    resource.AddFile("materials/vgui/ttt/IED_icon.vmt")
    resource.AddFile("materials/vgui/entities/weapon_jihadbomb.vmt")
    resource.AddFile("materials/vgui/entities/weapon_jihadbomb.vtf")

    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb1.vtf")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb1.vmt")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb1_planted.vtf")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb1_ref.vtf")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb2.vmt")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb2.vtf")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb3b.vmt")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb3b.vtf")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/hand.vmt")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/hand.vtf")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_04.vmt")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_04.vtf")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_45.vmt")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_45.vtf")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_active.vmt")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_active.vtf")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_off.vmt")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_off.vtf")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_off_ref.vtf")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_on.vmt")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_on.vtf")
    resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_ref.vtf")
    resource.AddFile("materials/models/weapons/w_models/pr0d.c4/bomb1.vmt")
    resource.AddFile("materials/models/weapons/w_models/pr0d.c4/bomb1_planted.vmt")
    resource.AddFile("materials/models/weapons/w_models/pr0d.c4/bomb2.vmt")
    resource.AddFile("materials/models/weapons/w_models/pr0d.c4/bomb3b.vmt")
    resource.AddFile("materials/models/weapons/w_models/pr0d.c4/hand.vmt")
    resource.AddFile("materials/models/weapons/w_models/pr0d.c4/screen_04.vmt")
    resource.AddFile("materials/models/weapons/w_models/pr0d.c4/screen_45.vmt")
    resource.AddFile("materials/models/weapons/w_models/pr0d.c4/screen_active.vmt")
    resource.AddFile("materials/models/weapons/w_models/pr0d.c4/screen_off.vmt")
    resource.AddFile("materials/models/weapons/w_models/pr0d.c4/screen_on.vmt")

    resource.AddFile("models/weapons/v_jb.mdl")
    resource.AddFile("models/weapons/w_jb.mdl")
    resource.AddFile("sound/ttt/jihad.wav")
    resource.AddFile("sound/ttt/boom.wav")
end
 
---------------------------------------------------------
-- SWEP Details
---------------------------------------------------------
SWEP.Author                 = "Gaz492"
SWEP.Purpose                = "Sacrifice yourself for Allah."
SWEP.Instructions           = "Left Click to make yourself EXPLODE. Right click to taunt."

SWEP.PrintName              = "Jihad Bomb"	
SWEP.Slot                   = 7

SWEP.DrawCrosshair          = false
SWEP.NoSights               = true
SWEP.DrawAmmo               = false
SWEP.DrawCrosshair          = false
SWEP.ViewModelFlip          = false

SWEP.Icon                   = "vgui/ttt/IED_icon"
SWEP.ViewModel              = Model("models/weapons/v_jb.mdl")
SWEP.WorldModel             = Model("models/weapons/w_jb.mdl")

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 5.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 1.0

SWEP.Base                   = "weapon_tttbase"
SWEP.Kind                   = WEAPON_EQUIP1
SWEP.CanBuy                 = { ROLE_TRAITOR } -- only traitors can buy
SWEP.AutoSpawnable          = false
SWEP.EquipMenuData = {
    type="Weapon",
    name="Jihad Bomb",
    desc="Suicude bomb that will hug your friends. \nPlease note this is non-refundable after use."
};

---------------------------------------------------------
-- Add Sounds
---------------------------------------------------------
sound.Add( 
    {
        name = "ttt_jihad",
        channel = CHAN_AUTO,
        volume = 1.0,
        level = 80,
        pitch = 100,
        sound = "ttt/jihad.wav"
    }
)

sound.Add(
    {
        name = "ttt_jihad_explosion",
        channel = CHAN_AUTO,
        volume = 1.0,
        level = 80,
        pitch = 100,
        sound = "ttt/boom.wav"
    }
)

---------------------------------------------------------
-- SWEP Init
---------------------------------------------------------

function SWEP:Initialize()
end

function SWEP:Think()  
end

---------------------------------------------------------
-- Reload (Does Nothing)
---------------------------------------------------------
function SWEP:Reload()
end
---------------------------------------------------------
--	PrimaryAttack
---------------------------------------------------------
function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire(CurTime() + 3)

    local effectdata = EffectData()

    effectdata:SetOrigin( self.Owner:GetPos() )
    effectdata:SetNormal( self.Owner:GetPos() )
    effectdata:SetMagnitude( 8 )
    effectdata:SetScale( 1 )
    effectdata:SetRadius( 26 )
            
    util.Effect( "Sparks", effectdata )
    self.BaseClass.ShootEffects( self )

    -- The rest is only done on the server
    if (SERVER) then
        self.Owner:EmitSound( "ttt_jihad" )
        timer.Simple(2, function() self:Asplode() end )
    end
end
    
-- The asplode function
function SWEP:Asplode()
    local k, v
        
    -- Make an explosion at your position
    local ent = ents.Create( "env_explosion" )

    ent:SetPos( self.Owner:GetPos() )
    ent:SetOwner( self.Owner )
    ent:Spawn()
    ent:SetKeyValue( "iMagnitude", "150" )
    ent:Fire( "Explode", 0, 0 )
    ent:EmitSound( "ttt_jihad_explosion", 500, 500 )
    self:Remove()
end
    
---------------------------------------------------------
--	SecondaryAttack
---------------------------------------------------------
function SWEP:SecondaryAttack()	
    self.Weapon:SetNextSecondaryFire( CurTime() + 1 )    
    local TauntSound = Sound( "vo/npc/male01/overhere01.wav" )
    self.Weapon:EmitSound( TauntSound )
end