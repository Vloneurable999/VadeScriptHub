local Module = {}

--// Variables \\--

local FolderName = "Vade Script Hub"
local ConfigTable = {
    SaveGameSettings = {AntiIdle = true, NoScripts = false, ShutdownWhenDone = false}
}

--// Main \\--

function Module.EncodeConfig()
    return game:GetService("HttpService"):JSONEncode(ConfigTable)
end

function Module.DecodeConfig(Config)
    return game:GetService("HttpService"):JSONDecode(Config)
end

function Module.SaveConfig()
    if isfolder(FolderName) then
        if isfile(FolderName .. "//Config.rfld") then
        else
			writefile(FolderName .. "//Config.rfld", Module.EncodeConfig())
        end
    else
		makefolder(FolderName)
		writefile(FolderName .. "//Config.rfld", Module.EncodeConfig())
    end
end

function Module.GetConfigData()
    if isfolder(FolderName) and isfile(FolderName .. "//Config.rfld") then
        local Config = Module.DecodeConfig(readfile(FolderName .. "//Config.rfld"))
        return Config
    else
        Module.SaveConfig()
        return ConfigTable
    end
end

function Module.UpdateConfig(DataToChange, DataValue)
   local Config = Module.GetConfigData()

    if not Config[DataToChange] then
        Config[DataToChange] = DataValue
    else
        for ConfigDataName, Data in pairs(Config) do
            if ConfigDataName == DataToChange then
                Data = DataValue
            end
        end
    end

    Module.SaveConfig(Config)
end

return Module