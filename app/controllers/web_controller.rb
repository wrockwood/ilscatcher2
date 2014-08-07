class WebController < ApplicationController
	def locations
		locations = Rails.cache.read('locations')
		render :json =>{:locations => locations}
	end
end
