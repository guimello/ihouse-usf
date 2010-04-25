class DevicesController < ApplicationController
	before_filter :get_house
	before_filter :get_output_format, :only => :discover

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

	def discover		
		#apply here a call to a class Device method to which a discover will be made

		respond_to do |format|
			format.js {render @options[:output_format]}
		end
	end

	def get_output_format
		@options = {}
		case params[:output_format]
			when :table
				@options[:output_format] = :discover_table
			else
				@options[:output_format] = :discover_table
		end
	end
end
