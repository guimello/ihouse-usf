class SiteController < ApplicationController
  skip_before_filter :check_user_logged, :get_user, :check_user_is_correct, :only => [:index]

  def index
    
  end  
end