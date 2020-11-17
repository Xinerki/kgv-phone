
frontCam = false
doingGesture = false
alternateBrowserControl = false
messageCount = 0

loadedContacts = {}
pedHeadshots = {}

RegisterNetEvent('phone_server:receiveMessage')

-- INPUT_REPLAY_CYCLEMARKERLEFT = 312
-- INPUT_REPLAY_CYCLEMARKERRIGHT = 313
-- INPUT_CELLPHONE_CAMERA_EXPRESSION = 186

function loopGestures()
	currentGestureDict = 0
	doingGesture = false
	while frontCam do Wait(0)
		if not IsControlPressed(0, 186) then
			if IsControlJustPressed(0, 313) then
				currentGestureDict = (currentGestureDict + 1) % #gestureDicts
				DisplayHelpText("Action Selected:\n" .. gestureNames[currentGestureDict+1], 1000)
			end
			if IsControlJustPressed(0, 312) then
				if currentGestureDict-1 < 0 then 
					currentGestureDict = #gestureDicts-1
				else
					currentGestureDict = (currentGestureDict - 1)
				end
				DisplayHelpText("Action Selected:\n" .. gestureNames[currentGestureDict+1], 1000)
			end
		end
	
		gestureDir = "anim@mp_player_intselfie" .. gestureDicts[currentGestureDict+1]
		
		if IsControlPressed(0, 186) then
			if doingGesture == false then
					doingGesture = true
				if not HasAnimDictLoaded(gestureDir) then
					RequestAnimDict(gestureDir)
					repeat Wait(0) until HasAnimDictLoaded(gestureDir)
				end
				TaskPlayAnim(PlayerPedId(), gestureDir, "enter", 4.0, 4.0, -1, 128, -1.0, false, false, false)
				Wait(GetAnimDuration(gestureDir, "enter")*1000)
				TaskPlayAnim(PlayerPedId(), gestureDir, "idle_a", 8.0, 4.0, -1, 129, -1.0, false, false, false)
			end
		else
			if doingGesture == true then
				doingGesture = false
				TaskPlayAnim(PlayerPedId(), gestureDir, "exit", 4.0, 4.0, -1, 128, -1.0, false, false, false)
				Wait(GetAnimDuration(gestureDir, "exit")*1000)
				RemoveAnimDict(gestureDir)
			end
		end
	end
	TaskPlayAnim(PlayerPedId(), "", "", 4.0, 4.0, -1, 128, -1.0, false, false, false)
	RemoveAnimDict(gestureDir)
end

