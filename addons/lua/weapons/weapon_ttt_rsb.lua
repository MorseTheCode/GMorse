-- Remote Sticky Bomb
if SERVER then
	AddCSLuaFile("rsb_config.lua")
end

SWEP.HoldType = "slam"

if CLIENT then
	SWEP.PrintName = "RSB"
	SWEP.Slot = 6

	SWEP.EquipMenuData = {
		type = "item_weapon",
		name = "RSB",
		desc = "A Remote Sticky Bomb. \"Living Bomb\""
	}

	SWEP.Icon = "vgui/ttt/icon_rsb.vmt"
end

SWEP.Author = "Marcuz"
SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.WeaponID = AMMO_C4
SWEP.UseHands = true
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/v_jb.mdl"
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 5.0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0
SWEP.LimitedStock = true
SWEP.arming = false
SWEP.armedandready = false
SWEP.loopingSound = nil
SWEP.targetBeeping = nil
SWEP.ply = nil
SWEP.AllowDrop = false
SWEP.NoSights = true

if SERVER then
	util.AddNetworkString("BombBar")
	util.AddNetworkString("RSBTarget")
	util.AddNetworkString("RSBWarning")
end

if CLIENT then
	surface.CreateFont("C4ModelTimer", {
		font = "Default",
		size = 30,
		weight = 0,
		antialias = false
	})
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	if self.arming == false and self.armedandready == false and self.Planted == true then
		self.arming = true
		self.AllowDrop = false
		enty = self.Owner:GetActiveWeapon()

		if SERVER then
			local ply = self.Owner
			net.Start("BombBar")
			net.WriteBit(true)
			net.Send(ply)
			self.BaseClass.ShootEffects(self)

			timer.Create("rsb_anim", 1, 0, function()
				if IsValid(self) then
					self.loopingSound = CreateSound(self, "weapons/c4/c4_beep1.wav") -- Plays that annoying loud noise
					self.loopingSound:PlayEx(0.5, 100)
					self.loopingSound:SetSoundLevel(0.2)
				end
			end)

			timer.Simple(GetConVar("RSB_ChargeTimer"):GetInt(), function()
				if IsValid(self.loopingSound) and self.loopingSound():IsPlaying() then
					self.loopingSound:Stop()
				end

				self.armedandready = true
				self.arming = false
				
				self:SendWarn(true)

				timer.Create("targetBeeping", 3, 0, function()
					if IsValid(self.target) then
						self.targetBeeping = CreateSound(self.target, "weapons/c4/c4_beep1.wav") -- Plays that annoying loud noise
						self.targetBeeping:PlayEx(0.5, 100)
						self.targetBeeping:SetSoundLevel(0.2)
					end
				end)

				timer.Remove("rsb_anim")
			end)
		end
	elseif self.arming == false and self.armedandready == true then
		self.Owner:PrintMessage(4, "You've already charged.")
	end

	if not self.Planted then
		self:StickyPlant()
	end
end

function SWEP:PrimaryAttack()
	if self.armedandready == true then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		local ply = self.Owner
	
		-- only detonate if the RSB target and owner are both alive
		-- also don't detonate if the target or owner is in spectator mode
		if self.target:Alive() and ply:Alive() and not self.target:IsSpec() and not ply:IsSpec() then
			self.targetWTF = CreateSound(self.target, "mm/wtf.mp3")
			self.targetWTF:PlayEx(1, 100)
			self.targetWTF:SetSoundLevel(0.2)

			timer.Simple(1, function()
				if ply:Alive() then
					timer.Remove("targetBeeping")
					net.Start("BombBar")
					net.WriteBit(false)
					net.Send(ply)
					self:Remove()
					self:DetonateBomb()
				end
			end)
		else
			self:Remove()
			self.target = nil
		end
	else
		if self.arming == false then
			self.Owner:PrintMessage(4, "You need to charge first!")
		end

		if self.arming == true then
			self.Owner:PrintMessage(HUD_PRINTTALK, "You are charging still, wait before detonating!")
		end
	end
end

-- Replicating C4 placing on a wall, but rather on a player
function SWEP:StickyPlant()
	if SERVER then
		local ply = self.Owner
		if not IsValid(ply) then return end
		local ignore = {ply,  self}
		local spos = ply:GetShootPos()
		local epos = spos + ply:GetAimVector() * 100

		local tr = util.TraceLine({
			start = spos,
			endpos = epos,
			filter = ignore,
			mask = MASK_SOLID
		})

		if tr.HitNonWorld then
			local target = tr.Entity

			if target:IsPlayer() then
				if IsValid(target) then
					ply:PrintMessage(HUD_PRINTCENTER, "You've planted a Sticky Bomb on " .. target:Nick() .. ". You need to charge the bomb now.(Right click)")
					self.Planted = true
					self.target = target
					target.attachedRSB = self
					
					net.Start("RSBTarget")
					net.WriteEntity(self.target)
					net.WriteString(GetConVar("RSB_ChargeTimer"):GetString())
					net.WriteString(GetConVar("RSB_EnableCam"):GetString())
					net.Send(ply)
				end
			end
		end
	end
