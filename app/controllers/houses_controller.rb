class HousesController < ApplicationController
  before_filter :get_house, :only => [:show]

  def get_house
    @house = @user.houses.find params[:id]
  end

  def new
    @house = @user.houses.new
  end

  def create
    @house = @user.houses.new params[:house]

    if @house.save
      flash[:success] = I18n.t :create, :scope => [:house, :messages, :success]
      redirect_to user_house_url(@user, @house) and return
    end
    render :new and return
  end

  def show

  end

  def index
    @houses = @user.houses
  end
end
