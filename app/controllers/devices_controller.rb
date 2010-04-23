class DevicesController < ApplicationController
	before_filter :get_house

	def new
		@devices = @house.devices		
	end

	def create
		if @house.update_attributes params[:house]
			flash[:success] = "yeah!"
			render :action => :new
		else
			render :action => :new
		end
	end
end
