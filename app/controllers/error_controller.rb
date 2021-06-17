class ErrorController < ApplicationController

	def index
		@errors = Error.all
	end

	def destroy
		Error.find(params[:id]).delete
		redirect_to error_index_path
	end

end