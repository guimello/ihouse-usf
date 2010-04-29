class ActionsController < ApplicationController
	before_filter :get_house, :get_device

	def get_device
		@device = @house.devices.find params[:device_id]
	end

	def new
		
	end
end
