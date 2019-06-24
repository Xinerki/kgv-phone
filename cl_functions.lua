
function chatMessage(msg)
	TriggerEvent('chatMessage', '', {0, 0, 0}, msg)
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
		handle = N_0x953563ce563143af(GetPlayerFromName(sender))
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
	AddTextComponentSubstringPlayerName(messageTopic)
	EndTextComponent()
	
	BeginTextComponent("STRING")
	AddTextComponentSubstringPlayerName(email)
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

