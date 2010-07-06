class SchedulesController < ApplicationController

  ################################################################################
  before_filter :get_house, :get_device, :get_action

  ################################################################################
  def get_device
    @device = @house.devices.find params[:device_id]
  end
  
  ################################################################################
  def get_action
    @action = @device.actions.find params[:action_id]
  end
  
  ################################################################################
  def index
    @schedules = @action.schedules.all
  end
  
  ################################################################################
  def new
    @schedules = @action.schedules
  end
  
  ################################################################################
  def create
    if @action.update_attributes params[:action]
      flash[:success] = 'yeah!'
      redirect_to :new and return
    end
    
    render :new
  end  
end
