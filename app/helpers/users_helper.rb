module UsersHelper
  def locale_select(form)
    form.select :locale, {t(:portuguese, :scope => :locale) => "pt",
                          t(:english, :scope => :locale) => "en"}
  end

  def theme_select(form)
    form.select :style, {t(:blue, :scope => [:user, :style, :colors]) => "blue",
                         t(:green, :scope => [:user, :style, :colors]) => "green",
                         t(:pink, :scope => [:user, :style, :colors]) => "pink",
                         t(:black, :scope => [:user, :style, :colors]) => "black",
                         t(:red, :scope => [:user, :style, :colors]) => "red",
                         t(:darkred, :scope => [:user, :style, :colors]) => "darkred",
                         t(:yellow, :scope => [:user, :style, :colors]) => "yellow",
                         t(:white, :scope => [:user, :style, :colors]) => "white"}
  end
  
  def text_field_for(object, field, options = {})
    if object.kind_of? User
      basic_form_text_field(object, field, {:translation_scope => [:user, field.to_sym]}.merge(options))
    else
      basic_form_text_field(object.object, field, {:translation_scope => [:user, field.to_sym], :form => object}.merge(options))
    end
  end

  def password_field_for(object, field, options = {})
    text_field_for(object, field,{:field_type => :password}.merge(options))
  end

  def text_area_for(object, field, options = {})
    text_field_for(object, field, {:field_type => :text_area}.merge(options))
  end

  def select_for(object, category, field, select_options, options = {})
    text_field_for(object, category, field, {:field_type => :select, :options_for_select => select_options}.merge(options))
  end

  def date_select_for(object, category, field, select_options = {}, options = {})
    text_field_for(object, category, field, {:field_type => :date_select, :options_for_select => select_options}.merge(options))
  end
end
