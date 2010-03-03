# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def title(description)
    content_for :title do
      description
    end
  end

  def project_title
    if @project and !@project.name.nil?
      return @project.name
    end
  end

  def generate_html(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :form

    form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|
      locals = { options[:form_builder_local] => f }
      render(:partial => options[:partial], :locals => locals)
    end
  end

  def generate_template(form_builder, method, options = {})
    escape_javascript generate_html(form_builder, method, options)
  end

  def awesome_submit_button(label, icon = "", html_options = {})
    if html_options[:class].nil?
      html_options[:class] = "awesome silver green"
    else
      html_options[:class] = "awesome #{html_options[:class]}"
    end

    content_tag(:button, {:type => "submit"}.merge(html_options)) do
      content_tag(:span, :class => "icon #{icon}") { label }
    end
  end

  def permitted_to?(action, controller)
    return current_user.permissions.first(:conditions => {:project_id => @project.id}).role.rights.first(:conditions => {:action => action, :controller => controller})
  end

  def basic_form_text_field(model, field, options = {})
    translation_scope = options[:translation_scope] || [model.class.name.downcase.to_sym, field.to_sym]
    form              = options[:form] || nil
    field_type        = options[:field_type] || :text_field
    select_options    = options[:options_for_select]
    show_hint         = options[:show_hint] || false
    required          = options[:required] ? "required" : ""
    show_if_blank     = options[:show_if_blank] || false
    add_to_hint       = options[:add_to_hint] || "";

    field_options     = options[:field] || {}
    list_options = options[:list_options] || {}

    if model.try(field.to_sym).blank?
      unless form
        return unless show_if_blank
      end
    end

    html = Builder::XmlMarkup.new

    html.dt list_options do
      if form
        html << form.label(field.to_sym, t(:label, :scope => translation_scope), :class => required)
      else
        html << t(:label, :scope => translation_scope)
      end
    end

    if show_hint and form
      hint_list_options = list_options.merge({})
      hint_list_options[:class] = "hint #{hint_list_options[:class]}"

      html.dd hint_list_options do
        if add_to_hint
          html << add_to_hint
        end
        html << t(:hint, :scope => translation_scope)
      end
    end

    html.dd list_options do
      case field_type
        when :text_field
          if form
            html << form.text_field(field.to_sym, field_options)
          else
            html << h(model.try(field.to_sym))
          end
        when :text_area
          if form
            html << form.text_area(field.to_sym, {:rows => 5}.merge(field_options))
          else
            html << simple_format(model.try(field.to_sym))
          end
        when :select
          if form
            html << form.select(field.to_sym, options_for_select(select_options, form.object.send(field.to_sym)), field_options)
          else
            html << h(t(model.try(field.to_sym).underscore.to_sym, :scope => [:enums, field.to_s.pluralize.to_sym]))
          end
        when :date_select
          if form
            html << form.date_select(field.to_sym, field_options, select_options)
          else
            html << l(model.try(field.to_sym), :format => :long)
          end
      end
    end
  end

  def basic_form_text_area(model, field, options = {})
    basic_form_text_field(model, field, {:field_type => :text_area}.merge(options))
  end

  def basic_form_select(model, field, options = {})
    basic_form_text_field(model, field, {:field_type => :select}.merge(options))
  end
end
