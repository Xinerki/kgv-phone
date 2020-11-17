
TakePhoto = N_0xa67c35c56eb1bd9d
-- TakePhoto = N_0x759650634f07b6b4
WasPhotoTaken = N_0x0d6ca79eeebd8ca3
-- WasPhotoTaken = N_0xcb82a0bf0e3e3265
SavePhoto = N_0x3dec726c25a11bac
ClearPhoto = N_0xd801cc02177fa3f1

CellCamSetHorizontalOffset = N_0x1b0b4aeed5b9b41c -- -1.0 to 1.0 but there's actually no limit
CellCamSetVerticalOffset = N_0x3117d84efa60f77b -- 0.0 to 2.0
CellCamSetRoll = N_0x15e69e2802c24b8d -- -1.0 to 1.0
CellCamSetDistance = N_0x53f4892d18ec90a4 -- -1.0 to 1.0

CellCamSetHeadY = N_0xd6ade981781fca09 -- -1.0 to 1.0
CellCamSetHeadRoll = N_0xf1e22dc13f5eebad -- -1.0 to 1.0
CellCamSetHeadHeight = N_0x466da42c89865553 -- -1.0 to 0.0

CellCamSetDofEnabled = SetMobilePhoneUnk

function CellCamSetDofEnabled2(enable)
	Citizen.InvokeNative(0xA2CCBE62CD4C91A4, enable)
end

function math.clamp(value, minClamp, maxClamp)
	return math.min(maxClamp, math.max(value, minClamp))
end

function lerp(x1, x2, t) 
    return x1 + (x2 - x1) * t
end

-- function DrawSelectionMsg(text, duration) -- unused
	-- Citizen.CreateThread(function()
		
		-- local duration = duration or 1000
		
		-- local startTime = GetGameTimer()
		-- local endTime = GetGameTimer() + duration
		
		-- while GetGameTimer() < endTime do 
			-- Wait(0)
			
			-- local now = GetGameTimer()
			-- local scale = (endTime - now) / duration
			
			-- local yPos = lerp(0.0, 0.1, scale)
			
			-- SetTextFont(0)
			-- SetTextProportional(1)
			-- SetTextScale(0.0, 0.55)
			-- SetTextColour(255, 255, 255, math.max(0, math.floor(scale * 255)))
			-- SetTextDropshadow(0, 0, 0, 0, 255)
			-- SetTextEdge(2, 0, 0, 0, 150)
			-- SetTextDropShadow()
			-- SetTextOutline()
			-- SetTextEntry("STRING")
			-- SetTextCentre(1)
			-- AddTextComponentString(text)
			-- DrawText(0.5, yPos)
		-- end
	-- end)
-- end

-- hacky ree
function GetControlModeName(mode)
	if mode == true then
		return "Mouse"
	end
	return "Arrows"
end
function GetControlModeBool(mode)
	if mode == true then
		return 1
	end
	return false
end

function chatMessage(msg)
	TriggerEvent('chatMessage', '', {0, 0, 0}, msg)
end

function BusyspinnerOn(string)
	BeginTextCommandBusyspinnerOn("STRING")
	AddTextComponentString(string)
	EndTextCommandBusyspinnerOn(1)
end

function Notification(text,duration)
    Citizen.CreateThread(function()
        SetNotificationTextEntry("STRING")
        AddTextComponentString(text)
        local Notification = DrawNotification(false, false)
        Citizen.Wait(duration)
        RemoveNotification(Notification)
    end)
end

function DisplayHelpText(helpText, time)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringWebsite(helpText)
	EndTextCommandDisplayHelp(0, 0, 1, time or -1)
end

function GetPlayerFromName(namePart)
	for i=1,255 do
		if NetworkIsPlayerActive(i) then		
			local playerName = GetPlayerName(i)
			-- print(playerName.." "..i)
			if string.find(playerName, namePart) then return GetPlayerPed(i) end
		end
	end
