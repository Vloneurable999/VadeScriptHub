local Module = {}

--// Variables \\--

local KeyValidation = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vloneurable999/Vade-Script-Hub/refs/heads/main/Main/Systems/KeyValidation.lua"))()
local KeyWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vloneurable999/Vade-Script-Hub/refs/heads/main/Main/Windows/KeyWindow.lua"))()
local MainWindow = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vloneurable999/Vade-Script-Hub/refs/heads/main/Main/Windows/MainWindow.lua"))()
local FolderName = "Vade Script Hub"

--// Main \\--

function Module.LoadVade()
	if isfolder(FolderName) then
		if isfile(FolderName .. "//Key.txt") then

		else
			writefile(FolderName .. "//Key.txt", "nil")
		end
	else
		makefolder(FolderName)
		writefile(FolderName .. "//Key.txt", "nil")
	end
	
	local CurrentKey = readfile(FolderName .."//Key.txt")
	local VerifyCheck = KeyValidation.VerifyKey(CurrentKey)
	
	if CurrentKey ~= "nil" then
		if VerifyCheck == false then
			KeyWindow.CreateKeyWindow()
		else
			MainWindow.CreateMainWindow()
		end
	else
		KeyWindow.CreateKeyWindow()
	end
end

return Module