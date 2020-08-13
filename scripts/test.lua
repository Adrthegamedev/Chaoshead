local O = require("levelhead.objects.base")
local P = require("levelhead.objects.propertiesBase")

--cross
for i=11,15,1 do
	level:placeEnvironment(i,i)
	level:placeEnvironment(26-i,i)
end

--relays
for i=1,level.width,1 do
	local o = P:new("Relay")
	o:setSendingChannel(i)
	o:setReceivingChannel(i-1)
	o:setSwitchRequirements("Any Active")
	level:addObject(o, i,1)
end
