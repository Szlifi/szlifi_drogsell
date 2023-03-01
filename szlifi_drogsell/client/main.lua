ESX = nil
local menuOpen = false
local wasOpen = false


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
  local hash = GetHashKey(Config.Pedskin) -- NPC modellje
  RequestModel(hash)
  while not HasModelLoaded(hash) do
    Wait(1)
  end
  local ped = CreatePed(4, hash, 2682.03, 3507.54, 52.3, 65.96, true, false) -- NPC létrehozása
PlaceObjectOnGroundProperly(ped)
FreezeEntityPosition(ped, true)
SetEntityInvincible(ped, true)
SetBlockingOfNonTemporaryEvents(ped, true)
TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
end)

Citizen.CreateThread(function()
  local DrogDiler = vector3(2682.03, 3507.54, 53.3)
  while ESX == nil do
      Citizen.Wait(0)
  end

  while true do
      Citizen.Wait(0)
      dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Coords, true)
      if dist <= Config.DrawDistance then
          if dist < 1.5 then
              DrawText3Ds(DrogDiler['x'],DrogDiler['y'],DrogDiler['z'],"Nyomd meg az ~r~[E]~s~-t a ~r~DROG~w~ eladásához!")
              if IsControlJustPressed(0, 38) then
                  -- ide kell hogy mit csináljon
                  OpenDrogSell()
              end
          end
      end
  end
end)

function OpenDrogSell()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true

	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.DrogPrices[v.name]

		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, '$'..price, ESX.Math.GroupDigits(price)),
				name = v.name,
				price = price,

				type = 'slider',
				value = 1,
				min = 1,
				max = v.count
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'selldrog', {
		title    = 'Drog Eladás',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('szlifi_drogsell:sellDrogs', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end

DrawText3Ds = function(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end