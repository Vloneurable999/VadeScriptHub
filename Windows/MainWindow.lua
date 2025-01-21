local Module = {}

--// Variables \\--

local SaveVade = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vloneurable999/VadeScriptHub/refs/heads/main/Systems/SaveVade.lua"))()
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local owner = "Upbolt"
local branch = "revision"
local SaveGameSettings = {}
local Loaded = {
	["DarkDex"] = false,
	["Hydroxide"] = false,
	["AimBot"] = false
}

--// Main \\--

function Module.WebImport(file)
	return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
end

function Module.CreateMainWindow()
	local Window = Rayfield:CreateWindow({
		Name = "Vade Universal Script Hub",
		LoadingTitle = "Vade",
		LoadingSubtitle = "by skyler_wrld",
		Theme = "Default",
		DisableRayfieldPrompts = false,
		DisableBuildWarnings = false, 
		KeySystem = false,

		Discord = {
			Enabled = true,
			Invite = "Dm2B5QNgyX",
			RememberJoins = false 
		}
	})

	local DarkDexTab = Window:CreateTab("Dark Dex")
	local SaveGameTab = Window:CreateTab("Save Game")
	local MainTab = Window:CreateTab("Remote Spies")
	local AimBotTab = Window:CreateTab("Aim Bot")

	local HydroxideButton = MainTab:CreateButton({
		Name = "Hydroxide",

		Callback = function()
			if Loaded.Hydroxide == false then
				Module.WebImport("init")
			    Module.WebImport("ui/main")
				Loaded.Hydroxide = true
			end
		end,
	})

	local DarkDexButton = DarkDexTab:CreateButton({
		Name = "Dark Dex",

		Callback = function()
			if Loaded.DarkDex == false then
				loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
				Loaded.DarkDex = true
			end
		end,
	})

	local AimBotButton = AimBotTab:CreateButton({
		Name = "Universal Aim Bot",

		Callback = function()
			if Loaded.AimBot == false then
				loadstring(game:HttpGet("https://raw.githubusercontent.com/ttwizz/Open-Aimbot/master/source.lua", true))()
				Loaded.DarkDex = true
			end
		end,
	})

	local SaveGameOptions = SaveGameTab:CreateDropdown({
		Name = "Save Game Settings",
        Options = {"NoScripts", "AntiIdle", "ShutdownWhenDone"},
        CurrentOption = {"AntiIdle"},
        MultipleOptions = true,

        Callback = function(OptionsSelected)
			SaveGameSettings = OptionsSelected
			SaveVade.UpdateConfig("SaveGameSettings", OptionsSelected)
		end,
	})

	local SaveGameButton = SaveGameTab:CreateButton({
		Name = "Start Download",

		Callback = function()
			local Params = {RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/", SSI = "saveinstance"}
			local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
			local Options = SaveGameSettings
			
			synsaveinstance(Options)
		end,
	})
end

return Module