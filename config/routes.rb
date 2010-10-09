################################################################################
ActionController::Routing::Routes.draw do |map|

  ################################################################################
  map.resources :sessions,  :path_names => {:new => 'login', :destroy => 'logout'}, :only => [:new, :create, :destroy]
  map.connect   '/login',   :controller => 'sessions', :action => 'create', :conditions => {:method => :post}
  map.login     '/login',   :controller => 'sessions', :action => 'new'
  map.logout    '/logout',  :controller => 'sessions', :action => 'destroy'

  ################################################################################
  map.resources :users, :collection => {  :exists_username => :get,
                                                            :exists_email => :get} do |user|
    user.resources :houses do |house|
      house.resources :devices, :collection => {:discover => :get, :know => :get} do |device|
        device.resources :actions, :collection => {:find => :get, :preview => :get}, :member => {:set => :put, :control => :get}
      end
    end
  end

  ################################################################################
  map.resources :known_actions, :except => [:new,:create,:index,:show,:destroy], :collection => {:find => :get}

  map.my_panel '/my_panel', :controller => 'users', :action => 'my_panel', :conditions => {:method => :get}

  ################################################################################
  map.root :controller => :site
end
