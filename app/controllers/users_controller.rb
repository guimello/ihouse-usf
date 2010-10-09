################################################################################
class UsersController < ApplicationController

  ################################################################################
  skip_before_filter :get_user, :check_user_logged, :check_user_is_correct, :only => [
                                                                                        :new,
                                                                                        :create,
                                                                                        :exists_username,
                                                                                        :exists_email
                                                                                      ]
  ################################################################################
  before_filter :can_sign_in, :only => [:new, :create]

  ################################################################################
  def check_user_is_correct
    return true unless params[:id]
    unless @user == User.find(params[:id])
      flash[:error] = I18n.t :you_dont_have_permission, :scope => :authorization
      redirect_to root_url
    end
  end

  ################################################################################
  def can_sign_in
    if user_logged?
      flash[:error] = I18n.t :cant_create_new_user, :scope => [:user, :messages, :error]
      redirect_to my_panel_url
    end
  end

  ################################################################################
  def my_panel
    @action_logs = Log.action_logs current_user, 'all'

    render :layout => "two_columns_tiny_left" and return unless current_user.houses.empty?
  end

  ################################################################################
  def new
    @user = User.new
  end

  ################################################################################
  def create
    @user = User.new params[:user]
    begin
      @user.save!
      session[:user_id] = @user.id
      flash[:success] = I18n.t :create, :scope => [:user, :messages, :success]
      redirect_to my_panel_url
    rescue
      render :new and return
    end
  end

  ################################################################################
  def show
    respond_to do |format|
      format.html do
        render :layout => 'one_column'
      end
    end
  end

  ################################################################################
  def edit
    @user = current_user

    respond_to do |format|
      format.html
    end
  end

  ################################################################################
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

  ################################################################################
  def exists_username    
    @result = {:input_id => params[:input_id]}
    if current_user and params[:username] == current_user.username
      @result[:icon] = "user"
      @result[:message] = I18n.t(:this_is_you, :scope => :user)
    elsif User.exists? :username => params[:username]
      @result[:icon] = "cross"
      @result[:message] = I18n.t(:username_taken, :scope => [:user, :messages, :error])
    else
      @result[:icon] = "tick"
      @result[:message] = I18n.t(:username_available, :scope => [:user, :messages, :success])
    end

    respond_to do |format|
      format.js
    end
  end

  ################################################################################
  def exists_email
    @result = {:input_id => params[:input_id]}
    if (params[:email] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i) == nil
      @result[:icon] = " "
      @result[:message] = " "
    elsif current_user and params[:email] == current_user.email
      @result[:icon] = "user"
      @result[:message] = I18n.t(:this_is_you, :scope => :user)
    elsif User.exists? :email => params[:email]
      @result[:icon] = "cross"
      @result[:message] = I18n.t(:email_taken, :scope => [:user, :messages, :error])
    else
      @result[:icon] = "tick"
      @result[:message] = I18n.t(:email_available, :scope => [:user, :messages, :success])
    end

    respond_to do |format|
      format.js
    end
  end
end