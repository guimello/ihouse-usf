################################################################################
class ActionsController < ApplicationController

  ################################################################################
  before_filter :get_house, :get_device
  before_filter :parse_preview, :only => :preview
  before_filter :get_action, :only => [:set, :control]

  ################################################################################
  def get_device
    @device = @house.devices.find params[:device_id]
  end

  ################################################################################
  def new;end;

  ################################################################################
  def create
    if @device.update_attributes params[:device]
      flash[:success] = I18n.t :update, :scope => [:action, :messages, :success]
      redirect_to new_user_house_device_action_url(@user, @house, @device)
    else
      render :action => :new
    end
  end

  ################################################################################
  def find
    @actions = @device.find_actions

    respond_to do |format|
      format.js
    end
  end

  ################################################################################
  def preview
    respond_to do |format|
      format.js
    end
  end

  ################################################################################
  def set
    @action.new_value = params[:value]

    unless @action.valid_new_value?
      @error_message = I18n.t :invalid_new_value, :scope => [:action, :messages, :error]
    else
      @response = @action.send_new_value

      # 500 Error
      if @response[:success] == 500
        @error_message = I18n.t :there_was_an_error_while_trying_to_manipulate_the_device, :scope => [:action, :messages, :error]
      else
        @action.device.house.touch
        @action.device.touch
        @action.touch
        @action.write_log :action => :set
      end
    end
    
    respond_to do |format|
      format.js
    end
  end

  ################################################################################
  def control
    respond_to do |format|
      format.js
    end
  end

  ################################################################################
  protected

  ################################################################################
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

  ################################################################################
  def get_action
    @action = Action.find params[:id]
  end
end
