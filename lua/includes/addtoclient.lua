if SERVER then
	AddCSLuaFile("workshopoverride.lua")
end

if CLIENT then
	function resource.AddWorkshop(workshopID)
		print("AddWorkshop foi sobrescrito! ID recebido: " .. tostring(workshopID))
    	end
end