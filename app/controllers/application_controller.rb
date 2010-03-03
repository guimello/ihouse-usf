# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Session
  include Locale

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

  before_filter :check_user_logged, :set_locale, :get_project, :check_rights, :check_user_configuration

  helper_method :current_path

  def get_project
    @project = current_user.projects.find(params[:project_id])
  end  

  def current_path
    root_url.chop + request.path
  end
 

  def check_user_configuration
#    if current_user.time_zone.nil? or current_user.locale.nil?
#      flash[:notice] = I18n.t :first_login, :scope => [:user, :hints]
#      redirect_to edit_user_url(current_user)
#    end
  end 
end