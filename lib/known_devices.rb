module KnownDevices

	def self.included(klass)
		klass.class_eval do
			def know?				
				!device_class.blank? and KnownDevice.exists? :device_class => device_class
			end

			def default_name				
				return known_device.name if know?
				nil
			end

			def default_display_icon
				return known_device.display_icon if know?
				"unkown-device"
			end

			def display_icon				
				if !custom.display_icon.blank?
					custom.display_icon
				elsif	know?
					known_device.display_icon
				else
					"unkown-device"
				end
			end

			def self.known_devices				
				KnownDevice.all
			end

			def known_device
				KnownDevice.find_by_device_class(device_class)
			end
		end
	end
end