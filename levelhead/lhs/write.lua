local P = require("levelhead.data.properties")

local LHS = {}

--misc

function LHS:write(data)
	if type(data)=="number" then
		data = math.numberToBytesLE(data)
	end
	self.saveHandle:write(data)
end

function LHS:write2(data)
	data = math.numberToBytesLE(data)
	if data:len()==1 then
		self.saveHandle:write(data)
		self.saveHandle:write(string.char(0x00))
	elseif data:len()>2 then
		error("Write size error: "..love.data.encode("string","hex",data))
	else
		self.saveHandle:write(data)
	end
end

local function deHex(d)
	return love.data.decode("string","hex",d)
end

--writing

function LHS:writeHeaders()
	local h = self.rawHeaders
	
	self:write(h.prefix)
	self:write(h.campaignMarker)
	
	--settings list
	self:write(h.settingsList.amount)
	for _,entry in ipairs(h.settingsList.entries) do
		self:write(entry.id)
		self:write(entry.value)
	end
	
	--title
	for i=1,#h.title,1 do
		self:write(h.title[i])
		if i ~= #h.title then
			self:write("|")
		end
	end
	self:write(0x00)
	
	--zone and size
	self:write(h.zone)
	self:write(h.width)
	self:write(h.height)
	
	--DividerConstant (unknown), it's always this
	self:write(deHex("0000803F"))
end

function LHS:writeSingle(section,id)
	local c = self.rawContentEntries[section]
	self:write(id)
	self:write2(c.nEntries)
	for _,v in ipairs(c.entries) do
		self:write2(v.id)
		self:write2(v.amount)
		for _,o in ipairs(v.subentries) do
			self:write(o.x)
			self:write(o.y)
		end
	end
end

function LHS:writeStructure(section,id)
	local c =self.rawContentEntries[section]
	self:write(id)
	self:write2(c.nEntries)
	for _,v in ipairs(c.entries) do
		self:write(v.x)
		self:write(v.y)
		self:write2(v.id)
		self:write(v.length)
	end
end

function LHS:writeProperties(isPath)
	local c
	if isPath then
		c = self.rawContentEntries.pathProperties
	else
		c = self.rawContentEntries.objectProperties
		self:write(0x63)
	end
	self:write(c.nEntries)
	for _,entry in ipairs(c.entries) do
		self:write(entry.id)
		self:write2(entry.amount)
		for _,subentry in ipairs(entry.entries) do
			local format = P:getSaveFormat(entry.id)
			if format=="A" then
				self:write(subentry.value)
			elseif format=="B" then
				local v = subentry.value
				if v < 0 then
					--read: v = vfile - 65536
					--     vfile = v +65536
					v = v + 65536
				end
				self:write2(v)
			elseif format=="C" then
				local v = subentry.value
				-- single precision floating point:
				-- conversion based on my understanding of the format and my read code,
				-- because the wikipedia method is vague and complicated
				
				-- calculate parts
				local sign = math.sign(v)
				v = v * sign -- make sure v is positive
				sign = sign==-1 and 0x80000000 or 0
				local exponent = math.floor(math.log(v)/math.log(2))
				v = v / 2^exponent
				exponent = bit.band(exponent + 127, 0xFF)
				exponent = bit.lshift(exponent,23) -- move it to the right position
				local fraction = math.round(v * 2^23)
				fraction = bit.band(fraction, 0x7FFFFF)
				--combine everything
				v = bit.bor(sign, exponent, fraction)
				--make sure it's 4 bytes long
				data = math.numberToBytesLE(v)
				if data:len() > 4 then
					error("Float write size error: "..love.data.encode("string","hex",data))
				end
				while data:len()~=4 do
					data = data .. string.char(0x00)
				end
				self:write(data)
			elseif format=="D" then
				local v = subentry.value
				if v < 0 then
					--read: v = vfile - 256
					--     vfile = v + 256
					v = v + 256
				end
				self:write(v)
			else
				error("Invalid save format: "..entry.id..": "..format)
			end
			self:write2(subentry.amount)
			for _, subsubentry in ipairs(subentry.entries) do
				if isPath then
					self:write2(subsubentry)
				else
					self:write(subsubentry.x)
					self:write(subsubentry.y)
				end
			end
		end
	end
end

function LHS:writeHash()
	self:write(0x61)
	--get current file contents
	self.saveHandle:seek("set",0)
	local contents = self.saveHandle:read("*all")
	-- the cursor should be at the end again
	self:write(self.hash(contents))
	self:write(0)
end


function LHS.hash(input)
	local step = love.data.encode("string","base64",input) .. "598175".."0"
	step = love.data.encode("string","hex",love.data.hash("md5",step))
	step = step .. "AbunchoDANGNONSENSE9plusabigpileofhashsalsytiesooooooo901587"
	return love.data.encode("string","hex",love.data.hash("md5",step))
end


function LHS:writeAll()
	local file, err = io.open(self.path,"wb+")
	if err then error(err) end
	self.saveHandle = file
	
	self:writeHeaders()
	
	self:writeSingle("singleForeground",0x0D)
	self:writeStructure("foregroundRows",0x13)
	self:writeStructure("foregroundColumns",0x0B)
	self:writeProperties(false)
	self:writeProperties(true)
	--RPS
	self:write(0x43)
	self:write2(0x00)
	--Contained Objects
	self:writeSingle("containedObjects",0x3A)
	
	self:writeSingle("paths",0x15)
	self:writeSingle("singleBackground",0x19)
	self:writeStructure("backgroundRows",0x1B)
	self:writeStructure("backgroundColumns",0x0D)
	self:writeHash()
	
	self.saveHandle:close()
	self.saveHandle = nil
end

return LHS
