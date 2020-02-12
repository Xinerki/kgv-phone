
-- SetContactRaw(GlobalScaleform, 0, "Xin Voliteer", "CHAR_DEFAULT")

-- local txd = CreateRuntimeTxd('CHAR_PNGTEST')
-- local duiObj = CreateDui('https://i.imgur.com/NZaICKc.png', 64, 64)
-- _G.duiObj = duiObj
-- local dui = GetDuiHandle(duiObj)
-- local tx = CreateRuntimeTextureFromDuiHandle(txd, 'CHAR_PNGTEST', dui)

-- local txd = CreateRuntimeTxd('CHAR_LINUS')
-- local duiObj = CreateDui('https://i.imgur.com/mt4F1FL.jpg', 64, 64)
-- _G.duiObj = duiObj
-- local dui = GetDuiHandle(duiObj)
-- local tx = CreateRuntimeTextureFromDuiHandle(txd, 'CHAR_LINUS', dui)

local txd = CreateRuntimeTxd('CHAR_DOMKA')
local tx = CreateRuntimeTextureFromImage(txd, 'CHAR_DOMKA', "domka.png")

contacts = {
	-- result from calling linus:
	-- he hangs up and sends a text message with a randomize "tech tip"
	-- use inspiration from:
	-- https://twitter.com/LinusTechTip_
	-- Linus = { 
		-- name = "LinusTechTip", 
		-- icon = "CHAR_LINUS",
	-- },
	Domka = { 
		name = "Domka", 
		icon = "CHAR_DOMKA",
	},
	-- Cole = {
		-- name = "Cole", 
		-- icon = "CHAR_FILMNOIR",
	-- },
	-- XinVoliteer = {
		-- name = "Xin Voliteer", 
		-- icon = "CHAR_XIN",
	-- },
	-- MattLaurence = {
		-- name = "Matthew Laurence", 
		-- icon = "CHAR_DEFAULT",
	-- },
	-- FarbodSerran = {
		-- name = "Farbod Serran", 
		-- icon = "CHAR_DEFAULT",
	-- },
	-- NotAvailable = {
		-- name = "Not_Available", 
		-- icon = "CHAR_DEFAULT",
	-- },
	-- LifeInvader = {
		-- name = "LifeInvader", 
		-- icon = "CHAR_LIFEINVADER",
	-- },
	Lester = {
		name = "Lester", 
		icon = "CHAR_LESTER",
	},
	NikoBellic = {
		name = "Niko Bellic", 
		icon = "CHAR_NIKO",
	},
	-- PNG_TEST = {
		-- name = "PNG_TEST", 
		-- icon = "CHAR_PNGTEST",
	-- },
}