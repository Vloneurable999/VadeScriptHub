local Module = {}

function Module.Load()
	print("yes")
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Vloneurable999/Vade-Script-Hub/refs/heads/main/Main/Systems/LoadVade.lua"))().LoadVade()
end

return Module