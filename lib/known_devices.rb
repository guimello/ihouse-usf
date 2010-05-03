module KnownDevices
	KNOWN_DEVICES = {
																	:lamp_01 =>
																		{
																			:device_class => "lamp_01",
																			:query_state => "state_lamp_01",
																			:name => I18n.t(:name, :scope => [:device, :known, :lamp_01]),
																			:display_icon => "lights"
																		},
																	:fan_01 =>
																		{
																			:device_class => "fan_01",
																			:query_state => "state_fan_01",
																			:name => I18n.t(:name, :scope => [:device, :known, :fan_01]),
																			:display_icon => "fan"
																		},
																	:tv_01 =>
																		{
																			:device_class => "tv_01",
																			:query_state => "state_tv_01",
																			:name => I18n.t(:name, :scope => [:device, :known, :tv_01]),
																			:display_icon => "television"
																		}
																			}

	def know_this?
		!device_class.blank? and KNOWN_DEVICES.key? device_class.to_sym
	end
	
	def default_name		
		return KNOWN_DEVICES[device_class.to_sym][:name] if know_this?
		nil
	end

	def display_icon
		return KNOWN_DEVICES[device_class.to_sym][:display_icon] if know_this?
		"unkown-device"
	end
end