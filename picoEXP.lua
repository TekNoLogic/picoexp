

------------------------------
--      Are you local?      --
------------------------------

local myname, ns = ...
local start, cur, max, starttime, startlevel
local L = ns.L


-------------------------------------------
--      Namespace and all that shit      --
-------------------------------------------

local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = LDB:NewDataObject("picoEXP", {
	type = "data source",
	text = "99%",
	icon = "Interface\\AddOns\\picoEXP\\icon",
})


----------------------
--      Enable      --
----------------------


function ns.OnLogin()
	start, max, starttime = UnitXP("player"), UnitXPMax("player"), GetTime()
	cur = start
	startlevel = UnitLevel("player") + start/max

	ns.RegisterEvent("PLAYER_XP_UPDATE")
	ns.RegisterEvent("PLAYER_LEVEL_UP")
	ns.RegisterEvent("DISABLE_XP_GAIN", ns.PLAYER_XP_UPDATE)
	ns.RegisterEvent("ENABLE_XP_GAIN", ns.PLAYER_XP_UPDATE)

	ns.PLAYER_XP_UPDATE()
end


------------------------------
--      Event Handlers      --
------------------------------

function ns.PLAYER_XP_UPDATE()
	if IsXPUserDisabled() then
		dataobj.text = "(×_×)"
	else
		cur = UnitXP("player")
		max = UnitXPMax("player")
		dataobj.text = string.format("%d%%", cur/max*100)
	end
end


function ns.PLAYER_LEVEL_UP()
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

	GameTooltip:AddDoubleLine(L["EXP:"], cur.."/"..max, nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["Rest:"], string.format("%d%%", (GetXPExhaustion() or 0)/max*100), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["TNL:"], max-cur, nil,nil,nil, 1,1,1)
	GameTooltip:AddLine(string.format(L["%.2f hours played this session"], (GetTime()-starttime)/3600), 1,1,1)
	GameTooltip:AddLine((cur - start)..L[" EXP gained this session"], 1,1,1)
	GameTooltip:AddLine(string.format(L["%.2f levels gained this session"], UnitLevel("player") + cur/max - startlevel), 1,1,1)

	GameTooltip:Show()
end
