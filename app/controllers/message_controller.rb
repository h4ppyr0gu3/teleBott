class MessageController < ApplicationController
	def index
		file = File.read(Rails.root.join('lib/assets/info.json'))
		info = JSON.parse file
		@groups = info["bots"][0]["group"]
		@message = info["bots"][0]["current_message"]
	end

	def edit
		file = File.read(Rails.root.join('lib/assets/info.json'))
		info = JSON.parse file
		@message = info["bots"][params[:id].to_i]["current_message"]
		@old = info["bots"][params[:id].to_i]["message_history"]
	end

	def new
	end

	def update
		puts params
		file = File.read(Rails.root.join('lib/assets/info.json'))
		info = JSON.parse file
		info["bots"][params[:id].to_i]["current_message"] = params[:anything][:message]
		if params[:anything][:message] != params[:anything][:old_message]
			info["bots"][params[:id].to_i]["message_history"].each do |history|
				if history == params[:anything][:old_message]
					break
				end
			end
			info["bots"][params[:id].to_i]["message_history"] << params[:anything][:old_message]
		end
		File.write(Rails.root.join('lib/assets/info.json'), JSON.dump(info))
		redirect_to bot_path(params[:id])		
	end

	def destroy
		file = File.read(Rails.root.join('lib/assets/info.json'))
		info = JSON.parse file
		info["bots"][params[:id].to_i]["message_history"].delete_at(params[:history_id].to_i)
		File.write(Rails.root.join('lib/assets/info.json'), JSON.dump(info))
		redirect_to edit_message_path(params[:id])
	end

end

