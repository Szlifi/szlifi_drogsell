ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('szlifi_drogsell:sellDrogs')
AddEventHandler('szlifi_drogsell:sellDrogs', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.DrogPrices[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if xItem.count < amount then
		xPlayer.showNotification("~r~Nincsen nálad semmien drog.")
		return
	end

	price = ESX.Math.Round(price * amount)

		xPlayer.addAccountMoney(Config.MoneyType, price)
		xPlayer.addMoney(price)

	xPlayer.removeInventoryItem(xItem.name, amount)
	xPlayer.showNotification('Sikeresen eladtál ~b~'..amount..'db~s~ ~y~'..xItem.name..'-t~s~ ennyiért ~g~$'..price..'~s~', amount, xItem.label, ESX.Math.GroupDigits(price))
    sendToDiscord(GetPlayerName(source),"**Játékos neve: **" ..GetPlayerName(source) .. "\n **Áru neve: **"..xItem.name.." \n **Áru mennyisége: ** "..amount.." \n **Áru ára: ** "..price.." ", 2123412)
end)

            --DISOCRD LOG RÉSZ--
function sendToDiscord(name, message, color)
    local image = Config.Image
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**Wolf Scripts Log**",
              ["description"] = message,
              ["footer"] = {
                ['icon_url'] = image,
                ["text"] = "Wolf Scripts | "..os.date("%Y-%m-%d %H:%M:%S")
              },
          }
      }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' })
end