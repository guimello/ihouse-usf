class UsersController < ApplicationController
  skip_before_filter :get_user

  def show
    @user = User.find(params[:id])

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

