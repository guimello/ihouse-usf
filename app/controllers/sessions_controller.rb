################################################################################
class SessionsController < ApplicationController

  ################################################################################
  layout 'login'

  ################################################################################
  skip_before_filter :check_user_logged, :get_user, :check_user_is_correct

  ################################################################################
  def new
    redirect_to my_panel_url and return if user_logged?

    respond_to do |format|
      format.html
    end
  end

  ################################################################################
  def create
    user =  User.authenticate params[:username], params[:password]

    if user

      session[:user_id] = user.id
      if session[:return_to]
        redirect_to session[:return_to] and return
      else
        redirect_to my_panel_url and return
      end
    end

    flash[:notice] = I18n.t :login_fail, :scope => :authorization
    redirect_to :action => "new"
  end

  ################################################################################
  def destroy
    reset_session
    redirect_to root_url
  end
end