end

function ReceiveMessage(sender, message)
	if not pedHeadshots[sender] then
		-- handle = N_0x953563ce563143af(GetPlayerFromName(sender))
		handle = RegisterPedheadshot(GetPlayerFromName(sender))
		if IsPedheadshotValid(handle) then
			repeat Wait(0) until IsPedheadshotReady(handle)
			txdString = GetPedheadshotTxdString(handle)
		else
			txdString = "CHAR_DEFAULT" -- something went wrong!
		end
	else
		txdString = pedHeadshots[sender]
	end
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	SetNotificationMessage(txdString, txdString, true, 2, sender, "Private Message")
	PlaySoundFrontend(-1, "Phone_Generic_Key_01", "HUD_MINIGAME_SOUNDSET", 0)
	
	AddMessage(GlobalScaleform, messageCount, sender, message, false)
	messageCount = messageCount + 1
end

RegisterNetEvent('phone:receiveMessage')
AddEventHandler('phone:receiveMessage', ReceiveMessage)

phone = false
phoneId = 0

phones = {
	[0] = "Michael's",
	[1] = "Trevor's",
	[2] = "Franklin's",
	[4] = "Prologue"
}

days = {
	[1] = "Mon",
	[2] = "Tue",
	[3] = "Wed",
	[4] = "Thu",
	[5] = "Fri",
	[6] = "Sat",
	[7] = "Sun"
}

-- filters = {
	-- "phone_cam",
	-- "phone_cam1",
	-- "phone_cam10",
	-- "phone_cam11",
	-- "phone_cam12",
	-- "phone_cam13",
	-- "phone_cam2",
	-- "phone_cam3",
	-- "phone_cam3_REMOVED",
	-- "phone_cam4",
	-- "phone_cam5",
	-- "phone_cam6",
	-- "phone_cam7",
	-- "phone_cam8",
	-- "phone_cam8_REMOVED",
	-- "phone_cam9",
-- }

filters = {
	"NG_filmic01",
	"NG_filmic02",
	"NG_filmic03",
	"NG_filmic04",
	"NG_filmic05",
	"NG_filmic06",
	"NG_filmic07",
	"NG_filmic08",
	"NG_filmic09",
	"NG_filmic10",
	"NG_filmic11",
	"NG_filmic12",
	"NG_filmic13",
	"NG_filmic14",
	"NG_filmic15",
	"NG_filmic16",
	"NG_filmic17",
	"NG_filmic18",
	"NG_filmic19",
	"NG_filmic20",
	"NG_filmic21",
	"NG_filmic22",
	"NG_filmic23",
	"NG_filmic24",
	"NG_filmic25",
}


-- TODO: maybe replace mp gestures with sp character gestures?

-- anim@mp_player_intselfie ..
gestureDicts = {
	"blow_kiss",
	"dock",
	"jazz_hands",
	"the_bird",
	"thumbs_up",
	"wank",
}

-- gestureNames = {
	-- "Blow Kiss",
	-- "Dock",
	-- "Jazz Hands",
	-- "The Bird",
	-- "Thumbs Up",
	-- "Wank",
-- }

-- sorry i want to name them better
gestureNames = {
	"Blow Kiss",
	"OK",
	"Arrested",
	"FUCK",
	"Thumbs Up",
	"Wank",
}

