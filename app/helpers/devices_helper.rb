module DevicesHelper
	
	def text_field_for_device(form, field, options = {})
		options[:disabled] = disable_fields? form, field
		options[:title] ||= I18n.t(:title, :scope => [:device, field.to_sym])
		options[:class] ||= ""
		options[:class] = "#{options[:class]} title-me"
		form.text_field field, options		
	end

	def disable_fields?(form, field)
		other_field = ""
		case field.to_s
			when "identification"
				other_field = "query_state"
			when "query_state"
				other_field = "identification"
			else
				return false
		end
		return false if form.object.try(field.to_sym).blank? or form.object.try(other_field.to_sym).blank? or
			form.object.try("#{field.to_sym}_was") != form.object.try(field.to_sym) or
			form.object.try("#{other_field.to_sym}_was") != form.object.try(other_field.to_sym)
		
		true
	end
end
