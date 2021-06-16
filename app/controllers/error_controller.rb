class ErrorController < ApplicationController

	def index
		file = File.read(Rails.root.join('lib/assets/error.json'))
		errors = JSON.parse file
		@errors = errors["errors"]
	end

	def destroy
		file = File.read(Rails.root.join('lib/assets/error.json'))
		errors = JSON.parse file
		errors["errors"].delete_at(params[:id].to_i)
		File.write(Rails.root.join('lib/assets/error.json'), JSON.dump(errors))
		redirect_to error_index_path
	end

end