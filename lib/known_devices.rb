module KnownDevices
	KNOWN_DEVICES = {:lamp_01 => {:identification => "lamp_01", :query_state => "state_lamp_01", :name => I18n.t(:name, :scope => [:device, :known, :lamp_01])}}

	def default_name		
		if !identification.blank? and KNOWN_DEVICES.key? identification.to_sym
			KNOWN_DEVICES[identification.to_sym][:name]
		else
			nil
		end
	end
end