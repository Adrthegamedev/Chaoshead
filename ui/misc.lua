local UI = Class("MiscTabUI",require("ui.tools.details"))

function UI:initialize()
	UI.super.initialize(self)
	self.title = "Misc."
end

function UI:onReload(list)
	
	
	-- BASIC INFORMATION
	
	list:addTextEntry("Chaoshead version "..require("utils.version").current)
	list:addTextEntry(string.format("LÖVE version %d.%d.%d %s",love.getVersion()))
	
	-- DO STUFF
	
	list:addButtonEntry("Toggle fullscreen",function()
		MainUI:toggleFullscreen()
	end)
	
	list:addButtonEntry("Exit Chaoshead",function()
		love.event.quit()
	end)
	
	-- SHOW STUFF
	
	list:addButtonEntry("Open Chaoshead data folder",function()
		local url = "file://"..love.filesystem.getSaveDirectory()
		love.system.openURL(url)
	end)
	
	list:addButtonEntry("Open Levelhead data folder",function()
		local url = "file://"..require("levelhead.misc").getDataPath()
		love.system.openURL(url)
	end)
	
	list:addButtonEntry("Show keybinds",function()
		local function parseName(name)
			return name:gsub("[A-Z]",function(s)
				return " "..s
			end):gsub("^.",string.upper)
		end
		
		local function parseBind(bind)
			if type(bind)=="string" then
				local m = bind:match("mouse: ?(.)")
				if m then
					return m:upper().."mouse"
				end
				local k = bind:match("key: ?(.+)")
				if k then
					return parseName(k)
				end
				return parseName(bind)
			end
			if bind.type then
				if bind.type=="not" then
					return "NOT "..bind.trigger
				else
					local out = ""
					if bind.type=="nor" or bind.type=="nand" then
						out = "NOT ("
					end
					
					local sep = ";"
					if bind.type:match("and") then
						sep = " AND "
					elseif bind.type:match("or") then
						sep = " OR "
					end
					
					local first = true
					for _,trig in ipairs(bind.triggers) do
						if not first then
							out = out..sep
						end
						if trig.type and (trig.type=="and" or trig.type=="or") then
							out = out.."("..parseBind(trig)..")"
						else
							out = out..parseBind(trig)
						end
						first = false
					end
					
					if bind.type=="nor" or bind.type=="nand" then
						out = out..")"
					end
					return out
				end
			else
				return parseBind(bind.trigger)
			end
		end

		local l = require("ui.layout.list"):new(Settings.theme.details.listStyle)
		for category, binds in pairs(Settings.bindings) do
			l:addTextEntry(parseName(category), 0)
			for name, val in pairs(binds) do
				l:addTextEntry(parseName(name)..": "..parseBind(val), 1)
			end
		end
		MainUI:displayMessage(l)
	end)
	
	
	-- DIVIDER
	list:addTextEntry("")
	
	-- CAMPAIGN
	
	list:addButtonEntry("Unpack campaign_hardfile",function()
		local i =love.filesystem.getInfo("campaign_hardfile")
		if i then
			require("levelhead.campaign.packing").unpack("campaign_test")
		else
			print("No campaign_hardfile found!")
		end
	end)
	
	list:addButtonEntry("Pack campaign_hardfile",function()
		local i =love.filesystem.getInfo("campaign_test")
		if i then
			require("levelhead.campaign.packing").pack("campaign_test")
		else
			print("No campaign_hardfile found!")
		end
	end)
	
	list:addButtonEntry("Decompress campaign (move the hardfile to the chaoshead data folder first)",function()
		local i =love.filesystem.getInfo("campaign_hardfile")
		if i then
			local c = love.filesystem.read("campaign_hardfile")
			print("Beginning decompression...")
			local d = love.data.decompress("data","zlib",c)
			print("Decompressed! Writing to disk...")
			love.filesystem.write("campaign.bin",d)
			print("Done!")
		else
			print("No campaign_hardfile found!")
		end
	end)
	
	list:addButtonEntry("Compress campaign (from campaign.bin in the chaoshead data folder)",function()
		local i = love.filesystem.getInfo("campaign.bin")
		if i then
			local c = love.filesystem.read("campaign.bin")
			print("Beginning compression...")
			local d = love.data.compress("data","zlib",c,9)
			print("Compressed! Writing to disk...")
			love.filesystem.write("campaign_hardfile",d)
			print("Done!")
		else
			print("No campaign.bin found!")
		end
	end)
	
	list:addButtonEntry("Rehash campaign.bin",function()
		local i = love.filesystem.getInfo("campaign.bin")
		if i then
			local f = love.filesystem.newFile("campaign.bin")
			f:open("r")
			local s = f:getSize()
			local h = require("levelhead.lhs").hash(f:read(s-33))
			f:close()
			f:open("a")
			f:seek(s-33)
			f:write(h)
			f:close()
			print("Overwritten",h)
		else
			print("No campaign.bin found!")
		end
	end)
	
	
	-- ALERTS/BEEPERS
	
	
	list:addButtonEntry("save_data change beeper (bring your own beep.wav in the chaoshead data folder)",function()
		local NFS = require("libs.nativefs")
		local userCodes = require("levelhead.userData").getUserCodes()
		local dataPath = require("levelhead.misc").getUserDataPath()
		local beep = love.audio.newSource("beep.wav","static")
		local lastTime = 0
		
		local B = Class(require("ui.widgets.text"))
		function B:update()
			for _,v in ipairs(userCodes) do
				local path = dataPath..v.."/save_data"
				local info = NFS.getInfo(path)
				if info then
					local time = info.modtime
					if time > lastTime then
						lastTime = time
						beep:stop()
						beep:play()
					end
					local f = NFS.newFile(path)
					local success,error = f:open("a")
					if success then
						f:close()
					else
						self.text = self.text .. "\n"..error
						if not beep:isPlaying() then
							beep:play()
						end
					end
				end
			end
		end
		local beepr = B:new("Will beep when a save_data gets modified. Alt+F4 to stop.",0,Settings.theme.modal.listStyle.textStyle)
		MainUI:setModal(beepr)
	end)
	
end

return UI