end

function SWEP:RSBClear()
	local ply = self.Owner
	
	self:SendWarn(false)
	
	timer.Remove("rsb_anim")
	timer.Remove("targetBeeping")
	self.arming = false
	self.armedandready = false
	self.target = nil

	if IsValid(self.loopingSound) and self.loopingSound:IsPlaying() then
		self.loopingSound:Stop()
	end

	if IsValid(self.targetBeeping) and self.targetBeeping:IsPlaying() then
		self.targetBeeping:Stop()
	end

	net.Start("BombBar")
	net.WriteBit(false)
	net.Send(ply)
	
	self:Remove()
end

function SWEP:Think()
	local ply = self.Owner

	-- remove RSB if owner dies, or if the target dies
	if not ply:Alive() then
		self:RSBClear()
	end

	if IsValid(self.target) then
		if not self.target:Alive() then
			self:RSBClear()
		end
	
		if not self.target:Alive() then
			self:RSBClear()
			ply:PrintMessage(4, "Your target died, and you throw away the remote")
		
			self:Remove()
		end
	end
end

function SWEP:SendWarn(armed)	
	net.Start("RSBWarning")
	
	net.WriteBool(armed)
	net.WriteEntity(self.target)

	local traitors = GetTraitorFilter(true)
	table.RemoveByValue(traitors, self.target)
	
	net.Send(traitors)
end

function SWEP:DetonateBomb()
	if SERVER then
		local ply = self.Owner
		if not IsValid(ply) then return end
		local bomb = ents.Create("ttt_rsb")

		if IsValid(self.target) then
			if IsValid(bomb) then
				bomb:SetPos(self.target:GetPos())
				bomb:SetOwner(ply)
				bomb:SetParent(self.target)
				bomb:SetThrower(ply)
				bomb:Spawn()
				local spos = bomb:GetPos()

				local tr = util.TraceLine({
					start = spos,
					endpos = spos + Vector(0, 0, -32),
					mask = MASK_SHOT_HULL,
					filter = bomb:GetThrower()
				})

				local success, err = pcall(bomb.Explode, bomb, tr)
				net.Start("BombBar")
				net.WriteBit(false)
				net.Send(ply)
				
				self:RSBClear()

				if not success then
					self:RSBClear()
					bomb:Remove()
					ErrorNoHalt("ERROR CAUGHT: ttt_c4: " .. err .. "\n")
				end
			end
		else
			self:RSBClear()
		end
	end
end

function SWEP:Reload()
	return false
end

function SWEP:PreDrop()
	if self.AllowDrop == false then
		timer.Remove("rsb_anim")
		timer.Remove("targetBeeping")
		ply = self.Owner

		if IsValid(self.loopingSound) and self.loopingSound:IsPlaying() then
			self.loopingSound:Stop() -- Stop the sound if you die mid-charge
		end

		if IsValid(self.targetBeeping) and self.targetBeeping:IsPlaying() then
			self.targetBeeping:Stop()
		end

		net.Start("BombBar")
		net.WriteBit(false)
		net.Send(ply)
		self:Remove()
		self.arming = false
		self.armedandready = false
	end

	return self.BaseClass.PreDrop(self)
end

function SWEP:Holster()
	if self.arming == true then
		if self.Owner:IsValid() then
			self.Owner:PrintMessage(4, "You can't switch weapon whilst charging!")
		end

		self.AllowDrop = false

		return false
	else
		return true
	end
end

--[[

	CLIENT

]]--