iFruitDefault = 	"Phone_Wallpaper_ifruitdefault"
BadgerDefault = 	"Phone_Wallpaper_badgerdefault"
Bittersweet = 		"Phone_Wallpaper_bittersweet_b"
PurpleGlow = 		"Phone_Wallpaper_purpleglow"
GreenSquares = 		"Phone_Wallpaper_greensquares"
OrangeHerringBone = "Phone_Wallpaper_orangeherringbone"
OrangeHalftone = 	"Phone_Wallpaper_orangehalftone"
GreenTriangles = 	"Phone_Wallpaper_greentriangles"
GreenShards = 		"Phone_Wallpaper_greenshards"
BlueAngles = 		"Phone_Wallpaper_blueangles"
BlueShards = 		"Phone_Wallpaper_blueshards"
BlueTriangles = 	"Phone_Wallpaper_bluetriangles"
BlueCircles = 		"Phone_Wallpaper_bluecircles"
Diamonds = 			"Phone_Wallpaper_diamonds"
GreenGlow = 		"Phone_Wallpaper_greenglow"
Orange8Bit = 		"Phone_Wallpaper_orange8bit"
OrangeTriangles = 	"Phone_Wallpaper_orangetriangles"
PurpleTartan =		"Phone_Wallpaper_purpletartan"

wallpapers = {
	"Phone_Wallpaper_ifruitdefault",
	"Phone_Wallpaper_badgerdefault",
	"Phone_Wallpaper_bittersweet",
	"Phone_Wallpaper_purpleglow",
	"Phone_Wallpaper_greensquares",
	"Phone_Wallpaper_orangeherringbone",
	"Phone_Wallpaper_orangehalftone",
	"Phone_Wallpaper_greentriangles",
	"Phone_Wallpaper_greenshards",
	"Phone_Wallpaper_blueangles",
	"Phone_Wallpaper_blueshards",
	"Phone_Wallpaper_bluetriangles",
	"Phone_Wallpaper_bluecircles",
	"Phone_Wallpaper_diamonds",
	"Phone_Wallpaper_greenglow",
	"Phone_Wallpaper_orange",
	"Phone_Wallpaper_orangetriangles",
	"Phone_Wallpaper_purpletartan",
}

wallpaperNames = {
	"iFruit",
	"Badger",
	"Bittersweet",
	"Purple Glow",
	"Green Squares",
	"Orange Herring Bone",
	"Orange Halftone",
	"Green Triangles",
	"Green Shards",
	"Blue Angles",
	"Blue Shards",
	"Blue Triangles",
	"Blue Circles",
	"Diamonds",
	"Green Glow",
	"Orange 8-Bit",
	"Orange Triangles",
	"Purple Tartan",
}

themes = {
	"Blue",
	"Green",
	"Red",
	"Orange",
	"Gray",
	"Purple",
	"Pink",
}

RegisterNetEvent('phone:phone')
AddEventHandler('phone:phone', function(message)		
	local id = tonumber(string.sub(message, 7, 8))
	
	if id == 0 or id == 1 or id == 2 or id == 4 then
		ChangePhone(id)
	else
		chatMessage("^1/phone [ID]")
		chatMessage("^10 - Michael's phone")
		chatMessage("^11 - Trevor's phone")
		chatMessage("^12 - Franklin's phone")
		chatMessage("^14 - Prologue phone")
	end
end)

function ChangePhone(flag)
	if flag == 0 or flag == 1 or flag == 2 or flag == 4 then
		phoneId = flag
		chatMessage("^2Changed phone to "..phones[flag].." phone")
	end
end

function Floatify(Int)
  return Int + .0
end

function Phone(X,Y,P,Yaw,R,Z,S)
    SetMobilePhonePosition(Floatify(X or 0),Floatify(Y or 5),Floatify(Z or -60))
    SetMobilePhoneRotation(Floatify(P or -90),Floatify(Yaw or 0),Floatify(R or 0)) -- 75<X<75
    SetMobilePhoneScale(Floatify(S or 250))
end

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

function math.round(num)
	local frac = num - math.floor(num)
	if frac >= 0.5 then
		return math.ceil(num)
	elseif frac < 0.5 then
		return math.floor(num)
	end
end
		
function NavigateMenu(scaleform, inputControl)
	PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
	PushScaleformMovieFunctionParameterInt(inputControl)
	PopScaleformMovieFunctionVoid()
	PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Michael", 1)
end

