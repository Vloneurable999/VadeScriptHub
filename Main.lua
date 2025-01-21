local Module = {}

function Module.Load()
    print("yes")
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Vloneurable999/VadeScriptHub/refs/heads/main/Systems/LoadVade.lua"))().LoadVade()
end

return Module