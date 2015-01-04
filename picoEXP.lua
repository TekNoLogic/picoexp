

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


local function ResetStats()
	start, max, starttime = UnitXP("player"), UnitXPMax("player"), GetTime()
	cur = start
	startlevel = UnitLevel("player") + start/max
end


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


dataobj.OnClick = ResetStats
function dataobj.OnLeave() GameTooltip:Hide() end
function dataobj.OnEnter(self)
 	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint(GetTipAnchor(self))
	GameTooltip:ClearLines()

	GameTooltip:AddLine("picoEXP")

	if IsXPUserDisabled() then
		GameTooltip:AddLine("Experience gain is currently disabled", 1,0.125,0.125)
	end

	local hours = (GetTime()-starttime)/3600
	local gain = cur - start
	local rate = gain / hours
	local tnl = max - cur
	local hourstnl = tnl / rate

	local expstr = string.format("%.1fk/%.1fk", cur/1000, max/1000)
	local reststr = string.format("%d%%", (GetXPExhaustion() or 0)/max*100)
	local ratestr = string.format("%.1fk EXP per hour", rate/1000)

	local tnlstr
	if hourstnl <= 1.5 then
		tnlstr = string.format("%.01fk (%d minutes)", tnl/1000, hourstnl*60)
	else
		tnlstr = string.format("%.01fk (%.02f hours)", tnl/1000, hourstnl)
	end

	GameTooltip:AddDoubleLine(L["EXP:"], expstr, nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["Rest:"], reststr, nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["TNL:"], tnlstr, nil,nil,nil, 1,1,1)
	GameTooltip:AddLine(string.format(L["%.2f hours played this session"], hours), 1,1,1)
	GameTooltip:AddLine(gain ..L[" EXP gained this session"], 1,1,1)
	GameTooltip:AddLine(string.format(L["%.2f levels gained this session"], UnitLevel("player") + cur/max - startlevel), 1,1,1)
	GameTooltip:AddLine(ratestr, 1,1,1)

	GameTooltip:Show()
end
