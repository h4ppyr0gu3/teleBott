# module Services
	require 'uri'
	require 'net/http'

	class BotService
		class << self
			def update_all
				file = File.read(Rails.root.join('lib/assets/info.json'))
				info = JSON.parse file
				info["bots"].each_with_index do |bot, idx|
					getUpdates bot["token"], idx
				end
				a = "success"
			end

			def getUpdates token, bot_id
				file = File.read(Rails.root.join('lib/assets/info.json'))
				info = JSON.parse file
				update_id = info["bots"][bot_id]["update_id"].to_i + 1
				if update_id != 1
					uri = URI("https://api.telegram.org/bot#{token}/getUpdates?offset=#{update_id}")
				else
					uri = URI("https://api.telegram.org/bot#{token}/getUpdates")
				end
				res = Net::HTTP.get_response(uri)
				response = JSON.parse res.body
				response["result"].each_with_index do |result, idx|
					if result["my_chat_member"] != nil
						flag = true
						for i in info["bots"][bot_id]["group"]
							if i["id"].to_s == result["my_chat_member"]["chat"]["id"].to_s
								flag = false
							end
						end
						if flag
							info["bots"][bot_id]["group"] << {
								"name": result["my_chat_member"]["chat"]["title"],
								"id": result["my_chat_member"]["chat"]["id"]
							}
							if result["my_chat_member"]["new_chat_member"]["user"]["is_bot"] && info["bots"][bot_id]["name"] == info["bots"][bot_id]["current_message"]
								info["bots"][bot_id]["name"] = result["my_chat_member"]["new_chat_member"]["user"]["first_name"]
							end
						end
					end
				end
				if response["result"].length > 0 
					last_item = response["result"].last
					updated_id = last_item["update_id"]
					info["bots"][bot_id]["update_id"] = updated_id 
				end
				errors response
				File.write(Rails.root.join('lib/assets/info.json'), JSON.dump(info))
			end

			def sendMessage text, token, chat_id
				string = CGI.escape text
				uri = URI("https://api.telegram.org/bot#{token}/sendMessage?chat_id=#{chat_id}&text=#{string}")
				res = Net::HTTP.get_response(uri)
				response = JSON.parse res.body
				errors response
			end

			def Cron
				file = File.read(Rails.root.join('lib/assets/info.json'))
				info = JSON.parse file
				info["bots"].each do |bot|
					bot["group"].each do |group|
						sendMessage bot["current_message"], bot["token"], group["id"]
					end
				end
			end

			def errors response
				if !response["ok"]
					file = File.read(Rails.root.join('lib/assets/error.json'))
					errors = JSON.parse file
					errors["errors"] << response["description"]
					File.write(Rails.root.join('lib/assets/error.json'), JSON.dump(errors))
				end
			end
		end
	end
# end