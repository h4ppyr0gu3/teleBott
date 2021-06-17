require 'uri'
require 'net/http'

class BotService
	class << self
		def update_all
			Bot.all.each do |bot|
				getUpdates bot.token, bot.id
			end
			a = "success"
		end

		def getUpdates token, bot_id
			@bot = Bot.find(bot_id)
			update_id = @bot.update_id + 1
			if update_id != 1
				uri = URI("https://api.telegram.org/bot#{token}/getUpdates?offset=#{update_id}")
			else
				uri = URI("https://api.telegram.org/bot#{token}/getUpdates")
			end
			res = Net::HTTP.get_response(uri)
			response = JSON.parse res.body
			begin
				response["result"].each do |result|
					if result["my_chat_member"] != nil
						flag = true
						for i in @bot.groups
							if i.group_id == result["my_chat_member"]["chat"]["id"]
								flag = false
							end
						end
						if flag
							Group.find_or_create_by!(bot_id: bot_id, name: result["my_chat_member"]["chat"]["title"],group_id: result["my_chat_member"]["chat"]["id"])
						end
						if @bot.name == @bot.message
							@bot.update!(name: result["my_chat_member"]["new_chat_member"]["user"]["first_name"])
						end
					end
				end
				if response["result"].length > 0 
					last_item = response["result"].last
					updated_id = last_item["update_id"]
					@bot.update!(update_id: updated_id) 
				end
				errors response, @bot.name
			rescue StandardError => e
				puts e
				Error.create!(error: e, bot_name: "exception")
			end
		end

		def sendMessage text, token, chat_id, bot_name
			string = CGI.escape text
			uri = URI("https://api.telegram.org/bot#{token}/sendMessage?chat_id=#{chat_id}&text=#{string}")
			res = Net::HTTP.get_response(uri)
			response = JSON.parse res.body
			errors response, bot_name
		end

		def Cron
			Bot.all.each do |bot|
				bot.groups.each do |group|
					sendMessage bot.message, bot.token, group.group_id, bot.name
				end
			end
		end

		def errors response, bot_name
			if !response["ok"]
				Error.create!(error: response["description"], bot_name: bot_name)
			end
		end
	end
end
