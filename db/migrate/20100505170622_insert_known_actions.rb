class InsertKnownActions < ActiveRecord::Migration
  def self.up
		KnownAction.transaction do
			KnownAction.create	:command => "a001",
																		:action_type => Action::ActionTypes::TURN_ON_OFF,
																		:handle => { :jquery_method => "jquery_checkbox_button",
																												:js_partial => "toggle_me_light",
																												:translation_keys => {:on => "state_on", :off => "state_off"}
																												}

			KnownAction.create	:command => "b001",
																		:action_type => Action::ActionTypes::RANGE,																		
																		:handle => {:html_options_for_jquery_div => {:style => "height: 200px;"},
																											:jquery_method => "jquery_div",
																											:js_partial => "slide_me_vertical"
																											}

			KnownAction.create	:command => "b002",
																		:action_type => Action::ActionTypes::RANGE,
																		:handle => {:html_options_for_jquery_div => {:style => "height: 200px;"},
																											:jquery_method => "jquery_div",
																											:js_partial => "slide_me_vertical"
																											}
																	
		end
  end

  def self.down
		KnownAction.delete_all
  end
end
