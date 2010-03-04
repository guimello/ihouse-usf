module Session

#  def authenticate(username, password)
#    user = User.find_by_username_and_password username, password

#    return (user.nil?) ? false : user
#  end

  def self.included(klass)
    klass.class_eval do
      include AuthorizationHelpers

      helper_method :current_user, :user_logged?

    end
  end

  module AuthorizationHelpers
    def current_user
      begin
        @current_user ||= User.find(session[:user_id])

        return @current_user
      rescue
        return false
      end
    end

    def user_logged?
      return session[:user_id] && current_user
    end

    def check_user_logged
      respond_to do |format|
        format.html do
          unless user_logged?
            flash[:notice] = I18n.t :you_are_not_logged_in, :scope => :authorization
            session[:return_to] = request.request_uri
            redirect_to login_path
          end
        end
        format.js do
          unless user_logged?
            user = authenticate_or_request_with_http_basic do |login, password|
              session[:user_id] = authenticate(login, password)
            end
          end
        end
      end
      Thread.current[:user_id] = session[:user_id]
    end
  end
end

