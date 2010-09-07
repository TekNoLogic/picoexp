
if GetLocale() ~= "koKR" then return end
local L, _, ns = { }, ...
ns.L = L

L["EXP:"] = "경험치:"
L["Rest:"] = "휴식:"
L["TNL:"] = "다음 레벨까지: "
L["%.2f hours played this session"] = "%.2f 시간을 이 세션 동안 플레이 중"
L[" EXP gained this session"] = " 경험치를 이 세션 동안 획득"
L["%.2f levels gained this session"] = "%.2f 레벨을 이 세션 동안 획득"
