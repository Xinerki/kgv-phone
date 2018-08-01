
frontCam = false

messageCount = 0

loadedContacts = {}

function OpenApp(app)
	Citizen.CreateThread(function()
		currentApp = app
		if app == 2 then -- MESSAGES
			for i=0,3 do
				AddMessage(GlobalScaleform, i, tostring(i).."@fivem.net", "spam!")
				messageCount = messageCount + 1
			end
			PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
			-- PushScaleformMovieFunctionParameterInt(6) -- MENU PAGE
			PushScaleformMovieFunctionParameterInt(8) -- MENU PAGE
			PushScaleformMovieFunctionParameterInt(0) -- INDEX
			PopScaleformMovieFunctionVoid()
			SetMobilePhoneRotation(-90.0, 0.0, 90.0)
			SetPhoneLean(true)
			while true do
			Wait(0)
			
				if (IsControlJustPressed(3, 172)) then -- UP
					NavigateMenu(GlobalScaleform, 1)
					MoveFinger(1)
					currentRow = currentRow - 1
				end

				if (IsControlJustPressed(3, 173)) then -- DOWN
					NavigateMenu(GlobalScaleform, 3)
					MoveFinger(2)
					currentRow = currentRow + 1
				end
				
				currentRow = currentRow % messageCount
				
				if IsControlJustReleased(3, 177) then -- BACK
					PlaySoundFrontend(-1, "Menu_Back", "Phone_SoundSet_Michael", 1)
					PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
					PushScaleformMovieFunctionParameterInt(1) -- MENU PAGE
					PushScaleformMovieFunctionParameterInt(0) -- INDEX
					PopScaleformMovieFunctionVoid()
					SetPhoneLean(false)
					SetMobilePhoneRotation(-90.0, 0.0, 0.0)
					Wait(1000)
					currentColumn = 0
					currentRow = 0
					currentIndex = 1
					currentApp = 1
					return
				end
			end
		end
		
		if app == 3 then -- CONTACTS
			
			local players = 0
			for i=0,31 do
				if NetworkIsPlayerActive(i) then
					local handle = RegisterPedheadshot(GetPlayerPed(i))
					if IsPedheadshotValid(handle) then
						repeat Wait(0) until IsPedheadshotReady(handle)
					end
					local txdString = GetPedheadshotTxdString(handle)
					SetContactRaw(GlobalScaleform, i, GetPlayerName(i), txdString)
					-- contactAmount = contactAmount + 1
					players = players+1
					table.insert(loadedContacts, players, {name = GetPlayerName(i), icon = txdString})
				end
			end
			
			contactAmount = players
			for i,v in pairs(contacts) do
				SetContactRaw(GlobalScaleform, contactAmount, v.name, v.icon)
				contactAmount = contactAmount + 1
				table.insert(loadedContacts, contactAmount, {name = v.name, icon = v.icon})
			end
		
			PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
			PushScaleformMovieFunctionParameterInt(2) -- MENU PAGE
			PushScaleformMovieFunctionParameterInt(0) -- INDEX
			PopScaleformMovieFunctionVoid()
			while true do
			Wait(0)
			
				if (IsControlJustPressed(3, 172)) then -- UP
					NavigateMenu(GlobalScaleform, 1)
					MoveFinger(1)
					currentRow = currentRow - 1
				end

				if (IsControlJustPressed(3, 173)) then -- DOWN
					NavigateMenu(GlobalScaleform, 3)
					MoveFinger(2)
					currentRow = currentRow + 1
				end
				
				currentRow = currentRow % contactAmount
			
				-- SetTextFont( 0 )
				-- SetTextProportional( 0 )
				-- SetTextScale( 2.5, 2.5 )
				-- SetTextColour( 255, 255, 255, 255 )
				-- SetTextDropShadow( 0, 0, 0, 0, 255 )
				-- SetTextEdge( 1, 0, 0, 0, 255 )
				-- SetTextEntry( "STRING" )
				-- AddTextComponentString( tostring( contactAmount.."~n~"..currentRow.."~n~"..loadedContacts[currentRow+1].name ) )
				-- DrawText( 0.0, 0.0 )
				
				if IsControlJustReleased(3, 177) then -- BACK
					PlaySoundFrontend(-1, "Menu_Back", "Phone_SoundSet_Michael", 1)
					PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
					PushScaleformMovieFunctionParameterInt(1) -- MENU PAGE
					PushScaleformMovieFunctionParameterInt(1) -- INDEX
					PopScaleformMovieFunctionVoid()
					Wait(500)
					currentColumn = 1
					currentRow = 0
					currentIndex = 0
					currentApp = 1
					return
				end
			end
		end
		
		if app == 9 then -- CAMERA
			frontCam = false
			SetPedConfigFlag(PlayerPedId(), 242, true)
			SetPedConfigFlag(PlayerPedId(), 243, true)
			SetPedConfigFlag(PlayerPedId(), 244, not true)
			-- SetPhoneLean(true)
			-- Wait(500)
			CellCamActivate(true, true)
			CellFrontCamActivate(frontCam)
			while true do Wait(0)
				HideHudComponentThisFrame(7)
				HideHudComponentThisFrame(8)
				HideHudComponentThisFrame(9)
				HideHudComponentThisFrame(6)
				HideHudComponentThisFrame(19)
				HideHudAndRadarThisFrame()
				
				-- local x,y,z=table.unpack(GetEntityRotation(PlayerPedId()))
				-- local rotz=GetGameplayCamRelativeHeading()
				-- rz = (z+rotz)
				-- SetEntityRotation(PlayerPedId(), x,y,rz+180.0)
				
				if (IsControlJustPressed(3, 172)) then -- UP
					frontCam = not false
					CellFrontCamActivate(frontCam)
				end
				if IsControlJustReleased(3, 177) then -- BACK
					PlaySoundFrontend(-1, "Menu_Back", "Phone_SoundSet_Michael", 1)
					PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
					PushScaleformMovieFunctionParameterInt(1) -- MENU PAGE
					PushScaleformMovieFunctionParameterInt(7) -- INDEX
					PopScaleformMovieFunctionVoid()
					SetPedConfigFlag(PlayerPedId(), 242, not true)
					SetPedConfigFlag(PlayerPedId(), 243, not true)
					SetPedConfigFlag(PlayerPedId(), 244, true)
					CellCamActivate(false, false)
					frontCam = false
					Wait(500)
					-- SetPhoneLean(false)
					currentColumn = 1
					currentRow = 2
					currentIndex = 0
					currentApp = 1
					return
				end
			end
		end
		
		Notification("This app is not [yet?] implemented.", 5000)
		
		currentApp = 1
		return
	end)
