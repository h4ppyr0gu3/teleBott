class MessageController < ApplicationController
	def edit
		@bot = Bot.find(params[:id])
		@old = History.where(bot_id: params[:id])
	end

	def new
	end

	def update
		Bot.find(params[:id]).histories.create!(message: params[:anything][:old_message])
		Bot.find(params[:id]).update(message: params[:anything][:message])
		redirect_to bot_path(params[:id])		
	end

	def destroy
		History.find(params[:history]).delete		
		redirect_to edit_message_path(params[:id])
	end
end

