ENT.TimeBeforeDetonation = 3
ENT.ExplosionRange = 400
ENT.ExplosionDamage = 1000

if SERVER then AddCSLuaFile("shared.lua") end

if CLIENT then
   ENT.Icon = "vgui/ttt/icon_health.png"
   ENT.PrintName = "Bomb Station"

   local GetPTranslation = LANG.GetParamTranslation
   
   ENT.TargetIDHint = {
			  name = "hstation_name",
			  hint = "hstation_hint",
			  fmt  = function(ent, txt)
						return GetPTranslation(txt,
											   { usekey = Key("+use", "USE"),
												 num    = ent:GetStoredHealth() or 0 } )
					 end
			   };
end

ENT.Type = "anim"
ENT.Model = Model("models/props/cs_office/microwave.mdl")

ENT.CanHavePrints = true
ENT.MaxHeal = 25
ENT.MaxStored = 200
ENT.RechargeRate = 1
ENT.RechargeFreq = 2
ENT.NextHeal = 0
ENT.HealRate = 1
ENT.HealFreq = 0.2

ENT.Triggered = false

AccessorFuncDT(ENT, "StoredHealth", "StoredHealth")

AccessorFunc(ENT, "Placer", "Placer")

function ENT:SetupDataTables()
   self:DTVar("Int", 0, "StoredHealth")
end

local explodeSound = Sound("c4.explode")
function ENT:Explode()
	if not IsValid(self) then return end
	
	local pos = self:GetPos()
	local radius = self.ExplosionRange
	local damage = self.ExplosionDamage
	
	util.BlastDamage( self, self:GetPlacer(), pos, radius, damage )
	local effect = EffectData()
		effect:SetStart(pos)
		effect:SetOrigin(pos)
		effect:SetScale(radius)
		effect:SetRadius(radius)
		effect:SetMagnitude(damage)
	util.Effect("Explosion", effect, true, true)
	
	sound.Play( explodeSound, self:GetPos(), 60, 150 )
	self:Remove()
end

function ENT:Initialize()
   self:SetModel(self.Model)

   self:PhysicsInit(SOLID_VPHYSICS)
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_BBOX)

   local b = 32
   self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b,b,b))

   self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
   if SERVER then
      self:SetMaxHealth(200)

      local phys = self:GetPhysicsObject()
      if IsValid(phys) then
         phys:SetMass(200)
      end

      self:SetUseType(CONTINUOUS_USE)
   end
   self:SetHealth(200)

   self:SetColor(Color(180, 180, 250, 255))

   self:SetStoredHealth(200)

   self.NextHeal = 0
   
   if CLIENT then
		LANG.AddToLanguage("english", "bombstation_hint", "Press {usekey} to deplete the fake charge. Charge: {num}.")
		local GetPTranslation = LANG.GetParamTranslation
		if not LocalPlayer():IsTraitor() then
			self.TargetIDHint = {
			  name = "hstation_name",
			  hint = "hstation_hint",
			  fmt  = function(ent, txt)
						return GetPTranslation(txt,
											   { usekey = Key("+use", "USE"),
												 num    = self:GetStoredHealth() or 0 } )
					 end
			   };
		else
			self.TargetIDHint = {
			  name = "Bomb Station",
			  hint = "bombstation_hint",
			  fmt  = function(ent, txt)
						return GetPTranslation(txt,
											   { usekey = Key("+use", "USE"),
												 num    = self:GetStoredHealth() or 0 } )
					 end
			   };
		end
	end
end


function ENT:AddToStorage(amount)
   self:SetStoredHealth(math.min(self.MaxStored, self:GetStoredHealth() + amount))
end

function ENT:TakeFromStorage(amount)
   -- if we only have 5 healthpts in store, that is the amount we heal
   amount = math.min(amount, self:GetStoredHealth())
   self:SetStoredHealth(math.max(0, self:GetStoredHealth() - amount))
   return amount
end

local healsound = Sound("items/medshot4.wav")
local failsound = Sound("items/medshotno1.wav")

local beep = Sound("weapons/c4/c4_beep1.wav")

function ENT:Trigger(ply)
	if self.Triggered then return end
	
	self.Triggered = true
	
	for i=1,self.TimeBeforeDetonation do
		timer.Simple(i-1, function()
			sound.Play(beep, self:GetPos(), 75, 100)
		end)
	end
	
	timer.Simple(self.TimeBeforeDetonation, function()
		self:Explode()
	end)
	
	local att = ply
	local owner = self:GetPlacer()
	
	 if DMG_LOG and IsValid(att) and att:IsPlayer() then AddToDamageLog({DMG_LOG.BOMBSTATION, "TRIP", att:Nick(), att:GetRoleString(), owner:Nick() or "unknown", owner:GetRoleString() or "traitor", {att:SteamID(), owner:SteamID() or ""}}) end
end

local last_sound_time = 0
function ENT:GiveHealth(ply, max_heal)
   if self:GetStoredHealth() > 0 then
      max_heal = max_heal or self.MaxHeal
      local dmg = ply:GetMaxHealth() - ply:Health()
	  
	 local healed = self:TakeFromStorage(math.min(max_heal, dmg))
	 local new = math.min(ply:GetMaxHealth(), ply:Health() + healed)

	 if last_sound_time + 2 < CurTime() then
		self:EmitSound(healsound)
		last_sound_time = CurTime()
	 end
	 
	 if ply:IsActiveTraitor() then return end

	 self:Trigger(ply)

	 return true
   else
      self:EmitSound(failsound)
   end

   return false
end

function ENT:Use(ply)
   if IsValid(ply) and ply:IsPlayer() and ply:IsActive() then
      local t = CurTime()
      if t > self.NextHeal then
		local healed
         local healed = self:GiveHealth(ply, self.HealRate)

         self.NextHeal = t + (self.HealFreq * (healed and 1 or 2))
      end
   end
end

function ENT:OnTakeDamage(dmginfo)
   if dmginfo:GetAttacker() == self:GetPlacer() then return end

   self:TakePhysicsDamage(dmginfo)

   self:SetHealth(self:Health() - dmginfo:GetDamage())

   local att = dmginfo:GetAttacker()
   if IsPlayer(att) then
      DamageLog(Format("%s damaged bomb station for %d dmg",
                       att:Nick(), dmginfo:GetDamage()))
   end

   if self:Health() < 0 then
      self:Remove()

      util.EquipmentDestroyed(self:GetPos())
	  
	  local owner = self:GetPlacer()
	  if DMG_LOG and IsValid(att) and att:IsPlayer() then AddToDamageLog({DMG_LOG.BOMBSTATION, "DESTROY", att:Nick(), att:GetRoleString(), owner:Nick() or "unknown", owner:GetRoleString() or "traitor", {att:SteamID(), owner:SteamID() or ""}}) end

      if IsValid(self:GetPlacer()) then
         LANG.Msg(self:GetPlacer(), "Your Bomb Station has been destroyed!")
      end
   end
end

if SERVER then
   -- recharge
   local nextcharge = 0
   function ENT:Think()
      if nextcharge < CurTime() then
         self:AddToStorage(self.RechargeRate)

         nextcharge = CurTime() + self.RechargeFreq
      end
   end
end

if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_spykr_bomb.vmt")
end
