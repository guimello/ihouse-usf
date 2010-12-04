################################################################################
class InsertKnownActions < ActiveRecord::Migration
  
  ################################################################################
  def self.up
    KnownAction.transaction do
      KnownAction.create  :command => 1,
                                    :action_type => ActionTypes::TURN_ON_OFF,
                                    :query_state => 1,
                                    :handle => {  :jquery_method => 'jquery_checkbox_button',
                                                  :translation_keys => {:state_on => 'state_on', :state_off => 'state_off'},
                                                  :display_icon_on => 'lights-on',
                                                  :display_icon_off => 'lights-off'
                                               }

      KnownAction.create  :command => 2,
                                    :action_type => ActionTypes::RANGE,
                                    :query_state => 2,
                                    :handle => {  :html_options_for_jquery_div => {:style => 'height: 200px;'},
                                                  :orientation => 'vertical',
                                                  :range_min => 1,
                                                  :range_max => 100
                                               }

      KnownAction.create  :command => 3,
                                    :action_type => ActionTypes::RANGE,
                                    :query_state => 3,
                                    :handle => {  :html_options_for_jquery_div => {:style => 'width: 200px;'},
                                                  :orientation => 'horizontal',
                                                  :range_min => 0,
                                                  :range_max => 30
                                               }

      KnownAction.create  :command => 4,
                                    :action_type => ActionTypes::RANGE,
                                    :query_state => 4,
                                    :handle => {  :html_options_for_jquery_div => {:style => 'height: 200px;'},
                                                  :orientation => 'vertical',
                                                  :range_min => 5,
                                                  :range_max => 44
                                               }

      KnownAction.create  :command => 5,
                                    :action_type => ActionTypes::RANGE,
                                    :query_state => 5,
                                    :handle => {  :html_options_for_jquery_div => {:style => 'height: 200px;'},
                                                  :orientation => 'vertical',
                                                  :range_min => 0,
                                                  :range_max => 255
                                               }
    end
  end

  ################################################################################
  def self.down
    KnownAction.delete_all
  end
end