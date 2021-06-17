class BotController < ApplicationController

	def index
		@bots = Bot.all
	end

	def create
		token = params[:anything][:BotToken]
		token = token.gsub("\n", "")
		token = token.gsub("\r", "")
		Bot.create!(name: params[:anything][:message], token: token, message: params[:anything][:message])
		UpdateWorker.perform_async
		redirect_to root_path
	end

	def update
		puts params
		Bot.find(params[:id]).update(token: params[:anything][:token])
		redirect_to bot_path(params[:id])
	end

	def show
		@groups = Bot.find(params[:id]).groups
		@bot = Bot.find(params[:id])
	end

	def destroy
		Bot.find(params[:id]).delete
		redirect_to root_path
	end

end