local Module = {}

--// Variables \\--

--local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vloneurable999/MVS-Exploit/refs/heads/main/Main/Systems/Notify.lua"))()
local CachedLink = ""
local CachedTime = 0
local Service = 1202
local UseNonce = true
local Host = "https://api.platoboost.com"
local SecretCode = "b3eded5e-ccb2-4451-851b-7fb0ca80cdfb"
local RequestSending = false
local SetClipboard = setclipboard or toclipboard
local GetRequest = request or http_request
local GetHWID = gethwid or function() return game:GetService("Players").LocalPlayer.UserId end

--// Functions \\--

Module.Encode = function(Data)
	return game:GetService("HttpService"):JSONEncode(Data)
end

Module.Decode = function(Data)
	return game:GetService("HttpService"):JSONDecode(Data)
end

Module.Digest = function(Input)
	local InputString = tostring(Input)
	local Hash = {}
	local HashHex = ""

	for i = 1, #InputString do
		table.insert(Hash, string.byte(InputString, i))
	end

	for _, Byte in ipairs(Hash) do
		HashHex = HashHex .. string.format("%02x", Byte)
	end

	return HashHex
end

Module.GenerateNonce = function()
	local String = ""

	for _ = 1, 16 do
		String = String .. string.char(math.floor(math.random() * (122 - 97 + 1)) + 97)
	end

	return String
end

Module.CacheLink = function()
	if CachedTime + (10 * 60) < os.time() then
		local Response = GetRequest({
			Url = Host .. "/public/start",
			Method = "POST",

			Body = Module.Encode({
				service = Service,
				identifier = Module.Digest(GetHWID())
			}),

			Headers = {
				["Content-Type"] = "application/json"
			}
		})

		if Response.StatusCode == 200 then
			local Decoded = Module.Decode(Response.Body)

			if Decoded.success == true then
				CachedLink = Decoded.data.url
				CachedTime = os.time()
				return true, CachedLink
			else
				return false, Decoded.message
			end
		elseif Response.StatusCode == 429 then
			local Message = "you are being rate limited, please wait 20 seconds and try again."
			return false, Message
		end
	else
		return true, CachedLink
	end
end

Module.CopyLink = function()
	local Success, Link = Module.CacheLink()

	if Success then
		SetClipboard(Link)
		--Notify.Alert("Success", "Set the key url to your clipboard, paste it into your browser to get the key.", 6.5, "rewind")
	else
		--Notify.Alert("Error", "Error getting the key link. Report this in the discord server.", 6.5, "rewind")
	end
end

Module.RedeemKey = function(Key)	
	local nonce = Module.GenerateNonce()
	local Endpoint = Host .. "/public/redeem/" .. tostring(Service)

	local body = {
		identifier = Module.Digest(GetHWID()),
		key = Key
	}

	if UseNonce then
		body.nonce = nonce
	end

	local Response = GetRequest({
		Url = Endpoint,
		Method = "POST",
		Body = Module.Encode(body),
		Headers = {
			["Content-Type"] = "application/json"
		}
	})

	if Response.StatusCode == 200 then
		local Decoded = Module.Decode(Response.Body)

		if Decoded.success == true then
			if Decoded.data.valid == true then
				if UseNonce then
					if Decoded.data.hash == Module.Digest("true" .. "-" .. nonce .. "-" .. SecretCode) then
						return true
					else
						--Notify.Alert("Failed", "Failed to verify integrity.")
						return false
					end    
				else
					return true
				end
			else
				--Notify.Alert("Invalid Key", "Your key is invalid.")
				return false
			end
		else
			if string.sub(Decoded.message, 1, 27) == "unique constraint violation" then
				--Notify.Alert("Heads Up!", "You already have an active key, please wait for it to expire before redeeming it.")
				return false
			else
				--Notify.Alert("???", Decoded.message)
				return false
			end
		end
	elseif Response.StatusCode == 429 then
		--Notify.Alert("Slow Down!", "you are being rate limited, please wait 20 seconds and try again.")
		return false
	else
		--Notify.Alert("Error", "server returned an invalid status code, please try again later.")
		return false
	end
end

Module.VerifyKey = function(Key)
	local FolderName = "Vade Script Hub"

	writefile(FolderName .. "//Key.txt", tostring(Key))

	if RequestSending == true then
		--Notify.Alert("Slow Down!", "a request is already being sent, please slow down.")
		return false
	else
		RequestSending = true
	end

	local nonce = Module.GenerateNonce()
	local Endpoint = Host .. "/public/whitelist/" .. tostring(Service) .. "?identifier=" .. Module.Digest(GetHWID()) .. "&key=" .. Key

	if UseNonce then
		Endpoint = Endpoint .. "&nonce=" .. nonce
	end

	local Response = GetRequest({Url = Endpoint, Method = "GET"})

	RequestSending = false

	if Response.StatusCode == 200 then
		local Decoded = Module.Decode(Response.Body)

		if Decoded.success == true then
			if Decoded.data.valid == true then
				if UseNonce then
					return true
				else
					return true
				end
			else
				if string.sub(Key, 1, 4) == "KEY_" or string.sub(Key, 1, 4) == "FREE_" then
					return Module.RedeemKey(Key)
				else
					--Notify.Alert("Invalid Key", "Your key is invalid")
					return false
				end
			end
		else
			--Notify.Alert("???", Decoded.message)
			return false
		end
	elseif Response.StatusCode == 429 then
		--Notify.Alert("Slow Down!", "you are being rate limited, please wait 20 seconds and try again.")
		return false
	else
		--Notify.Alert("Error", "server returned an invalid status code, please try again later.")
		return false
	end
end

return Module