class DevicesController < ApplicationController
  before_filter :get_house
  before_filter :get_output_format, :only => :discover

  def index
    @devices = @house.devices
    @devices_by_room = {}
    @house.devices.group_by_room.map {|d| d.room}.each do |room|
      @devices_by_room[(room.blank?) ? I18n.t(:no_room, :scope => :device) : room] = @house.devices.by_room room
    end
  end

  def new
    @devices = @house.devices
    render :layout => "two_columns_tiny_right"
  end

  def create    
    if @house.update_attributes params[:house]
      flash[:success] = I18n.t :update, :scope => [:device, :messages, :success]
      redirect_to user_house_devices_url(current_user, @house)
    else
      render :action => :new, :layout => "two_columns_tiny_right"
    end
  end

  def discover    
    #apply here a call to a class Device method to which a discover will be made

    respond_to do |format|
      format.js {render @options[:output_format]}
    end
  end

  def know    
    @known_device = KnownDevice.find_by_device_class params[:device_class]
    @input_id = params[:input_id]

    respond_to do |format|
      format.js
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