if CLIENT then
	local targetText = "You have no target!"

	local hudtxt = {
		{
			text = "Primary fire to detonate",
			font = "TabLarge",
			xalign = TEXT_ALIGN_RIGHT
		},
		{
			text = "Secondary fire to plant on player",
			font = "TabLarge",
			xalign = TEXT_ALIGN_RIGHT
		},
		{
			text = "Secondary fire again to charge",
			font = "TabLarge",
			xalign = TEXT_ALIGN_RIGHT
		},
		{
			text = "" .. targetText .. "",
			font = "TabLarge",
			xalign = TEXT_ALIGN_RIGHT
		}
	}

	local target = ""
	local ChargeTimer = 0
	local EnableCam = true
	local RectStartPos = ScrW() / 3
	local MaxWidth = ScrW() / 3 - 4
	local StepSize = MaxWidth / (ChargeTimer * 10)
	local StepPercent = 100 / (ChargeTimer * 10)
	local CurrentWidth = 0
	local CurrentPercent = 0
	local ShowPercent = 0
	local Finished = true
	local DrawReady = false
	local Active = 0
	RSB.bombs = {}
	
	local function RSBResetValues()
		Active = 0
		RSB.bombs = {}
		local target = ""
	end
	hook.Add("TTTPrepareRound", "RSBResetValues", RSBResetValues)
	
	net.Receive("RSBWarning", function()
		--if(!IsValid(RSB.bombs)) then RSB.bombs = {} end
	
		local armed = net.ReadBool()
		local ent = net.ReadEntity()
		local idx = ent:EntIndex()	
		
		if armed then					
			RSB.bombs[idx] = idx
		else		
			RSB.bombs[idx] = nil
		end	
	end)

	net.Receive("RSBTarget", function(length, client)
		target = net.ReadEntity()
		
		if(IsValid(target)) then
			ChargeTimer = tonumber(net.ReadString())
			EnableCam = tobool(net.ReadString())
			StepSize = MaxWidth / (ChargeTimer * 10)
			StepPercent = 100 / (ChargeTimer * 10)
			targetText = "Your target is: " .. target:Nick()
			hudtxt[4]["text"] = targetText
		end	
	end)
	
	surface.SetFont("HudSelectionText")
	local c4warn = surface.GetTextureID("vgui/ttt/icon_c4warn")
	
	function drawRSBIcon()
		for k, v in pairs(RSB.bombs) do
			if !IsValid(Entity(v)) then RSB.bombs[v] = nil end
		
			local tgt = Entity(v)

			if (IsValid(tgt)) then				
				local ang = LocalPlayer():EyeAngles()
				tgt.pos = tgt:GetPos() + Vector(0, 0, 80) + ang:Up()
			
				local size = 24
				local no_shrink = true		
				local offset = 0
			
				local scrpos = tgt.pos:ToScreen()
				local sz = (IsOffScreen(scrpos) and (not no_shrink)) and size/2 or size

				scrpos.x = math.Clamp(scrpos.x, sz, ScrW() - sz)
				scrpos.y = math.Clamp(scrpos.y, sz, ScrH() - sz)

				if IsOffScreen(scrpos) then return end
				
				surface.SetTexture(c4warn)
				surface.SetTextColor(200, 55, 55, 220)
				surface.SetDrawColor(255, 255, 255, 200)

				surface.DrawTexturedRect(scrpos.x - sz, scrpos.y - sz, sz * 2, sz * 2)

				-- Drawing full size?
				if sz == size then
					local text = math.ceil(LocalPlayer():GetPos():Distance(tgt.pos))
					local w, h = surface.GetTextSize(text)

					surface.SetTextPos(scrpos.x - w/2, scrpos.y + (offset * sz) - h/2)
					surface.DrawText(text)

					w, h = surface.GetTextSize("RSB")
					surface.SetTextPos(scrpos.x - w / 2, scrpos.y + sz / 2)
					surface.DrawText("RSB")
				end				
			end				
		end
	end
	hook.Add("PostDrawHUD", "drawRSBIcon", drawRSBIcon)	

	function SWEP:DrawHUD()
		local x = ScrW() - 80
		hudtxt[1].pos = {x,  ScrH() - 40}
		draw.TextShadow(hudtxt[1], 2)
		hudtxt[2].pos = {x,  ScrH() - 80}
		draw.TextShadow(hudtxt[2], 2)
		hudtxt[3].pos = {x,  ScrH() - 60}
		draw.TextShadow(hudtxt[3], 2)
		hudtxt[4].pos = {x,  ScrH() - 100}
		draw.TextShadow(hudtxt[4], 2)
	end

	function DrawBar()
		Active = net.ReadBit()
		
		function TimerFunc()
			CurrentWidth = CurrentWidth + StepSize
			CurrentPercent = CurrentPercent + StepPercent
			ShowPercent = math.Round(CurrentPercent)

			if CurrentPercent > 99.9 then
				Finished = true
				DrawReady = true
				CurrentWidth = 0
				CurrentPercent = 0
			end
		end

		timer.Create("RemoteBombBarTimer", 0.1, ChargeTimer * 10, TimerFunc)
		Finished = false
	end

	if Active == 0 then
		Finished = true
		DrawReady = false
	end

	function DrawBox()
		if not Finished and not DrawReady and LocalPlayer():Alive() and Active == 1 then
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(RectStartPos, 2, RectStartPos, 40)
			surface.SetDrawColor(153, 0, 0, 255)
			surface.DrawRect(RectStartPos + 2, 4, CurrentWidth, 36)
			draw.SimpleText(ShowPercent .. "%", "Trebuchet22", ScrW() / 2, 21, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if Finished and DrawReady and LocalPlayer():Alive() and Active == 1 then
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(RectStartPos, 2, RectStartPos, 40)

			if (EnableCam and target:IsValid()) then
				local CamData = {}
				CamData.angles = Angle(0, target:EyeAngles().yaw, 0)
				CamData.origin = target:GetPos() + Vector(0, 0, 100)
				CamData.x = 0
				CamData.y = 0
				CamData.w = ScrW() / 3
				CamData.h = ScrH() / 3
				render.RenderView(CamData)
			end

			draw.SimpleText("Charged and ready!", "Trebuchet22", ScrW() / 2, 21, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if Active == 0 then
			Finished = true
			DrawReady = false
		end
	end
end

net.Receive("BombBar", DrawBar)
hook.Add("HUDPaint", "DrawBox", DrawBox)