class BotController < ApplicationController

	def index
		file = File.read(Rails.root.join('lib/assets/info.json'))
		info = JSON.parse file
		@bots = info["bots"]
	end

	def create
		file = File.read(Rails.root.join('lib/assets/info.json'))
		info = JSON.parse file
		bot = {}
		bot["name"] = params[:anything][:message]
		bot["group"] = [
			{
				"name": "", "id": 0
			}
		]
		bot["current_message"] = params[:anything][:message]
		bot["message_history"] = [""]
		bot["update_id"] = 0
		token = params[:anything][:BotToken]
		token = token.gsub("\n", "")
		token = token.gsub("\r", "")
		bot["token"] = token
		info["bots"] << bot
		File.write(Rails.root.join('lib/assets/info.json'), JSON.dump(info))
		UpdateWorker.perform_async
		redirect_to root_path
	end

	def show
		file = File.read(Rails.root.join('lib/assets/info.json'))
		info = JSON.parse file
		@id = params[:id].to_i
		@groups = info["bots"][@id]["group"]
		@message = info["bots"][@id]["current_message"]
		@name = info["bots"][@id]["name"]
	end

	def destroy
		file = File.read(Rails.root.join('lib/assets/info.json'))
		info = JSON.parse file
		info["bots"].delete_at(params[:id].to_i)
		File.write(Rails.root.join('lib/assets/info.json'), JSON.dump(info))
		redirect_to root_path
	end

end