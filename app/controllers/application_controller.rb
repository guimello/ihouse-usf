# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Session
  include Locale

  before_filter :check_user_logged, :set_locale, :get_user, :check_user_is_correct

  layout "two_columns" # The default layout

  helper :all

  filter_parameter_logging :password

  WillPaginate::ViewHelpers.pagination_options[:next_label]     = I18n.t :next, :scope => :pagination
  WillPaginate::ViewHelpers.pagination_options[:previous_label] = I18n.t :previous, :scope => :pagination

  #around_filter :ops

  def ops
      yield
    rescue
      flash[:error] = "ooooops"
      head :internal_server_error
      redirect_to root_url
  end  

  helper_method :current_path

  def get_user
    @user = current_user
  end

  def check_user_is_correct
    unless @user == User.find(params[:user_id])
      flash[:error] = I18n.t :you_dont_have_permission, :scope => :authorization
      redirect_to root_url
    end
  end

  def get_house
    @house = current_user.houses.find(params[:house_id])
  end

  def current_path
    root_url.chop + request.path
  end

  def main
    
  end
end

