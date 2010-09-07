
local myname, ns = ...

Local l = GetLocale()
ns.L = setmetatable(l == "koKR" and {
	["EXP:"] = "경험치:",
	["Rest:"] = "휴식:",
	["TNL:"] = "다음 레벨까지: ",
	["%.2f hours played this session"] = "%.2f 시간을 이 세션 동안 플레이 중",
	[" EXP gained this session"] = " 경험치를 이 세션 동안 획득",
	["%.2f levels gained this session"] = "%.2f 레벨을 이 세션 동안 획득",
} or {}, {__index=function(t,i) return i end})
