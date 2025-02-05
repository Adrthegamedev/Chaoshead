local Details = require("ui.tools.details")

local UI = Class("TableViewerUI",require("ui.tools.treeViewer"))

function UI:initialize(data,overview)
	self.data = data
	self.overview = overview
	UI.super.initialize(self)
	self.persistant = nil -- which data we display differs, no sense remembering specific entries
	self.title = "Table Viewer"
end

function UI:getRootEntries()
	local out = {
		{
			title = "Close viewer",
			action = function()
				self.overview:closeViewer(self)
			end
		}
	}
	for k,v in pairs(self.data) do
		table.insert(out,{
			title = k,
			folder = type(v)=="table",
			raw = v,
		})
	end
	return out
end

function UI:getChildren(node)
	local out = {}
	for k,v in pairs(node.raw) do
		table.insert(out,{
			title = k,
			folder = type(v)=="table",
			raw = v,
		})
	end
	return out
end

function UI:getDetailsUI(data)
	local details = Details:new(false)
	local list = details:getList()
	
	local t = type(data.raw)
	if t=="string" then
		if data.raw:len() > Settings.misc.dataExplorer.maxDisplayStringLength then
			list:addTextEntry("String: too long to display!")
		else
			list:addTextEntry("String:")
			list:addTextEntry(data.raw)
		end
	else
		list:addTextEntry(type(data.raw)..":")
		list:addTextEntry(tostring(data.raw))
	end
	
	return details
end

return UI
