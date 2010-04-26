module DevicesHelper
	
	def text_field_for_device(form, field, options = {})
		options[:disabled] = disable_fields? form, field
		form.text_field field, options		
	end

	def disable_fields?(form, field)
		other_field = ""
		case field.to_s
			when "identification"
				other_field = "query_state"
			when "query_state"
				other_field = "identification"
		end
		return false if form.object.try(field.to_sym).blank? or form.object.try(other_field.to_sym).blank? or
			form.object.try("#{field.to_sym}_was") != form.object.try(field.to_sym) or
			form.object.try("#{other_field.to_sym}_was") != form.object.try(other_field.to_sym)
		
		true
	end
end
