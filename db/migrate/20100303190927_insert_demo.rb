class InsertDemo < ActiveRecord::Migration
  def self.up
    u = User.create :email => 'guilhermesilvamello@gmail.com', :username => 'guimello', :password => '666'
    h = House.new :name =>'My house (Jundiaí)', :description =>'i live there tks'
    d1 = Device.new :code => '001', :room => 'my bedroom', :query_code => '606'
    v1 = VoiceCommand.new :speak => 'turn the lights on plz'
    a1 = Action.new :code => '555', :action_type => '333'
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
