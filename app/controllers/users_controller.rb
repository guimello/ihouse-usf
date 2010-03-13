class UsersController < ApplicationController
  skip_before_filter :get_user, :check_user_logged, :only => [:new, :create]
  before_filter :can_sign_in, :only => [:new, :create]

  def can_sign_in
    if user_logged?
      flash[:error] = I18n.t :cant_create_new_user, :scope => [:user, :messages, :error]
      redirect_to root_url
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user]
    begin
      @user.save!
      session[:user_id] = @user.id
      redirect_to @user
    rescue
      render :new and return
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def edit
    @user = current_user

    respond_to do |format|
      format.html {render :layout => "one_column"}
    end
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      set_locale
      flash[:success] = I18n.t :update, :scope => [:user, :messages, :success]
      redirect_to @user
    else
      render :action => "edit"
    end
  end
end

