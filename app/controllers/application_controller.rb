################################################################################
class ApplicationController < ActionController::Base

  ################################################################################
  include Session
  include Locale

  ################################################################################
  before_filter :check_user_logged, :set_locale, :get_user, :check_user_is_correct

  ################################################################################
  layout "two_columns" # The default layout

  ################################################################################
  helper :all

  ################################################################################
  filter_parameter_logging :password

  #WillPaginate::ViewHelpers.pagination_options[:next_label]     = I18n.t :next, :scope => :pagination
  #WillPaginate::ViewHelpers.pagination_options[:previous_label] = I18n.t :previous, :scope => :pagination

  ################################################################################
  helper_method :current_path

  ################################################################################
  def get_user
    @user = current_user
  end

  ################################################################################
  def check_user_is_correct
    unless @user == User.find(params[:user_id])
      flash[:error] = I18n.t :you_dont_have_permission, :scope => :authorization
      redirect_to root_url
    end
  end

  ################################################################################
  def get_house
    begin
      @house = current_user.houses.find(params[:house_id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = I18n.t :you_mistyped_the_house_url, :scope => :application
      redirect_to my_panel_url and return
    end
  end

  ################################################################################
  def current_path
    root_url.chop + request.path
  end

  ################################################################################
  def main;end
end