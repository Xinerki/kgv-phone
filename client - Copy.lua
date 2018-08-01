
function DisplayHelpText(helpText)
	SetTextComponentFormat("CELL_EMAIL_BCON")
	AddTextComponentString(helpText)
	DisplayHelpTextFromStringLabel(0,0,1,-1)
end

local function chatMessage(msg)
	TriggerEvent('chatMessage', '', {0, 0, 0}, msg)
end

phone = false
phoneId = 0

phones = {
[0] = "Michael's",
[1] = "Trevor's",
[2] = "Franklin's",
[4] = "Prologue"
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

function SetContactRaw(scaleform, index, name, iconName, hasMissedCall)
	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(2)

	PushScaleformMovieFunctionParameterInt(0) -- Index

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

function ChangePhone(flag)
	if flag == 0 or flag == 1 or flag == 2 or flag == 4 then
		phoneId = flag
		chatMessage("^2Changed phone to "..phones[flag].." phone")
	end
end

local function Floatify(Int)
  return Int + .0
end

local function Phone(X,Y,P,Yaw,R,Z,S)
    SetMobilePhonePosition(Floatify(X or 0),Floatify(Y or 5),Floatify(Z or -60))
    SetMobilePhoneRotation(Floatify(P or -90),Floatify(Yaw or 0),Floatify(R or 0)) -- 75<X<75
    SetMobilePhoneScale(Floatify(S or 250))
end

frontCam = false

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

TakePhoto = N_0xa67c35c56eb1bd9d
WasPhotoTaken = N_0x0d6ca79eeebd8ca3
SavePhoto = N_0x3dec726c25a11bac
ClearPhoto = N_0xd801cc02177fa3f1

function math.round(num)
	local frac = num - math.floor(num)
	if frac >= 0.5 then
		return math.ceil(num)
	elseif frac < 0.5 then
		return math.floor(num)
	end
end



		-- local _a = PopScaleformMovieFunctionVoid()
		-- Citizen.Trace(tostring(_a)..'\n')
		
function NavigateMenu(scaleform, inputControl)
		PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
		PushScaleformMovieFunctionParameterInt(inputControl)
		PopScaleformMovieFunctionVoid()
		PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Michael", 1)
end

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

currentColumn = 0
currentRow = 0
currentIndex = 0
currentApp = 1

function OpenApp(app)
	currentApp = app
	if app == 2 then
		PushScaleformMovieFunction(Global_14424, "DISPLAY_VIEW")
		PushScaleformMovieFunctionParameterInt(2) -- MENU PAGE
		PushScaleformMovieFunctionParameterInt(0) -- INDEX
		PopScaleformMovieFunctionVoid()
		Citizen.CreateThread(function()
			while true do
			Wait(0)
				if IsControlJustReleased(3, 177) then
					PushScaleformMovieFunction(Global_14424, "DISPLAY_VIEW")
					PushScaleformMovieFunctionParameterInt(1) -- MENU PAGE
					PushScaleformMovieFunctionParameterInt(0) -- INDEX
					PopScaleformMovieFunctionVoid()
					return
				end
			end
		end)
	end
end
		
function HandleInput(scaleform)
	if (IsControlJustPressed(3, 172)) then -- UP
		NavigateMenu(scaleform, 1)
		MoveFinger(1)
		currentRow = currentRow - 1
	end

	if (IsControlJustPressed(3, 173)) then -- DOWN
		NavigateMenu(scaleform, 3)
		MoveFinger(2)
		currentRow = currentRow + 1
	end

	if (IsControlJustPressed(3, 174)) then -- LEFT
		NavigateMenu(scaleform, 4)
		MoveFinger(3)
		currentColumn = currentColumn - 1
	end

	if (IsControlJustPressed(3, 175)) then -- RIGHT
		NavigateMenu(scaleform, 2)
		MoveFinger(4)
		currentColumn = currentColumn + 1
	end
	
	currentColumn = currentColumn % 3
	currentRow = currentRow % 3
	currentIndex = getCurrentIndex(currentColumn+1, currentRow+1)

	if (IsControlJustPressed(3, 176)) then -- SELECT
		MoveFinger(5)
		PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael", 1)
		OpenApp(currentIndex)
	end
	
	if IsControlJustReleased(3, 177) and phone == true then -- CANCEL / CLOSE PHONE
		if currentApp == 1 then
			PlaySoundFrontend(-1, "Put_Away", "Phone_SoundSet_Michael", 1)
			DestroyMobilePhone()
			phone = false
		end
	end
end

function initPhone()
DestroyMobilePhone()
Phone(55,-27)
Citizen.CreateThread(function()
	Global_14424 = RequestScaleformMovie("cellphone_ifruit")
	while not HasScaleformMovieLoaded(Global_14424) do
		Citizen.Wait(0)
	end
	
	-- SetHomeMenuApp(Global_14424, 0, 56, "Benny's shit", 10)
	-- SetHomeMenuApp(Global_14424, 1, 1, "Cameroon")
	-- SetHomeMenuApp(Global_14424, 2, 14, "Multiplier")
	-- SetHomeMenuApp(Global_14424, 3, 35, "BAWSAQ")
	-- SetHomeMenuApp(Global_14424, 4, 24, "GPS")
	-- SetHomeMenuApp(Global_14424, 5, 11, "New contact")
	-- SetHomeMenuApp(Global_14424, 6, 4, "Music")
	-- SetHomeMenuApp(Global_14424, 7, 49, "Party")
	-- SetHomeMenuApp(Global_14424, 8, 39, "Profile")
	
	SetHomeMenuApp(Global_14424, 0, 2, "Texts", 2)
	SetHomeMenuApp(Global_14424, 1, 5, "Contacts", 1)
	SetHomeMenuApp(Global_14424, 2, 12, "To-Do List")
	SetHomeMenuApp(Global_14424, 3, 14, "Player List")
	SetHomeMenuApp(Global_14424, 4, 6, "Eyefind")
	SetHomeMenuApp(Global_14424, 5, 8, "Unknown App")
	SetHomeMenuApp(Global_14424, 6, 24, "Settings")
	SetHomeMenuApp(Global_14424, 7, 1, "Snapmatic")
	SetHomeMenuApp(Global_14424, 8, 57, "SecuroServ")
	
	SetContactRaw(Global_14424, 0, "Xin Voliteer", "CHAR_DEFAULT")
	
	local wallpaper = 'Phone_Wallpaper_orange8bit'
	
	RequestStreamedTextureDict(wallpaper)
	
	PushScaleformMovieFunction(Global_14424, "SET_THEME")
	PushScaleformMovieFunctionParameterInt(5) -- 1-8
	PopScaleformMovieFunctionVoid()
	
	PushScaleformMovieFunction(Global_14424, "SET_HEADER")
	BeginTextComponent("STRING")
	AddTextComponentSubstringPlayerName("ass")
	EndTextComponent()
	PopScaleformMovieFunctionVoid()
	while true do
	
		PushScaleformMovieFunction(Global_14424, "SET_TITLEBAR_TIME")
		PushScaleformMovieFunctionParameterInt(GetClockHours()) -- HOURS
		PushScaleformMovieFunctionParameterInt(GetClockMinutes()) -- MINUTES
		PushScaleformMovieFunctionParameterInt(GetClockDayOfWeek()) -- DAYS
		PopScaleformMovieFunctionVoid()
	
		PushScaleformMovieFunction(Global_14424, "SET_BACKGROUND_CREW_IMAGE")
		BeginTextComponent("STRING")
		AddTextComponentSubstringPlayerName(wallpaper)
		EndTextComponent()
		PopScaleformMovieFunctionVoid()
	
		PushScaleformMovieFunction(Global_14424, "SET_SOFT_KEYS")
		PushScaleformMovieFunctionParameterInt(Global_14424, 2)
		PushScaleformMovieFunctionParameterBool(Global_14424, true)
		PushScaleformMovieFunctionParameterInt(Global_14424, 19)
		PopScaleformMovieFunctionVoid()
		
		if phone == true then HandleInput(Global_14424) end
		
		Citizen.Wait(0)
		
		if IsControlJustReleased(1, 27) and phone == false then -- OPEN PHONE

			currentColumn = 0
			currentRow = 0
			currentIndex = 0
	
			PushScaleformMovieFunction(Global_14424, "DISPLAY_VIEW")
			PushScaleformMovieFunctionParameterInt(1) -- MENU PAGE
			PushScaleformMovieFunctionParameterInt(0) -- INDEX
			PopScaleformMovieFunctionVoid()
			
			PlaySoundFrontend(-1, "Pull_Out", "Phone_SoundSet_Michael", 1)
			
			CreateMobilePhone(phoneId)
			SetPedConfigFlag(PlayerPedId(), 242, not true)
			SetPedConfigFlag(PlayerPedId(), 243, not true)
			SetPedConfigFlag(PlayerPedId(), 244, true)
			N_0x83a169eabcdb10a2(PlayerPedId(), 1)
			phone = true
		end
		

		
			-- CellCamActivate(true, true)
			-- CellFrontCamActivate(true)
		
			if GetFollowPedCamViewMode() == 4 then 
				SetMobilePhoneScale(Floatify(0)) 
			else
				SetMobilePhoneScale(Floatify(300)) 
			end
			
		
			local ren = GetMobilePhoneRenderId()
			SetTextRenderId(ren)
			
			DrawRect(0.0, 0.0, 2.0, 2.0, 255, 255, 255, 25)
			
			-- for i=0,10 do
				-- if math.power2(i) == 1 then
					-- r,g,b=toRGB(spin, 0.75, 0.5)
				-- else
					-- r,g,b=toRGB(spin2, 0.75, 0.5)
					-- r,g,b=toRGB(spin, 0.75, 0.25)
				-- end
				-- local num=i/10
				-- DrawRect(0.0, num+0.0, 2.0, 0.07, r,g,b, 250)
			-- end
			
			-- SetDrawOrigin(0.0, 0.0)
			
			-- SetTextFont( 0 )
			-- SetTextProportional( 0 )
			-- SetTextScale( 2.5, 2.5 )
			-- SetTextColour( 255, 255, 255, 255 )
			-- SetTextDropShadow( 0, 0, 0, 0, 255 )
			-- SetTextEdge( 1, 0, 0, 0, 255 )
			-- SetTextEntry( "STRING" )
			-- AddTextComponentString( tostring(currentIndex) )
			-- DrawText( 0.0, 0.0 )
			
		if phone == true then -- RENDER PHONE (actually now it renders at all time but shh)
			-- HideHudComponentThisFrame(7)
			-- HideHudComponentThisFrame(8)
			-- HideHudComponentThisFrame(9)
			-- HideHudComponentThisFrame(6)
			-- HideHudComponentThisFrame(19)
			-- HideHudAndRadarThisFrame()
		end
			
			-- DrawPlayerList()
			
			-- DrawScaleformMovieFullscreen(Global_14424, 255, 255, 255, 255, 0)
			-- DrawScaleformMovie(Global_14424, 0.0, 0.0, 100.0, 100.0, 255, 255, 255, 255, 0)
			DrawScaleformMovie(Global_14424, 0.1, 0.18, 0.2, 0.35, 255, 255, 255, 255, 0)
			
			-- r,g,b=toRGB(spin, 0.75, 0.5)
			-- DrawRect(0.0, 0.0, 2.0, 0.075, r,g,b, 120)
			
			-- r,g,b=toRGB(spin2, 0.75, 0.5)
			-- DrawRect(0.0, 0.5, 2.0, 0.225, r,g,b, 255)
			
			-- r,g,b=toRGB(spin2, 1.0, 0.5)
			-- DrawRect(0.0, 0.0, 2.0, 2.0, r, g, b, 50)
			
			-- ClearDrawOrigin()
			SetTextRenderId(GetDefaultScriptRendertargetRenderId())
	end
end)
end

initPhone()