function OpenApp(app)
	Citizen.CreateThread(function()
		currentApp = app
		if app == 2 then -- MESSAGES
			-- for i=0,3 do
				-- AddMessage(GlobalScaleform, i, tostring(i).."@fivem.net", "spam!")
				-- messageCount = messageCount + 1
			-- end
			PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
			-- PushScaleformMovieFunctionParameterInt(6) -- MENU PAGE
			PushScaleformMovieFunctionParameterInt(8) -- MENU PAGE
			PushScaleformMovieFunctionParameterInt(0) -- INDEX
			PopScaleformMovieFunctionVoid()
			SetMobilePhoneRotation(-90.0, 0.0, 90.0)
			SetPhoneLean(true)
			while true do
			Wait(0)

				if messageCount > 0 then
					if (IsControlJustPressed(3, 172)) then -- UP
						NavigateMenu(GlobalScaleform, 1)
						MoveFinger(1)
						-- currentRow = currentRow - 1
					end

					if (IsControlJustPressed(3, 173)) then -- DOWN
						NavigateMenu(GlobalScaleform, 3)
						MoveFinger(2)
						-- currentRow = currentRow + 1
					end

					currentRow = currentRow % messageCount
				end

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
			for i=0,128 do
				-- print(NetworkIsPlayerActive(i))
				if GetPlayerPed(i) ~= PlayerPedId() then
					if not pedHeadshots[GetPlayerName(i)] then
						if NetworkIsPlayerActive(i) then
							-- print(i.." | "..GetPlayerName(i))
							local handle = RegisterPedheadshot(GetPlayerPed(i))
							if IsPedheadshotValid(handle) then
								BeginTextCommandBusyspinnerOn("STRING")
								AddTextComponentString("LOADING "..GetPlayerName(i):upper().."'s HEADSHOT")
								EndTextCommandBusyspinnerOn(1)
								repeat Wait(0) until IsPedheadshotReady(handle)
								txdString = GetPedheadshotTxdString(handle)
								BusyspinnerOff()
							else
								txdString = "CHAR_DEFAULT" -- something went wrong!
							end
							pedHeadshots[GetPlayerName(i)] = txdString
							-- SetContactRaw(GlobalScaleform, i-127, GetPlayerName(i), txdString)
							SetContactRaw(GlobalScaleform, players, GetPlayerName(i), txdString)
							-- contactAmount = contactAmount + 1
							players = players+1
							-- print("O HO NO ".. GetPlayerName(i) .." HAS NO PED HEADSHOT, QUICK WE GOTTA MAKE ONE AAAAAAAAREEEEEEEEEEEEEEE")
							table.insert(loadedContacts, players, {name = GetPlayerName(i), icon = txdString, isPlayer = true, playerIndex = i})
						end
					else
						local txdString = pedHeadshots[GetPlayerName(i)]
						SetContactRaw(GlobalScaleform, players, GetPlayerName(i), txdString)
						players = players+1
						-- print("just taking ".. GetPlayerName(i) .."'s ped headshot from cache tbh")
						table.insert(loadedContacts, players, {name = GetPlayerName(i), icon = txdString, isPlayer = true, playerIndex = i})
					end
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

				if (IsControlJustPressed(3, 176)) then -- SELECT
					MoveFinger(5)
					PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael", 1)
					if loadedContacts[currentRow+1].isPlayer or false then
						N_0x3ed1438c1f5c6612(2)
						DisplayOnscreenKeyboard(0, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
						repeat Wait(0) until UpdateOnscreenKeyboard() ~= 0
						if UpdateOnscreenKeyboard() == 1 then
							local message = GetOnscreenKeyboardResult()
							-- ReceiveMessage(PlayerPedId(), message)
							-- local receiver = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPlayerFromName(loadedContacts[currentRow+1].name))) -- oh my..
							local receiver = GetPlayerServerId(loadedContacts[currentRow+1].playerIndex)
							print("receiver = "..loadedContacts[currentRow+1].playerIndex)
							TriggerServerEvent("phone_server:receiveMessage", receiver, GetPlayerName(PlayerId()), message, GetPlayerServerId(PlayerId()))
							AddMessage(GlobalScaleform, messageCount, loadedContacts[currentRow+1].name, message, true)
							messageCount = messageCount + 1
						elseif UpdateOnscreenKeyboard() == 2 then
							Notification("Message cancelled.", 5000)
						end
					end
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
		
		if app == 5 then -- MOBILE RADIO
			PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
			PushScaleformMovieFunctionParameterInt(20) -- MENU PAGE
			PushScaleformMovieFunctionParameterInt(0) -- INDEX
			PopScaleformMovieFunctionVoid()			
			while true do
				Wait(0)

				if (IsControlJustPressed(3, 172)) then -- UP
					-- NavigateMenu(GlobalScaleform, 1)
					MoveFinger(1)
					currentRow = currentRow - 1
					SetRadioToStationIndex((GetPlayerRadioStationIndex() + 1) % MaxRadioStationIndex())
				end

				if (IsControlJustPressed(3, 173)) then -- DOWN
					-- NavigateMenu(GlobalScaleform, 3)
					MoveFinger(2)
					currentRow = currentRow + 1
					SetRadioToStationIndex((GetPlayerRadioStationIndex() - 1) % MaxRadioStationIndex())
				end

				if (IsControlJustPressed(3, 176)) then -- SELECT
					MoveFinger(5)
					PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael", 1)
					if IsMobilePhoneRadioActive() == false then
						SetAudioFlag("MobileRadioInGame", 1)
						SetMobilePhoneRadioState(1)
						SetUserRadioControlEnabled(false)
					else
						SetAudioFlag("MobileRadioInGame", 0)
						SetMobilePhoneRadioState(0)
						SetUserRadioControlEnabled(true)
					end
				end
				
				local ren = GetMobilePhoneRenderId()
				SetTextRenderId(ren)
				
				if IsMobilePhoneRadioActive() == false then
					SetTextFont(0)
					SetTextScale(0.0, 0.45)
					SetTextColour(255, 255, 255, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(2, 0, 0, 0, 150)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					SetTextCentre(1)
					AddTextComponentString("~r~MOBILE RADIO OFF~w~~n~~n~TAP TO ~g~TURN ON ~w~MOBILE RADIO")
					DrawText(0.5, 0.24)
				else
					SetTextFont(0)
					SetTextScale(0.0, 0.4)
					SetTextColour(255, 255, 255, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(2, 0, 0, 0, 150)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					SetTextCentre(1)
					AddTextComponentString("^~n~CURRENT RADIO:~n~~g~"..GetLabelText(GetPlayerRadioStationName()).."~w~~n~V~n~~n~TAP TO ~r~TURN OFF ~w~MOBILE RADIO")
					DrawText(0.5, 0.235)
				end

				SetTextRenderId(GetDefaultScriptRendertargetRenderId())

				if IsControlJustReleased(3, 177) then -- BACK
					PlaySoundFrontend(-1, "Menu_Back", "Phone_SoundSet_Michael", 1)
					PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
					PushScaleformMovieFunctionParameterInt(1) -- MENU PAGE
					PushScaleformMovieFunctionParameterInt(3) -- INDEX
					PopScaleformMovieFunctionVoid()
					Wait(500)
					currentColumn = 0
					currentRow = 1
					currentIndex = 4
					currentApp = 1
					return
				end
			end
		end
		
		if app == 6 then -- BROWSER
			-- local resX, resY = GetActiveScreenResolution()
			-- local webX, webY = 1920, 1080
			-- local webX, webY = 1280, 900
			local webX, webY = 640, 450
			
			RequestStreamedTextureDict( "desktop_pc" )
			
			local cursorX = webX / 2
			local cursorY = webY / 2
			local cursorSpeed = 15
			local scrollSpeed = 150
			
			PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
			PushScaleformMovieFunctionParameterInt(20) -- MENU PAGE
			PushScaleformMovieFunctionParameterInt(0) -- INDEX
			PopScaleformMovieFunctionVoid()			
		
			N_0x3ed1438c1f5c6612(2)
			DisplayOnscreenKeyboard(0, "FMMC_KEY_TIP8", "", message or "", "", "", "", 60)
			repeat Wait(0) until UpdateOnscreenKeyboard() ~= 0
			if UpdateOnscreenKeyboard() == 1 then
				message = GetOnscreenKeyboardResult()
			elseif UpdateOnscreenKeyboard() == 2 then
				PlaySoundFrontend(-1, "Menu_Back", "Phone_SoundSet_Michael", 1)
				PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
				PushScaleformMovieFunctionParameterInt(1) -- MENU PAGE
				PushScaleformMovieFunctionParameterInt(4) -- INDEX
				PopScaleformMovieFunctionVoid()
				SetPhoneLean(false)
				SetMobilePhoneRotation(-90.0, 0.0, 0.0)
				Wait(500)
				currentColumn = 1
				currentRow = 1
				currentIndex = 1
				currentApp = 1
				return
			end
			
			SetPhoneLean(true)
			SetMobilePhoneRotation(-90.0, 0.0, 90.0)
			
			while true do
			
				Wait(0)
				
				if not duiObj and not txd then
					txd = CreateRuntimeTxd('kgv_phone')
					duiObj = CreateDui(message, webX, webY)
				
					_G.duiObj = duiObj

					dui = GetDuiHandle(duiObj)
					tx = CreateRuntimeTextureFromDuiHandle(txd, 'kgv_phone_tex', dui)
				end
				
				if alternateBrowserControl then
					DisableControlAction(0, 1)
					DisableControlAction(0, 2)
				
					local mouseX = GetDisabledControlNormal(0, 1) * cursorSpeed
					local mouseY = GetDisabledControlNormal(0, 2) * cursorSpeed
					
					cursorX = cursorX - mouseY
					cursorY = cursorY + mouseX
				else
					if (IsControlPressed(3, 172)) then -- UP
						MoveFinger(1)
						cursorX = cursorX + cursorSpeed
					end

					if (IsControlPressed(3, 173)) then -- DOWN
						MoveFinger(2)
						cursorX = cursorX - cursorSpeed
					end

					if (IsControlPressed(3, 174)) then -- LEFT
						MoveFinger(3)
						cursorY = cursorY - cursorSpeed
					end

					if (IsControlPressed(3, 175)) then -- RIGHT
						MoveFinger(4)
						cursorY = cursorY + cursorSpeed
					end
				end

				if (IsControlJustPressed(3, 180)) then -- SCROLL DOWN
					MoveFinger(2)
					SendDuiMouseWheel(duiObj, -scrollSpeed, 0.0)
				end

				if (IsControlJustPressed(3, 181)) then -- SCROLL UP
					MoveFinger(2)
					SendDuiMouseWheel(duiObj, scrollSpeed, 0.0)
				end

				if (IsControlJustPressed(3, 176)) then -- PRESS DOWN
					MoveFinger(5)
					PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael", 1)
					SendDuiMouseDown(duiObj, 'left')
				end

				if (IsControlJustReleased(3, 176)) then -- PRESS UP
					MoveFinger(5)
					-- PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael", 1)
					SendDuiMouseUp(duiObj, 'left')
					SetPhoneLean(true)
				end
				
				-- SendDuiMouseWheel
				-- local FovControl = GetDisabledControlNormal(0, 39)
				
				cursorX = math.floor(math.min(math.max(cursorX, 0.0), webY))
				cursorY = math.floor(math.min(math.max(cursorY, 0.0), webX))
				
				SendDuiMouseMove(duiObj, cursorY, webY-cursorX)
				
				-- SetTextFont(0)
				-- SetTextProportional(1)
				-- SetTextScale(0.0, 0.55)
				-- SetTextColour(255, 255, 255, 255)
				-- SetTextDropshadow(0, 0, 0, 0, 255)
				-- SetTextEdge(2, 0, 0, 0, 150)
				-- SetTextDropShadow()
				-- SetTextOutline()
				-- SetTextEntry("STRING")
				-- SetTextCentre(1)
				-- AddTextComponentString("scrollY = " .. scrollY)
				-- DrawText(0.5, 0.0)
				
				local ren = GetMobilePhoneRenderId()
				SetTextRenderId(ren)
				
				DrawRect(0.5, 0.5, 1.0, 1.0, 255, 255, 255, 255)
				-- DrawSprite(textureDict, textureName, screenX, screenY, width, height, heading, red, green, blue, alpha)
				DrawSprite('kgv_phone', 'kgv_phone_tex', 0.5, 0.5, 1.0, 1.0, 90.0, 255, 255, 255, 255)
				DrawSprite("desktop_pc", "arrow", (cursorX-16)/webY, (cursorY+16)/webX, 0.1, 0.05, 90.0, 255, 255, 255, 255)

				SetTextRenderId(GetDefaultScriptRendertargetRenderId())

				if IsControlJustReleased(3, 177) then -- BACK
					DestroyDui(duiObj)
					duiObj = nil
					txd = nil
					PlaySoundFrontend(-1, "Menu_Back", "Phone_SoundSet_Michael", 1)
					PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
					PushScaleformMovieFunctionParameterInt(1) -- MENU PAGE
					PushScaleformMovieFunctionParameterInt(4) -- INDEX
					PopScaleformMovieFunctionVoid()
					SetPhoneLean(false)
					SetMobilePhoneRotation(-90.0, 0.0, 0.0)
					Wait(500)
					currentColumn = 1
					currentRow = 1
					currentIndex = 1
					currentApp = 1
					return
				end
			end
		end
		
		if app == 8 then -- SETTINGS
		
			AddSetting(GlobalScaleform, 1, "Theme: "..themes[theme])
			AddSetting(GlobalScaleform, 2, "Background: "..wallpaperNames[wallpaper])
			AddSetting(GlobalScaleform, 3, "Browser control: "..GetControlModeName(alternateBrowserControl))
			
			PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
			PushScaleformMovieFunctionParameterInt(18) -- MENU PAGE
			PushScaleformMovieFunctionParameterInt(0) -- INDEX
			PopScaleformMovieFunctionVoid()
			
			page = 1
			
			currentRow = 0
			
			while true do
				Wait(0)

				if (IsControlJustPressed(3, 172)) then -- UP
					NavigateMenu(GlobalScaleform, 1)
					MoveFinger(1)
					currentRow = currentRow - 1
					if currentRow < 0 then currentRow = #settings - 1 end
				end

				if (IsControlJustPressed(3, 173)) then -- DOWN
					NavigateMenu(GlobalScaleform, 3)
					MoveFinger(2)
					currentRow = currentRow + 1
					if currentRow >= #settings then currentRow = 0 end
				end
				

				if (IsControlJustPressed(3, 174)) then -- LEFT
					MoveFinger(3)
					PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael", 1)
					
					if currentRow == 0 then
						theme = theme - 1
						if theme < 1 then theme = #themes end
						AddSetting(GlobalScaleform, 1, "Theme: "..themes[theme])
						SetResourceKvpInt("KGV:PHONE:THEME", theme)

						PushScaleformMovieFunction(GlobalScaleform, "SET_THEME")
						PushScaleformMovieFunctionParameterInt(theme) -- 1-8
						PopScaleformMovieFunctionVoid()
						N_0x83a169eabcdb10a2(PlayerPedId(), theme-1)
						
						PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
						PushScaleformMovieFunctionParameterInt(18) -- MENU PAGE
						PushScaleformMovieFunctionParameterInt(0) -- INDEX
						PopScaleformMovieFunctionVoid()
					elseif currentRow == 1 then
						wallpaper = wallpaper - 1
						if wallpaper < 1 then wallpaper = #wallpapers end
						AddSetting(GlobalScaleform, 2, "Background: "..wallpaperNames[wallpaper])
						SetResourceKvpInt("KGV:PHONE:WALLPAPER", wallpaper)

						PushScaleformMovieFunction(GlobalScaleform, "SET_BACKGROUND_CREW_IMAGE")
						BeginTextComponent("STRING")
						AddTextComponentSubstringPlayerName(wallpapers[wallpaper])
						EndTextComponent()
						PopScaleformMovieFunctionVoid()
						
						PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
						PushScaleformMovieFunctionParameterInt(18) -- MENU PAGE
						PushScaleformMovieFunctionParameterInt(1) -- INDEX
						PopScaleformMovieFunctionVoid()
					end
				end
				
				-- if (IsControlJustPressed(3, 175)) then -- RIGHT
					-- MoveFinger(4)
					-- currentTimecyc = currentTimecyc + 1
					-- if currentTimecyc > #filters then currentTimecyc = 0 end
					
					-- if currentTimecyc == 0 then 
						-- ClearTimecycleModifier() 
					-- else
						-- SetTimecycleModifier(filters[currentTimecyc])
					-- end
					-- DisplayHelpText("Filter Selected: " .. currentTimecyc+1, 1000)
				-- end
					

				if (IsControlJustPressed(3, 175)) then -- RIGHT
					MoveFinger(4)
					PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael", 1)
					
					if currentRow == 0 then
						theme = theme + 1
						if theme > #themes then theme = 1 end
						AddSetting(GlobalScaleform, 1, "Theme: "..themes[theme])
						SetResourceKvpInt("KGV:PHONE:THEME", theme)

						PushScaleformMovieFunction(GlobalScaleform, "SET_THEME")
						PushScaleformMovieFunctionParameterInt(theme) -- 1-8
						PopScaleformMovieFunctionVoid()
						N_0x83a169eabcdb10a2(PlayerPedId(), theme-1)
						
						PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
						PushScaleformMovieFunctionParameterInt(18) -- MENU PAGE
						PushScaleformMovieFunctionParameterInt(0) -- INDEX
						PopScaleformMovieFunctionVoid()
					elseif currentRow == 1 then
						wallpaper = wallpaper+ 1
						if wallpaper > #wallpapers then wallpaper = 1 end
						AddSetting(GlobalScaleform, 2, "Background: "..wallpaperNames[wallpaper])
						SetResourceKvpInt("KGV:PHONE:WALLPAPER", wallpaper)

						PushScaleformMovieFunction(GlobalScaleform, "SET_BACKGROUND_CREW_IMAGE")
						BeginTextComponent("STRING")
						AddTextComponentSubstringPlayerName(wallpapers[wallpaper])
						EndTextComponent()
						PopScaleformMovieFunctionVoid()
						
						PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
						PushScaleformMovieFunctionParameterInt(18) -- MENU PAGE
						PushScaleformMovieFunctionParameterInt(1) -- INDEX
						PopScaleformMovieFunctionVoid()
					end
				end

				if (IsControlJustPressed(3, 176)) then -- SELECT
					MoveFinger(5)
					PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Michael", 1)

					print(currentRow)
					
					if currentRow == 2 then
						alternateBrowserControl = not alternateBrowserControl
						AddSetting(GlobalScaleform, 3, "Browser control: "..GetControlModeName(alternateBrowserControl))
						SetResourceKvpInt("KGV:PHONE:BROWSERCONTROL", GetControlModeBool(alternateBrowserControl))
						print(GetControlModeName(alternateBrowserControl))
						
						PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
						PushScaleformMovieFunctionParameterInt(18) -- MENU PAGE
						PushScaleformMovieFunctionParameterInt(2) -- INDEX
						PopScaleformMovieFunctionVoid()
					end
					
					-- if math.abs(currentRow) % 2 == 0 then
						-- theme = (theme + 1) % 7
						-- AddSetting(GlobalScaleform, 1, "Theme: "..themes[theme+1])
						-- SetResourceKvpInt("KGV:PHONE:THEME", theme+1)

						-- PushScaleformMovieFunction(GlobalScaleform, "SET_THEME")
						-- PushScaleformMovieFunctionParameterInt(theme+1) -- 1-8
						-- PopScaleformMovieFunctionVoid()
						-- N_0x83a169eabcdb10a2(PlayerPedId(), theme)
						
						-- PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
						-- PushScaleformMovieFunctionParameterInt(18) -- MENU PAGE
						-- PushScaleformMovieFunctionParameterInt(0) -- INDEX
						-- PopScaleformMovieFunctionVoid()
					-- elseif math.abs(currentRow) % 2 == 1 then
						-- wallpaper = (wallpaper + 1) % #wallpapers
						-- AddSetting(GlobalScaleform, 2, "Background: "..wallpaperNames[wallpaper+1])
						-- SetResourceKvpInt("KGV:PHONE:WALLPAPER", wallpaper+1)

						-- PushScaleformMovieFunction(GlobalScaleform, "SET_BACKGROUND_CREW_IMAGE")
						-- BeginTextComponent("STRING")
						-- AddTextComponentSubstringPlayerName(wallpapers[wallpaper+1])
						-- EndTextComponent()
						-- PopScaleformMovieFunctionVoid()
						
						-- PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
						-- PushScaleformMovieFunctionParameterInt(18) -- MENU PAGE
						-- PushScaleformMovieFunctionParameterInt(1) -- INDEX
						-- PopScaleformMovieFunctionVoid()
					-- end
					
				end

				if IsControlJustReleased(3, 177) then -- BACK
					PlaySoundFrontend(-1, "Menu_Back", "Phone_SoundSet_Michael", 1)
					PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
					PushScaleformMovieFunctionParameterInt(1) -- MENU PAGE
					PushScaleformMovieFunctionParameterInt(6) -- INDEX
					PopScaleformMovieFunctionVoid()
					Wait(500)
					currentColumn = 0
					currentRow = 2
					currentIndex = 1
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
			
			
			PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
			PushScaleformMovieFunctionParameterInt(16) -- MENU PAGE
			PushScaleformMovieFunctionParameterInt(0) -- INDEX
			PopScaleformMovieFunctionVoid()
			
			local xOffset = 0.0
			local yOffset = 1.0
			local roll = 0.0
			local distance = 1.0
			
			local headY = 0.0
			local headRoll = 0.0
			local headHeight = 0.0
			
			local currentTimecyc = 0
			
			currentGestureDict = 0
			
			flashEnabled = false
			dofEnabled = false
			Citizen.InvokeNative(0xA2CCBE62CD4C91A4, SetMobilePhoneUnk(dofEnabled))
			
			while true do Wait(0)
				HideHudComponentThisFrame(7)
				HideHudComponentThisFrame(8)
				HideHudComponentThisFrame(9)
				HideHudComponentThisFrame(6)
				HideHudComponentThisFrame(19)
				HideHudAndRadarThisFrame()
				
				local mouseX = GetDisabledControlNormal(0, 1) / 2.0
				local mouseY = -GetDisabledControlNormal(0, 2) / 2.0
				
				-- local ForwardControl = -GetDisabledControlNormal(0, 31) / 12.0
				local LeftRightControl = GetDisabledControlNormal(0, 30) / 12.0
				local FovControl = GetDisabledControlNormal(0, 39) / 5.0
				-- local RollControl = (-GetDisabledControlNormal(0, 44) + GetDisabledControlNormal(0, 38)) / 12.0
				
				if IsControlPressed(0, 179) and frontCam == true then -- Hold Spacebar to adjust camera position
					DisableControlAction(0, 1, true)
					DisableControlAction(0, 2, true)
					
					xOffset = math.clamp(xOffset + mouseX, 0.0, 1.0)
					yOffset = math.clamp(yOffset + mouseY, 0.0, 2.0)
					roll = math.clamp(roll + LeftRightControl, -1.0, 1.0)
					-- distance = math.clamp(distance + FovControl, 0.0, 1.0)
				elseif IsControlPressed(0, 185) and frontCam == true then -- Hold F to adjust head rotation
					DisableControlAction(0, 1, true)
					DisableControlAction(0, 2, true)
					
					headY = math.clamp(headY + mouseX, -1.0, 1.0)
					headRoll = math.clamp(headRoll + LeftRightControl, -1.0, 1.0)
					headHeight = math.clamp(headHeight + mouseY, -1.0, 1.0)
				end
				
				CellCamSetHorizontalOffset(xOffset)
				CellCamSetVerticalOffset(yOffset)
				CellCamSetRoll(roll)
				CellCamSetDistance(distance)
				
				CellCamSetHeadY(headY)
				CellCamSetHeadRoll(headRoll)
				CellCamSetHeadHeight(headHeight)

				-- local x,y,z=table.unpack(GetEntityRotation(PlayerPedId()))
				-- local rotz=GetGameplayCamRelativeHeading()
				-- rz = (z+rotz)
				-- SetEntityRotation(PlayerPedId(), x,y,rz+180.0)
				
				if (IsControlJustPressed(3, 23) and frontCam == false) then -- TOGGLE FLASH
					if flashEnabled == false then
						DisplayHelpText("⚡ FLASH ENABLED ⚡", 1000)
						flashEnabled = true
					else
						DisplayHelpText("⚡ FLASH DISABLED ⚡", 1000)
						flashEnabled = false
					end
				end	
				
				if (IsControlJustPressed(3, 29) and frontCam == true) then -- TOGGLE DOF
					if dofEnabled == false then
						DisplayHelpText("DEPTH OF FIELD ENABLED", 1000)
						dofEnabled = true
					else
						DisplayHelpText("DEPTH OF FIELD DISABLED", 1000)
						dofEnabled = false
					end
					Citizen.InvokeNative(0xA2CCBE62CD4C91A4, SetMobilePhoneUnk(dofEnabled))
				end	

				if (IsControlJustPressed(3, 174)) then -- LEFT
					MoveFinger(3)
					currentTimecyc = currentTimecyc - 1
					if currentTimecyc < 0 then currentTimecyc = #filters end
					if currentTimecyc == 0 then 
						ClearTimecycleModifier() 
					else
						SetTimecycleModifier(filters[currentTimecyc])
					end
					DisplayHelpText("Filter Selected: " .. currentTimecyc+1, 1000)
				end

				if (IsControlJustPressed(3, 175)) then -- RIGHT
					MoveFinger(4)
					currentTimecyc = currentTimecyc + 1
					if currentTimecyc > #filters then currentTimecyc = 0 end
					
					if currentTimecyc == 0 then 
						ClearTimecycleModifier() 
					else
						SetTimecycleModifier(filters[currentTimecyc])
					end
					DisplayHelpText("Filter Selected: " .. currentTimecyc+1, 1000)
					-- sorry
				end

				if IsControlJustPressed(3, 172) then -- UP
					frontCam = not frontCam
					CellFrontCamActivate(frontCam)
					Citizen.CreateThread(loopGestures)
				end

				if (IsControlJustPressed(3, 176)) then -- SELECT
					RequestNamedPtfxAsset("scr_rcpaparazzo1")
					MoveFinger(5)
					PlaySoundFrontend(-1, "Camera_Shoot", "Phone_SoundSet_Michael", 1)
					if not frontCam and flashEnabled then
						UseParticleFxAsset("scr_rcpaparazzo1")
						StartNetworkedParticleFxNonLoopedOnPedBone("scr_rcpap1_camera", PlayerPedId(), 0.0, 0.0, -0.05, 0.0, 0.0, 90.0, 57005, 1065353216, 0, 0, 0)
						Wait(50)
					end
					
					TakePhoto()
					-- Wait(1000)
					if WasPhotoTaken() then
						-- SetLoadingPromptTextEntry("CELL_278")
						-- ShowLoadingPrompt(1)
						
						-- CellCamActivate(false, false)
						-- SetPedConfigFlag(PlayerPedId(), 242, not true)
						-- SetPedConfigFlag(PlayerPedId(), 243, not true)
						-- SetPedConfigFlag(PlayerPedId(), 244, true)
						
						-- print(WasPhotoTaken(3))
							-- N_0x1072f115dab0717e(0, 0)
							-- N_0xd801cc02177fa3f1()
							-- N_0x6a12d88881435dca()
						
						-- Wait(1000)
						
						SavePhoto(-1)
						
						-- print(WasPhotoTaken(3))
						
						-- while true do Wait(0)
							
							-- DrawSprite("PHONE_PHOTO_TEXTURE", "PHONE_PHOTO_TEXTURE", 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
						-- end
						
						-- repeat Wait(0) until WasPhotoTaken() ~= 1
						
						-- print(WasPhotoTaken(3))
						
						ClearPhoto()
					end
				end
				
				if IsControlJustReleased(3, 177) then -- BACK
					ClearTimecycleModifier() 
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
					currentIndex = 1
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
-- and IsPedRunningMobilePhoneTask(PlayerPedId()) == 1
		if IsControlJustReleased(3, 177)  then -- CANCEL / CLOSE PHONE
			PlaySoundFrontend(-1, "Put_Away", "Phone_SoundSet_Michael", 1)
			DisableControlAction(2, 21, false)
			DestroyMobilePhone()
			phone = false
		end
	end
end

contactAmount = 0

Citizen.CreateThread(function()
	DestroyMobilePhone()
	phone = false
	GlobalScaleform = RequestScaleformMovie("cellphone_ifruit")
	while not HasScaleformMovieLoaded(GlobalScaleform) do
		Citizen.Wait(0)
	end

	SetHomeMenuApp(GlobalScaleform, 0, 2, 	"Texts")
	SetHomeMenuApp(GlobalScaleform, 1, 5, 	"Contacts")
	SetHomeMenuApp(GlobalScaleform, 2, 12, 	"To-Do List")
	SetHomeMenuApp(GlobalScaleform, 3, 59, 	"Mobile Radio")
	SetHomeMenuApp(GlobalScaleform, 4, 6, 	"Eyefind")
	SetHomeMenuApp(GlobalScaleform, 5, 8, 	"Unknown App")
	SetHomeMenuApp(GlobalScaleform, 6, 24, 	"Settings")
	SetHomeMenuApp(GlobalScaleform, 7, 1,	"Snapmatic")
	SetHomeMenuApp(GlobalScaleform, 8, 57, 	"SecuroServ")
	
	-- 27 is an interesting [!] icon
	-- 42 is Trackify, should work

	-- for i,v in pairs(contacts) do
		-- SetContactRaw(GlobalScaleform, contactAmount, v.name, v.icon)
		-- contactAmount = contactAmount + 1
	-- end
	
	alternateBrowserControl = GetResourceKvpInt("KGV:PHONE:BROWSERCONTROL") == 1
	
	wallpaper = GetResourceKvpInt("KGV:PHONE:WALLPAPER")
	if wallpaper > #wallpapers then wallpaper = 1 end
	if wallpaper == 0 then wallpaper = 1 end

	-- local wallpaper = PurpleTartan

	-- RequestStreamedTextureDict(wallpapers[wallpaper])
	-- repeat Wait(0) until HasStreamedTextureDictLoaded(wallpapers[wallpaper])
	
	theme = GetResourceKvpInt("KGV:PHONE:THEME") % #themes
	if theme > #themes then theme = 1 end
	if theme == 0 then theme = 1 end

	PushScaleformMovieFunction(GlobalScaleform, "SET_THEME")
	PushScaleformMovieFunctionParameterInt(theme) -- 1-8
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
	AddTextComponentSubstringPlayerName(wallpapers[wallpaper])
	EndTextComponent()
	PopScaleformMovieFunctionVoid()

	-- PushScaleformMovieFunction(GlobalScaleform, "SET_BACKGROUND_IMAGE")
	-- PushScaleformMovieFunctionParameterInt(wallpaper)
	-- PushScaleformMovieFunctionParameterBool(false)
	-- PopScaleformMovieFunctionVoid()

	SetSoftKeys(GlobalScaleform, 2, 19, 255, 255, 255) -- never works idk

	-- PushScaleformMovieFunction(GlobalScaleform, "SET_SOFT_KEYS")
	-- PushScaleformMovieFunctionParameterInt(GlobalScaleform, 0)
	-- PushScaleformMovieFunctionParameterInt(GlobalScaleform, 0)
	-- PushScaleformMovieFunctionParameterInt(GlobalScaleform, 20)
	-- PopScaleformMovieFunctionVoid()

	while true do
	Wait(0)
	-- IsPedRunningMobilePhoneTask(PlayerPedId()) ~= 1 and
		if phone == false and IsControlJustReleased(1, 27) then -- OPEN PHONE
			Phone(55,-27) -- CREATING PHONE
			currentColumn = 0
			currentRow = 0
			currentIndex = 0
			currentApp = 1

			PushScaleformMovieFunction(GlobalScaleform, "DISPLAY_VIEW")
			PushScaleformMovieFunctionParameterInt(1) -- MENU PAGE
			PushScaleformMovieFunctionParameterInt(0) -- INDEX
			PopScaleformMovieFunctionVoid()

			CreateMobilePhone(phoneId)
			phone = true
			SetPedConfigFlag(PlayerPedId(), 242, not true)
			SetPedConfigFlag(PlayerPedId(), 243, not true)
			SetPedConfigFlag(PlayerPedId(), 244, true)
			N_0x83a169eabcdb10a2(PlayerPedId(), theme-1)
			
			DisableControlAction(2, 21, true)

			-- Wait(100)

			-- if IsPedRunningMobilePhoneTask(PlayerPedId()) ~= 1 then
				-- DestroyMobilePhone()
				-- phone = false
			-- else
				PlaySoundFrontend(-1, "Pull_Out", "Phone_SoundSet_Michael", 1)
			-- end

		end
-- IsPedRunningMobilePhoneTask(PlayerPedId()) == 1
		if phone == true then
			HandleInput(GlobalScaleform)

			if GetFollowPedCamViewMode() == 4 then
				SetMobilePhoneScale(Floatify(0))
			else
				SetMobilePhoneScale(Floatify(300))
			end

			PushScaleformMovieFunction(GlobalScaleform, "SET_TITLEBAR_TIME")
			PushScaleformMovieFunctionParameterInt(GetClockHours()) -- HOURS
			PushScaleformMovieFunctionParameterInt(GetClockMinutes()) -- MINUTES
			PushScaleformMovieFunctionParameterString(days[GetClockDayOfWeek()]) -- DAYS
			PopScaleformMovieFunctionVoid()

			PushScaleformMovieFunction(GlobalScaleform, "SET_SIGNAL_STRENGTH")
			PushScaleformMovieFunctionParameterInt(GetZoneScumminess(GetZoneAtCoords(GetEntityCoords(PlayerPedId()))))
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