local PAD = require("ui.structure.padding")
local DET_LEVEL = require("ui.details.level")
local DET_OBJ = require("ui.details.object")

local UI = Class(require("ui.structure.proxy"))

function UI:initialize()
	--ui state
	self.viewer = require("ui.worldEditor"):new(nil,self)
	self.detailsUI = require("ui.structure.tabs"):new()
	self:addTab(DET_LEVEL:new())
	self.detailsUI.tabHeight = settings.dim.editor.details.tabHeight
	
	--editor state
	self.selectedObject = nil
	self.selectionDetails = nil
	
	UI.super.initialize(self,require("ui.structure.horDivide"):new(self.detailsUI, self.viewer))
	self.title = "Level Editor"
end

function UI:addTab(tab)
	tab.editor = self
	tab = PAD:new(tab, settings.dim.editor.details.inset)
	self.detailsUI:addChild(tab)
	self.detailsUI:setActive(tab)
end

function UI:removeTab(tab)
	for child in self.detailsUI.children:iterate() do
		if child.child==tab then
			self.detailsUI:removeChild(child)
			break
		end
	end
end

function UI:reload()
	for v in self.detailsUI.children:iterate() do
		if v.reload then v:reload() end
	end
end

-- editor stuff

function UI:selectObject(tileX,tileY)
	if self.selectedObject then
		self:deselect()
	end
	local obj = level.foreground:get(tileX,tileY)
	if obj then
		self.selectedObject = obj
		self.selectionDetails = DET_OBJ:new(obj)
		self:addTab(self.selectionDetails)
	end
end

function UI:deselect()
	self.selectedObject = nil
	self:removeTab(self.selectionDetails)
	self.selectionDetails = nil
end

function UI:delete(obj)
	level:removeObject(obj)
	if obj == self.selectedObject then
		self:deselect()
	end
end

-- events (most are handled by the proxy super)

function UI:focus(focus)
	if focus then self:reload() end
	self.child:focus(focus)
end

function UI:inputActivated(name,group, isCursorBound)
	if name=="reload" and group=="misc" then
		require("utils.levelUtils").reload()
		self:reload()
	elseif group=="editor" then
		if name=="save" then
			require("utils.levelUtils").save()
		elseif name=="delete" then
			if self.selectedObject then
				self:delete(self.selectedObject)
			end
		end
	else
		self.child:inputActivated(name,group, isCursorBound)
	end
end


return UI