currentColumn = 0
currentRow = 0
currentIndex = 0
currentApp = 1

function getCurrentIndex(column, row)
	if 	   (row == 1 and column == 1) then
		return 1
	elseif (row == 1 and column == 2) then
		return 2
	elseif (row == 1 and column == 3) then
		return 3	
	elseif (row == 2 and column == 1) then
		return 4
	elseif (row == 2 and column == 2) then
		return 5
	elseif (row == 2 and column == 3) then
		return 6
	elseif (row == 3 and column == 1) then
		return 7
	elseif (row == 3 and column == 2) then
		return 8
	elseif (row == 3 and column == 3) then
		return 9
	end
end

-- func_9(Global_14424, "SET_DATA_SLOT", system::to_float(4), system::to_float(0), system::to_float(2), -1f, -1f, &(Global_117[Global_1628 /*10*/].f_4), "CELL_300", "CELL_217", "CELL_195", 0);

--[[ 
void func_9(int scaleformName, char* scaleformFunction, float fParam2, float fParam3, float fParam4, float fParam5, float fParam6, char* sParam7, char* sParam8, char* sParam9, char* sParam10, char* sParam11)//Position - 0xF2F
{
	graphics::_push_scaleform_movie_function(scaleformName, scaleformFunction);
	graphics::_push_scaleform_movie_function_parameter_int(system::round(fParam2));
	if (fParam3 != -1f)
	{
		graphics::_push_scaleform_movie_function_parameter_int(system::round(fParam3));
	}
	if (fParam4 != -1f)
	{
		graphics::_push_scaleform_movie_function_parameter_int(system::round(fParam4));
	}
	if (fParam5 != -1f)
	{
		graphics::_push_scaleform_movie_function_parameter_int(system::round(fParam5));
	}
	if (fParam6 != -1f)
	{
		graphics::_push_scaleform_movie_function_parameter_int(system::round(fParam6));
	}
	if (!gameplay::is_string_null_or_empty(sParam7))
	{
		func_7(sParam7);
	}
	if (!gameplay::is_string_null_or_empty(sParam8))
	{
		func_7(sParam8);
	}
	if (!gameplay::is_string_null_or_empty(sParam9))
	{
		func_7(sParam9);
	}
	if (!gameplay::is_string_null_or_empty(sParam10))
	{
		func_7(sParam10);
	}
	if (!gameplay::is_string_null_or_empty(sParam11))
	{
		func_7(sParam11);
	}
	graphics::_pop_scaleform_movie_function_void();
}
]]

function SetSoftKeys(scaleform, index, icon, r, g, b)
	PushScaleformMovieFunction(scaleform, "SET_SOFT_KEYS")
	PushScaleformMovieFunctionParameterInt(scaleform, index)
	PushScaleformMovieFunctionParameterBool(scaleform, true)
	PushScaleformMovieFunctionParameterInt(scaleform, icon)
	PopScaleformMovieFunctionVoid()
	
	-- PushScaleformMovieFunction(scaleform, "SET_SOFT_KEYS_COLOUR")
	-- PushScaleformMovieFunctionParameterInt(scaleform, index)
	-- PushScaleformMovieFunctionParameterFloat(scaleform, r)
	-- PushScaleformMovieFunctionParameterFloat(scaleform, g)
	-- PushScaleformMovieFunctionParameterFloat(scaleform, b)
	-- PopScaleformMovieFunctionVoid()
end

settings = {}

function AddSetting(scaleform, index, setting) -- page, index, unk, name, ...
	
	settings[index] = setting -- hacky counter

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(18)
	
	PushScaleformMovieFunctionParameterInt(index-1)
	
	-- PushScaleformMovieFunctionParameterInt(0)
	
	PushScaleformMovieFunctionParameterInt(0) -- UNKNOWN
	
	BeginTextComponent("STRING")
	AddTextComponentSubstringPlayerName(setting)
	EndTextComponent()
	
	-- BeginTextComponent("STRING")
	-- AddTextComponentSubstringPlayerName("~l~"..setting .. " alt")
	-- EndTextComponent()
	
	-- PushScaleformMovieFunctionParameterInt(1)
	
	PopScaleformMovieFunctionVoid()
