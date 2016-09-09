--[[
		Filename: StatsButton.lua
		Written by: dbanks
		Description: Button that displays latest deets of one or two 
    particular stats.
--]]

--[[ Services ]]--
local CoreGuiService = game:GetService('CoreGui')

--[[ Modules ]]--
local StatsUtils = require(CoreGuiService.RobloxGui.Modules.Stats.StatsUtils)
local StatsTextPanelClass = require(CoreGuiService.RobloxGui.Modules.Stats.StatsTextPanel)
local StatsAnnotatedGraphClass = require(CoreGuiService.RobloxGui.Modules.Stats.StatsAnnotatedGraph)

--[[ Globals ]]--
local TextPanelXFraction = 0.5
local GraphXFraction = 1 - TextPanelXFraction

local TextPanelPosition = UDim2.new(0, 0, 0, 0)
local TextPanelSize = UDim2.new(TextPanelXFraction, 0, 1, 0)
local GraphPosition = UDim2.new(TextPanelXFraction, 0, 0, 0)
local GraphSize = UDim2.new(GraphXFraction, 0, 1, 0)

--[[ Classes ]]--
local StatsButtonClass = {}
StatsButtonClass.__index = StatsButtonClass

function StatsButtonClass.new(statsDisplayType) 
  local self = {}
  setmetatable(self, StatsButtonClass)

  self._type = statsDisplayType
  self._button = Instance.new("TextButton")
  self._button.Name = "PS_Button"
  self._button.Text = ""
  
  StatsUtils.StyleButton(self._button)

  self._textPanel = StatsTextPanelClass.new(statsDisplayType, false)
  self._textPanel:PlaceInParent(self._button,
    TextPanelSize, 
    TextPanelPosition)
    
  self._graph = StatsAnnotatedGraphClass.new(statsDisplayType, false)
  self._graph:PlaceInParent(self._button, 
    GraphSize, 
    GraphPosition)
  
  self._isSelected = false
  
  self:_updateColor();
  
  return self
end

function StatsButtonClass:SetToggleCallbackFunction(callbackFunction) 
    self._button.MouseButton1Click:connect(function() 
          callbackFunction(self._type)
        end)
end

function StatsButtonClass:SetSizeAndPosition(size, position)
  self._button.Size = size;
  self._button.Position = position;
end

function StatsButtonClass:SetIsSelected(isSelected)
  self._isSelected = isSelected
  self:_updateColor();
end

function StatsButtonClass:_updateColor()
  StatsUtils.StyleButtonSelected(self._button, self._isSelected)  
end

function StatsButtonClass:SetParent(parent)
  self._button.Parent = parent
end
  
function StatsButtonClass:SetStatsAggregator(aggregator) 
  self._textPanel:SetStatsAggregator(aggregator)
  self._graph:SetStatsAggregator(aggregator)
end
  
return StatsButtonClass