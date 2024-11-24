GlowingTTT = {}

--CONFIGURATION
if CLIENT then
	GlowingTTT.DrawForTraitors = true --Draw the effect for traitors.
	GlowingTTT.DrawForDetectives = true --Draw the effect for detectives.
	GlowingTTT.TraitorGlowColor = Color(255, 0, 0) --Color for the traitor glow effect.
	GlowingTTT.DetectiveGlowColor = Color(0, 0, 255) --Color for the detective glow effect.
	GlowingTTT.TraitorGlowPerFrame = 2 --Higher values make the effect more visible for traitors but FPS might go down. Not recommended to edit this one.
	GlowingTTT.DetectiveGlowPerFrame = 2 --Higher values make the effect more visible for detectives but FPS might go down. Not recommended to edit this one.
end
--END OF CONFIGURATION

if SERVER then
	util.AddNetworkString("GlowingTTTAddOrRemovePlayer")
	
	function GlowingTTT.SpawnOrDeath(ply, spawn)
		--Convenience function for Powerrounds and Defibrillators
		if spawn and GetRoundState() != ROUND_ACTIVE and GetRoundState() != ROUND_POST then return end
		
		--Ignore if the player spawned in SpecDM
		if ply.IsGhost and ply:IsGhost() then return end
		
		local ply_role = ply:GetRole()
		if ply_role != ROLE_TRAITOR and ply_role != ROLE_DETECTIVE then return end
		
		net.Start("GlowingTTTAddOrRemovePlayer")
		net.WriteEntity(ply)
		
		if spawn then
			net.WriteBool(true)
		else
			net.WriteBool(false)
		end
		
		local teammates = {}
		
		if ply_role == ROLE_TRAITOR then
			for k, v in ipairs(player.GetAll()) do
				if v == ply then continue end
				if v:GetRole() != ROLE_TRAITOR then continue end
				table.insert(teammates, v)
			end
		else
			for k, v in ipairs(player.GetAll()) do
				if v == ply then continue end
				if v:GetRole() != ROLE_DETECTIVE then continue end
				table.insert(teammates, v)
			end
		end
		
		net.Send(teammates)
	end
else
	GlowingTTT.TraitorList = {}
	GlowingTTT.DetectiveList = {}

	CreateClientConVar("ttt_traitor_glow", "1", true, false)
	CreateClientConVar("ttt_detective_glow", "1", true, false)

	function GlowingTTT.Update()
		if not IsValid(LocalPlayer()) then return end
		if not LocalPlayer().GetRole then return end
		
		GlowingTTT.TraitorList = {}
		GlowingTTT.DetectiveList = {}
		
		if LocalPlayer():GetRole() == ROLE_TRAITOR then
			for k, v in ipairs(player.GetAll()) do
				if v:IsActiveTraitor() and v != LocalPlayer() then
					table.insert(GlowingTTT.TraitorList, v)
				end
			end
		elseif LocalPlayer():GetRole() == ROLE_DETECTIVE then
			for k, v in ipairs(player.GetAll()) do
				if v:IsActiveDetective() and v != LocalPlayer() then
					table.insert(GlowingTTT.DetectiveList, v)
				end
			end
		end
	end

	function GlowingTTT.Add()
		if LocalPlayer():GetRole() == ROLE_TRAITOR and GlowingTTT.DrawForTraitors and GetConVar("ttt_traitor_glow"):GetInt() == 1 then
			halo.Add(GlowingTTT.TraitorList, GlowingTTT.TraitorGlowColor, 0, 0, GlowingTTT.TraitorGlowPerFrame, true)
		elseif LocalPlayer():GetRole() == ROLE_DETECTIVE and GlowingTTT.DrawForDetectives and GetConVar("ttt_detective_glow"):GetInt() == 1 then
			halo.Add(GlowingTTT.DetectiveList, GlowingTTT.DetectiveGlowColor, 0, 0, GlowingTTT.DetectiveGlowPerFrame, true)
		end
	end
	
	net.Receive("GlowingTTTAddOrRemovePlayer", function()
		local mate = net.ReadEntity()
		if not IsValid(mate) then return end
		
		local spawn = net.ReadBool()
		local role = LocalPlayer():GetRole()
		
		if role == ROLE_TRAITOR and spawn then
			table.insert(GlowingTTT.TraitorList, mate)
		elseif role == ROLE_TRAITOR and not spawn then
			table.RemoveByValue(GlowingTTT.TraitorList, mate)
		elseif role == ROLE_DETECTIVE and spawn then
			table.insert(GlowingTTT.DetectiveList, mate)
		else
			table.RemoveByValue(GlowingTTT.DetectiveList, mate)
		end
	end)
end

function GlowingTTT.Checker()
	if GAMEMODE_NAME != "terrortown" then return end
	
	if SERVER then
		hook.Add("PlayerSpawn", "GlowingTTTSpawn", function(ply) GlowingTTT.SpawnOrDeath(ply, true) end)
		hook.Add("PlayerDeath", "GlowingTTTDeath", function(ply) GlowingTTT.SpawnOrDeath(ply, false) end)
	else
		hook.Add("TTTBeginRound", "GlowingTTTUpdate", function()
			timer.Simple(1, function() GlowingTTT.Update() end)
		end)
		
		hook.Add("PreDrawHalos", "GlowingTTTAdd", GlowingTTT.Add)
	end
end
hook.Add("PostGamemodeLoaded", "GlowingTTTChecker", GlowingTTT.Checker)