end

function HandleInput(scaleform)
	if currentApp == 1 then
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
			OpenApp(currentIndex+1)
		end
		
		if IsControlJustReleased(3, 177) and IsPedRunningMobilePhoneTask(PlayerPedId()) == 1 then -- CANCEL / CLOSE PHONE
			PlaySoundFrontend(-1, "Put_Away", "Phone_SoundSet_Michael", 1)
			DestroyMobilePhone()
			phone = false
		end
	end
end

contactAmount = 0

Citizen.CreateThread(function()

	DestroyMobilePhone()
	GlobalScaleform = RequestScaleformMovie("cellphone_ifruit")
	while not HasScaleformMovieLoaded(GlobalScaleform) do
		Citizen.Wait(0)
	end
	
	SetHomeMenuApp(GlobalScaleform, 0, 2, "Texts")
	SetHomeMenuApp(GlobalScaleform, 1, 5, "Contacts")
	SetHomeMenuApp(GlobalScaleform, 2, 12, "To-Do List")
	SetHomeMenuApp(GlobalScaleform, 3, 14, "Player List")
	SetHomeMenuApp(GlobalScaleform, 4, 6, "Eyefind")
	SetHomeMenuApp(GlobalScaleform, 5, 8, "Unknown App")
	SetHomeMenuApp(GlobalScaleform, 6, 24, "Settings")
	SetHomeMenuApp(GlobalScaleform, 7, 1, "Snapmatic")
	SetHomeMenuApp(GlobalScaleform, 8, 57, "SecuroServ")
	
	-- for i,v in pairs(contacts) do
		-- SetContactRaw(GlobalScaleform, contactAmount, v.name, v.icon)
		-- contactAmount = contactAmount + 1
	-- end
	
	local wallpaper = PurpleTartan
	
	RequestStreamedTextureDict(wallpaper)
	repeat Wait(0) until HasStreamedTextureDictLoaded(wallpaper) end
	
	PushScaleformMovieFunction(GlobalScaleform, "SET_THEME")
	PushScaleformMovieFunctionParameterInt(6) -- 1-8
	PopScaleformMovieFunctionVoid()
	
	PushScaleformMovieFunction(GlobalScaleform, "SET_SLEEP_MODE")
	PushScaleformMovieFunctionParameterInt(0)
	PopScaleformMovieFunctionVoid()
	
	-- PushScaleformMovieFunction(GlobalScaleform, "SET_HEADER")
	-- BeginTextComponent("STRING")
	-- AddTextComponentSubstringPlayerName("ass")
	-- EndTextComponent()
	-- PopScaleformMovieFunctionVoid()
	
	PushScaleformMovieFunction(GlobalScaleform, "SET_BACKGROUND_CREW_IMAGE")
	BeginTextComponent("STRING")
	AddTextComponentSubstringPlayerName(wallpaper)
	EndTextComponent()
	PopScaleformMovieFunctionVoid()
	
	PushScaleformMovieFunction(GlobalScaleform, "SET_BACKGROUND_IMAGE")
	BeginTextComponent("STRING")
	AddTextComponentSubstringPlayerName(wallpaper)
	EndTextComponent()
	PopScaleformMovieFunctionVoid()

	SetSoftKeys(GlobalScaleform, 2, 19, 255, 255, 255)
	
	-- PushScaleformMovieFunction(GlobalScaleform, "SET_SOFT_KEYS")
	-- PushScaleformMovieFunctionParameterInt(GlobalScaleform, 0)
	-- PushScaleformMovieFunctionParameterInt(GlobalScaleform, 0)
	-- PushScaleformMovieFunctionParameterInt(GlobalScaleform, 20)
	-- PopScaleformMovieFunctionVoid()

	while true do
	Wait(0)
		if IsPedRunningMobilePhoneTask(PlayerPedId()) ~= 1 and IsControlJustReleased(1, 27) then
			Phone(55,-27) -- CREATING PHONE
			currentColumn = 0
			currentRow = 0
			currentIndex = 0
			currentApp = 1

			PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
			PushScaleformMovieFunctionParameterInt(1) -- MENU PAGE
			PushScaleformMovieFunctionParameterInt(0) -- INDEX
			PopScaleformMovieFunctionVoid()
			
			PlaySoundFrontend(-1, "Pull_Out", "Phone_SoundSet_Michael", 1)
			
			CreateMobilePhone(phoneId)
			SetPedConfigFlag(PlayerPedId(), 242, not true)
			SetPedConfigFlag(PlayerPedId(), 243, not true)
			SetPedConfigFlag(PlayerPedId(), 244, true)
			N_0x83a169eabcdb10a2(PlayerPedId(), 4-1)
		end
		
		if IsPedRunningMobilePhoneTask(PlayerPedId()) == 1 then
			HandleInput(GlobalScaleform)
			
			if GetFollowPedCamViewMode() == 4 then 
				SetMobilePhoneScale(Floatify(0)) 
			else
				SetMobilePhoneScale(Floatify(300)) 
			end
		
			PushScaleformMovieFunction(GlobalScaleform, "SET_TITLEBAR_TIME")
			PushScaleformMovieFunctionParameterInt(GetClockHours()) -- HOURS
			PushScaleformMovieFunctionParameterInt(GetClockMinutes()) -- MINUTES
			PushScaleformMovieFunctionParameterInt(GetClockDayOfWeek()) -- DAYS
			PopScaleformMovieFunctionVoid()
		
			local ren = GetMobilePhoneRenderId()
			SetTextRenderId(ren)
			
			-- SetTextFont( 0 )
			-- SetTextProportional( 0 )
			-- SetTextScale( 2.5, 2.5 )
			-- SetTextColour( 255, 255, 255, 255 )
			-- SetTextDropShadow( 0, 0, 0, 0, 255 )
			-- SetTextEdge( 1, 0, 0, 0, 255 )
			-- SetTextEntry( "STRING" )
			-- AddTextComponentString( tostring( currentIndex ) )
			-- DrawText( 0.0, 0.0 )
			
			DrawScaleformMovie(GlobalScaleform, 0.1, 0.18, 0.2, 0.35, 255, 255, 255, 255, 0)
			
			SetTextRenderId(GetDefaultScriptRendertargetRenderId())
		end
	end
	
end)