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

	def awesome_button(label, icon, html_options = {})
		html_options[:class] ||= "green"
		html_options[:class] = "awesome #{html_options[:class]}"
		html_options[:href] ||= "#"
		icon = (icon.blank?) ? :tick : icon

		content_tag(:a, html_options) do
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
        when :password
          if form
            html << form.password_field(field.to_sym, field_options)
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

	def text_field_for(object, field, options = {})
    if object.kind_of? ActionView::Helpers::FormBuilder
      basic_form_text_field(object.object, field, {:translation_scope => [object.object.class.to_s.downcase, field.to_sym], :form => object}.merge(options))
    else
      basic_form_text_field(object, field, {:translation_scope => [object.class.to_s.downcase, field.to_sym]}.merge(options))
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

	def icon_for_device(device, tag = :span, options = {})
		options[:class] ||= ""
		options[:class] = "icon #{device.display_icon} #{options[:class]}"

		content_tag tag, nil, options
	end

	def required_fields_help
		html = Builder::XmlMarkup.new

		html.p :class => "title lightest rounded-4" do
			html << I18n.t(:label, :scope => [:application, :required_fields_help])
		end

		html.p do
			html << I18n.t(:hint, :scope => [:application, :required_fields_help], :icon => "<span class='icon required'></span>")
		end
	end

	def action_control(actions)		
		actions = [actions] if actions.is_a?(Action)
		return nil if actions.empty?

		handle_options = get_action_handle_options(actions.first)
		options = handle_options.merge({:class => "center", :style => ";text-align: center"}) {|key, old, new| old + " " + new}

		html = Builder::XmlMarkup.new

		all_actions = []
		separation = 6
		(0..actions.size).step(separation) do |i|
			all_actions.push actions[i...i+separation]
		end

		all_actions.each do |loop_actions|
			html.div :style => "text-align: center" do
				html.table :class => "actions-table" do
					html.thead do
						html.tr do
							loop_actions.each do |action|
								html.th :id => "amount_#{action.id}" do
									html << "0"
								end
							end
						end
					end

					html.tfoot do
						html.tr do
							loop_actions.each do |action|
								html.td do
									html << action.to_s.humanize
								end
							end
						end
					end

					html.tbody do
						html.tr do
							loop_actions.each do |action|
								id = "handle_#{action.id}"
								html.td :class => "center" do
									html.div options.merge(:id => id) do
										html << ""
									end
								end

								html << render(:partial => "actions/handle_js", :locals => {:handle_class => handle_options[:class],
																																:action => action, :id => id, :amount => "amount_#{action.id}"})
							end
						end
					end
				end
			end
		end

		html.div :class => "clear" do
			html << ""
		end
		
		
#		actions.each_with_index do |action, index|
#			id = "#{action.action_type}_#{index}"
#			html.div :class => "float-left" do
#				html.div :class => "amount", :id =>"#{id}_amount" do
#					html << "0"
#				end
#				#html << text_field_tag("", {}, :id => "#{id}_amount", :class => "amount", :style => "background-image: url(); border: 0px")
#				html.div options.merge(:id => id) do
#					html << ""
#				end
#
#				html.div do
#					html << action.to_s.humanize
#				end
#			end
#
#			html << render(:partial => "actions/handle_js", :locals => {:handle_class => handle_options[:class], :action => action, :id => id})
#		end
#
#		html.div :class => "clear" do
#			html << ""
#		end
	end

	def get_action_handle_options(action)
		handle_options = (action.know?) ? action.known_action[:handle] : {}
		case action.action_type
			when Action::ActionTypes::TURN_ON_OFF
				handle_options[:class] = "toggle-me space-my-side-20"
			when Action::ActionTypes::RANGE
				handle_options[:class] = "slide-me space-my-side-20"
		end if handle_options.empty?
		handle_options
	end
end