end

function UpdateCoords(scaleform) -- TODO: Coords app
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(24)
	
	-- PushScaleformMovieFunctionParameterInt(index-1)
	
	-- PushScaleformMovieFunctionParameterInt(0)
	
	PushScaleformMovieFunctionParameterInt(0)
	
	-- BeginTextComponent("STRING")
	-- AddTextComponentSubstringPlayerName("~l~"..setting)
	-- EndTextComponent()
	
	BeginTextComponent("STRING")
	AddTextComponentSubstringPlayerName("~l~"..setting .. " alt")
	EndTextComponent()
	
	PushScaleformMovieFunctionParameterFloat(150.0)
	PushScaleformMovieFunctionParameterFloat(150.0)
	PushScaleformMovieFunctionParameterFloat(150.0)
	PushScaleformMovieFunctionParameterFloat(150.0)
	PushScaleformMovieFunctionParameterFloat(150.0)
	PushScaleformMovieFunctionParameterFloat(150.0)
	PushScaleformMovieFunctionParameterFloat(150.0)
	PushScaleformMovieFunctionParameterFloat(150.0)
	PushScaleformMovieFunctionParameterFloat(150.0)
	PushScaleformMovieFunctionParameterFloat(150.0)
	PushScaleformMovieFunctionParameterFloat(150.0)
	PushScaleformMovieFunctionParameterFloat(150.0)
	PushScaleformMovieFunctionParameterFloat(150.0)
	
	PopScaleformMovieFunctionVoid()
end

function AddMessage(scaleform, index, email, messageTopic, sending)
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(8)
	
	PushScaleformMovieFunctionParameterInt(index)
	
	if sending == false then
		PushScaleformMovieFunctionParameterInt(0)
	else
		PushScaleformMovieFunctionParameterInt(4)
	end
	
	PushScaleformMovieFunctionParameterInt(0)
	
	BeginTextComponent("STRING")
	AddTextComponentSubstringPlayerName("~l~"..messageTopic)
	EndTextComponent()
	
	BeginTextComponent("STRING")
	AddTextComponentSubstringPlayerName("~l~"..email)
	EndTextComponent()
	
	PopScaleformMovieFunctionVoid()
end

function SetContactRaw(scaleform, index, name, iconName, hasMissedCall)
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(2)

	PushScaleformMovieFunctionParameterInt(index) -- Index

	-- 0 - Missed call present
	PushScaleformMovieFunctionParameterInt(hasMissedCall or 0)

	-- 1 - Name
	BeginTextComponent("STRING")
	AddTextComponentSubstringPlayerName(name)
	EndTextComponent()

	-- 2 - Keep empty
	BeginTextComponent("CELL_999")
	EndTextComponent()

	-- 3 - Icon
	BeginTextComponent("CELL_2000")
	AddTextComponentSubstringPlayerName(iconName or "")
	EndTextComponent()
	
	PopScaleformMovieFunctionVoid()
end

function SetHomeMenuApp(scaleform, index, icon, name, notifications, opacity)
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(1)

	-- Index
	PushScaleformMovieFunctionParameterInt(index)

	-- 0 - Icon
	PushScaleformMovieFunctionParameterInt(icon)

	-- 1 - Notifications count
	PushScaleformMovieFunctionParameterInt(notifications or 0)

	-- 2 - Name
	BeginTextComponent("STRING")
	AddTextComponentSubstringPlayerName(name)
	EndTextComponent()

	-- 3 - Opacity
	PushScaleformMovieFunctionParameterInt((opacity or 0.5) * 100.0)

	PopScaleformMovieFunctionVoid()
end

