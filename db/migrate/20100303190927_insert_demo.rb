class InsertDemo < ActiveRecord::Migration
  def self.up
    u = User.create :email => 'guilhermesilvamello@gmail.com', :username => 'guimello', :password => '666'
    h = House.new :name =>'My house (Jundiaí)', :description =>'i live there tks'
    d1 = Device.new :identification => 'lamp', :room => 'my bedroom', :query_state => 'state'
    v1 = VoiceCommand.new :speak => 'turn the lights on plz'
    a1 = Action.new :command => '1', :action_type => 'on'
    s = Schedule.new
    a1.voice_command = v1
    a1.schedules << s
    d1.actions << a1
    h.devices << d1
    u.houses << h
    u.save
  end

  def self.down
  end
end
