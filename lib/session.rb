module Session
  
  def authenticate(username, password)
    user = User.find_by_username_and_password username, password
    
    return (user.nil?) ? false : user
  end
  
  def self.included(klass)
    klass.class_eval do
      include AuthorizationHelpers
      
      helper_method :current_user, :user_logged?
      
      before_filter :build_permissions
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
    
    def build_permissions
      current_user
      Right.all.each do |right|
        @current_user.class.send :define_method, "can_#{((right.action == "index") ? "view" : right.action)}_#{right.controller}?" do |project|
          has_permission = false
          permissions.find_by_project_id(project.id).role.rights.each do |user_right|
            if user_right.action == right.action and user_right.controller == right.controller
              has_permission = true
            end
          end
          return has_permission
        end
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
    
    def check_rights
      user = @project.users.find(current_user)
      
      unless user.nil?
        for permission in user.permissions
          if permission.project == @project
            
            for right in permission.role.rights            
              if right.controller == controller_name and right.action == action_name             
                return true          
              end
            end          
          end
        end
      end
      
      respond_to do |format|
        format.html do
          flash[:notice] = I18n.t :you_dont_have_permission, :scope => :authorization 
          redirect_to root_path
        end
        format.js
      end
    end
  end
end