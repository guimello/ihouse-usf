module KnownDevices
	KNOWN_DEVICES = {
																	:lamp =>
																		{
																			:device_class => "lamp",
																			:query_state => "state_lamp",
																			:name => I18n.t(:name, :scope => [:device, :known, :lamp]),
																			:display_icon => "lights"
																		},
																	:fan =>
																		{
																			:device_class => "fan",
																			:query_state => "state_fan",
																			:name => I18n.t(:name, :scope => [:device, :known, :fan]),
																			:display_icon => "fan"
																		},
																	:tv =>
																		{
																			:device_class => "tv",
																			:query_state => "state_tv",
																			:name => I18n.t(:name, :scope => [:device, :known, :tv]),
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