class ActionsController < ApplicationController
  before_filter :get_house, :get_device
  before_filter :parse_preview, :only => :preview
  before_filter :get_action, :only => :control

  def get_device
    @device = @house.devices.find params[:device_id]
  end

  def new;end;

  def create
    if @device.update_attributes params[:device]
      flash[:success] = I18n.t :update, :scope => [:action, :messages, :success]
      redirect_to new_user_house_device_action_url(@user, @house, @device)
    else
      render :action => :new
    end
  end

  def find
    respond_to do |format|
      format.js
    end
  end

  def preview
    respond_to do |format|
      format.js
    end
  end

  def set
    respond_to do |format|
      format.js
    end
  end

  def control
    respond_to do |format|
      format.js
    end
  end

  protected

  def parse_preview
    @action = Action.new  :name => params[:name],
                          :command => params[:command],
                          :action_type => params[:action_type],
                          :handle => {  :orientation => params[:handle_orientation],
                                        :display_icon_on => params[:handle_display_icon_on],
                                        :display_icon_off => params[:handle_display_icon_off]
                                     },
                          :range_min => params[:range_min],
                          :range_max => params[:range_max],
                          :temp_id => params[:temp_id],
                          :device => @device
  end

  def get_action
    @action = Action.find params[:id]
  end
end
