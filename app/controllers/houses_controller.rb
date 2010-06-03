class HousesController < ApplicationController
  before_filter :get_house, :only => [:show, :edit, :update]

  def get_house
    begin
      @house = @user.houses.find params[:id]
    rescue ActiveRecord::RecordNotFound
      flash[:error] = I18n.t :you_mistyped_the_house_url, :scope => :application
      redirect_to my_panel_url and return
    end
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

  def edit

  end

  def update
    if @house.update_attributes params[:house]
      flash[:success] = I18n.t :update, :scope => [:house, :messages, :success]
      redirect_to user_house_url(@user, @house) and return
    end
    render :edit and return
  end
end
