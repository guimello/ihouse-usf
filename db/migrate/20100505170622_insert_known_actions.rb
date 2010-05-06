class InsertKnownActions < ActiveRecord::Migration
  def self.up
		KnownAction.transaction do
			KnownAction.create	:command => "a001",
																		:action_type => Action::ActionTypes::TURN_ON_OFF,
																		:handle => {:html_options_for_object => {:class => "toggle-me-fancy margin-auto"},
																												:jquery_method => "jquery_button"}

			KnownAction.create	:command => "b001",
																		:action_type => Action::ActionTypes::RANGE,																		
																		:handle => {:html_options_for_object => {:class => "slide-me-vertical margin-auto", :style => "height: 200px"},
																											:jquery_method => "jquery_div"}

			KnownAction.create	:command => "b002",
																		:action_type => Action::ActionTypes::RANGE,
																		:handle => {:html_options_for_object => {:class => "slide-me-vertical margin-auto", :style => "height: 200px"},
																											:jquery_method => "jquery_div"}
																	
		end
  end

  def self.down
		KnownAction.delete_all
  end
end
