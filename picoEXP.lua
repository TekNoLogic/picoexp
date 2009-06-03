

------------------------------
--      Are you local?      --
------------------------------

local start, cur, max, starttime, startlevel


-------------------------------------------
--      Namespace and all that shit      --
-------------------------------------------

local f = CreateFrame("frame")
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("picoEXP", {type = "data source", text = "99%", icon = "Interface\\AddOns\\picoEXP\\icon"})


----------------------
--      Enable      --
----------------------


function f:PLAYER_LOGIN()
	start, max, starttime = UnitXP("player"), UnitXPMax("player"), GetTime()
	cur = start
	startlevel = UnitLevel("player") + start/max

	self:RegisterEvent("PLAYER_XP_UPDATE")
	self:RegisterEvent("PLAYER_LEVEL_UP")

	self:PLAYER_XP_UPDATE()

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end


------------------------------
--      Event Handlers      --
------------------------------

function f:PLAYER_XP_UPDATE()
	cur = UnitXP("player")
	max = UnitXPMax("player")
	dataobj.text = string.format("%d%%", cur/max*100)
end


function f:PLAYER_LEVEL_UP()
	start = start - max
end


------------------------
--      Tooltip!      --
------------------------

local function GetTipAnchor(frame)
	local x,y = frame:GetCenter()
	if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
	local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
	local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
	return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
end


function dataobj.OnLeave() GameTooltip:Hide() end
function dataobj.OnEnter(self)
 	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint(GetTipAnchor(self))
	GameTooltip:ClearLines()

	GameTooltip:AddLine("picoEXP")

	GameTooltip:AddDoubleLine("EXP:", cur.."/"..max, nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine("Rest:", string.format("%d%%", (GetXPExhaustion() or 0)/max*100), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine("TNL:", max-cur, nil,nil,nil, 1,1,1)
	GameTooltip:AddLine(string.format("%.1f hours played this session", (GetTime()-starttime)/3600), 1,1,1)
	GameTooltip:AddLine((cur - start).." EXP gained this session", 1,1,1)
	GameTooltip:AddLine(string.format("%.1f levels gained this session", UnitLevel("player") + cur/max - startlevel), 1,1,1)

	GameTooltip:Show()
end

if IsLoggedIn() then f:PLAYER_LOGIN() else f:RegisterEvent("PLAYER_LOGIN") end
