################################################################################
module DevicesHelper

  ################################################################################
  def text_field_for_device(form, field, options = {})
    options[:disabled] = form.object.enable_advanced?(field)
    options[:title] ||= I18n.t(:title, :scope => [:device, field.to_sym])
    options[:class] ||= ""
    options[:class] = "#{options[:class]} title-me"
    form.text_field field, options    
  end
end