class ActionsController < ApplicationController
	before_filter :get_house, :get_device

	def get_device
		@device = @house.devices.find params[:device_id]
	end

	def new
		@device.actions.each do |a|
			puts a.action_type
		end
	end

	def create
		if @device.update_attributes params[:device]
			flash[:success] = I18n.t :update, :scope => [:action, :messages, :success]
			redirect_to new_user_house_device_action_url(@user, @house, @device)
		else
			render :action => :new
		end
	end
end
