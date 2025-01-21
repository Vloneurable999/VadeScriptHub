local Module = {}

--// Variables \\--

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local KeyValidation = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vloneurable999/VadeScriptHub/refs/heads/main/Systems/KeyValidation.lua"))()
local MainWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vloneurable999/VadeScriptHub/refs/heads/main/Windows/MainWindow.lua"))()

--// Main \\--

function Module.CreateKeyWindow()
	local Window = Rayfield:CreateWindow({
		Name = "Vade Key",
		LoadingTitle = "Vade",
		LoadingSubtitle = "by skyler_wrld",
		Theme = "Default",
		DisableRayfieldPrompts = false,
		DisableBuildWarnings = false, 
		KeySystem = false
	})

	local KeyTab = Window:CreateTab("Key")
	
	KeyTab:CreateInput({
		Name = "Key Input",
		CurrentValue = "",
		PlaceholderText = "Enter Your Key",
		RemoveTextAfterFocusLost = false,
		Flag = "VadeKey",
		
		Callback = function(Text)
			local Verify = KeyValidation.VerifyKey(Text)
			
			if Verify then
				Rayfield:Destroy()
				task.wait(0.5)
				MainWindow.CreateMainWindow()
			end 
		end,
	})

	KeyTab:CreateButton({
		Name = "Get Key",
		
		Callback = function()
			KeyValidation.CopyLink()
		end,
	})
end

return Module