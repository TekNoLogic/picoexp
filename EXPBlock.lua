

------------------------------
--      Are you local?      --
------------------------------

local start, max, starttime, startlevel


-------------------------------------------
--      Namespace and all that shit      --
-------------------------------------------

EXPBlock = DongleStub("Dongle-1.0"):New("EXPBlock")
local lego = DongleStub("LegoBlock-Beta0"):New("EXPBlock", "99%", "Interface\\Addons\\EXPBlock\\icon")


---------------------------
--      Init/Enable      --
---------------------------

function EXPBlock:Initialize()
	local blockdefaults = {
		locked = false,
		showIcon = false,
		showText = true,
		shown = true,
		noresize = true,
		width = 46,
	}

	self.db = self:InitializeDB("EXPBlockDB", {profile = {block = blockdefaults}}, "global")
end


function EXPBlock:Enable()
	lego:SetDB(self.db.profile.block)

	start, max, starttime = UnitXP("player"), UnitXPMax("player"), GetTime()
	startlevel = UnitLevel("player") + start/max

	self:RegisterEvent("PLAYER_XP_UPDATE")
	self:RegisterEvent("PLAYER_LEVEL_UP")

	self:PLAYER_XP_UPDATE()
end


------------------------------
--      Event Handlers      --
------------------------------

function EXPBlock:PLAYER_XP_UPDATE()
	lego:SetText(string.format("%d%%", UnitXP("player")/UnitXPMax("player")*100))
end


function EXPBlock:PLAYER_LEVEL_UP()
	start = start - max
	max = UnitXPMax("player")
end


------------------------
--      Tooltip!      --
------------------------

local function GetTipAnchor(frame)
	local x,y = frame:GetCenter()
	if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
	local hhalf = (x > UIParent:GetWidth()/2) and "RIGHT" or "LEFT"
	local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
	return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
end


lego:SetScript("OnLeave", function() GameTooltip:Hide() end)
lego:SetScript("OnEnter", function(self)
 	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint(GetTipAnchor(self))
	GameTooltip:ClearLines()

	GameTooltip:AddLine("EXPBlock")

	local cur = UnitXP("player")

	GameTooltip:AddDoubleLine("EXP:", cur.."/"..max, nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine("Rest:", string.format("%d%%", (GetXPExhaustion() or 0)/max*100), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine("TNL:", max-cur, nil,nil,nil, 1,1,1)
	GameTooltip:AddLine(string.format("%.1f hours played this session", (GetTime()-starttime)/3600), 1,1,1)
	GameTooltip:AddLine((cur - start).." EXP gained this session", 1,1,1)
	GameTooltip:AddLine(string.format("%.1f levels gained this session", UnitLevel("player") + cur/max - startlevel), 1,1,1)

	GameTooltip:Show()
end)

