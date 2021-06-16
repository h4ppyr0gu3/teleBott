class GroupController < ApplicationController

	def index
	end

	def show
	end

	def edit
	end

	def update
	end

	def destroy
		puts params
		file = File.read(Rails.root.join('lib/assets/info.json'))
		info = JSON.parse file
		info["bots"][params[:id].to_i]["group"].delete_at(params[:group_id].to_i)
		File.write(Rails.root.join('lib/assets/info.json'), JSON.dump(info))
		redirect_to bot_path(params[:id])
	end
end