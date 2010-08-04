# encoding: UTF-8
require 'i18n'
module Sinatra
  module Presenter
    module FormHelper
      protected
      def t(*args)
        I18n::t(*args)
      end

      def form(options={})
        options = {:method => 'post'}.merge!(options)
        content_tag :form, options do
          tag(:input, :type => 'hidden', :name => '_method', :value => options.delete(:_method)) if options[:_method].present?
          yield if block_given?
        end
      end

      def form_options
        case req[:action]
          when :new, :create           then {:action => route_for(rsc, :index),             :_method => 'post'}
          when :edit, :update, :show   then {:action => route_for(rsc, :show),              :_method => 'put'}
          when :search                 then {:action => "#{route_for(rsc, :index)}/search", :_method => 'post'}
          else                              {}
        end
      end

      def errors
        content_tag :ul, :class => 'errors' do
          content_tag :li, t("form_errors"), :class => 'title'
          rsc.errors.each_pair do |field, msgs|
            msgs.each do |msg|
              content_tag :li, :class => 'error' do
                content_tag :span, t("#{req[:handler]}.#{field}"), :class => 'field'
                content_tag :span, msg, :class => 'message'
              end
            end
          end
        end
      end

      def bracket_fields_for(options = {})
        singular = rsc.class.to_s.downcase
        plural = singular.pluralize
        if options[:nested]
          options.merge!({:label => t("#{options[:nested].pluralize}.#{options[:name]}")})
          if options[:nested] == options[:nested].pluralize
            if embedded = rsc.send(options[:nested].to_sym) && embedded.present? && embedded[options[:index]].present?
              options = {:value => rsc.send(options[:nested].to_sym)[options[:index]].send(options[:name])}.merge! options 
            end
            options.merge!({:name => "#{singular}[#{options.delete(:nested)}_attributes][#{options.delete(:index)}][#{options[:name]}]"})
          else
            options = ({:value => rsc.send(options[:nested].to_sym).send(options[:name])}).merge! options
            options.merge!({:name => "#{singular}[#{options.delete(:nested)}_attributes][#{options[:name]}]"})
          end
        else
          options = ({:value => rsc.send(options[:name])}).merge! options
          options.merge!({:label => t("#{plural}.#{options[:name]}"), :name => "#{singular}[#{options[:name]}]"})
        end
      end

      def label(content = nil, options={})
        (content.present?) && (content.is_a? Hash) ? (content, options = nil, content) : nil
        content_tag :label, (content.is_a?(String) ? content.to_s.capitalize : nil), options
      end

      def input(options={})
        options = bracket_fields_for options unless options.delete(:plain)
        label options.delete(:label), options
        tag :input, options.merge!({:type => 'text'}) 
      end

      def password(options={})
        options = bracket_fields_for options unless options.delete(:plain)
        label options.delete(:label), options
        tag :input, options.merge!({:type => 'password'})
      end

      def hidden(options={})
        options = bracket_fields_for options unless options.delete(:plain)
        label options.delete(:label), options.merge({:class => "#{options[:class]} hidden"})
        tag :input, options.merge!({:type => 'hidden'})
      end

      def button(options={})
        label options.delete(:label), options
        options = bracket_fields_for options unless options.delete(:plain)
        content_tag :button, options.delete(:name), options
      end

      def select(options={})
        options = bracket_fields_for options unless options.delete(:plain)
        label options.delete(:label), options
        content_tag :select, options_for_select(options[:options], options[:selected]), options
      end

      def textarea(options={})
        options = bracket_fields_for({:rows => 6, :cols => 40}.merge!(options)) unless options.delete(:plain)
        label options.delete(:label), options
        content_tag :textarea, options.delete(:value), options
      end

      def checkbox(options={})
        options[:name].delete! '?'
        options = bracket_fields_for options unless options.delete(:plain)
        label options.delete(:label), options
        tag :input, options.merge!({:type => 'checkbox'})
      end

      def radio(options={})
        options = bracket_fields_for options unless options.delete(:plain)
        label options.delete(:label), options
        tag :input, options.merge!({:type => 'radio'})
      end

      def submit(options = {})
        options[:value] = I18n::t("buttons.#{options[:value]}") if options[:value].present?
        tag :input, options.merge!({:type => 'submit'})
      end

      def options_for_select(container, selected = nil)
        return container if String === container
        container = container.to_a if Hash === container
        selected = selected.id if selected.present? && selected.respond_to?(:save)
        selected, disabled = extract_selected_and_disabled(selected)
 
        options_for_select = container.inject([]) do |options, element|
          text, value = option_text_and_value(element)
          selected_attribute = ' selected="selected"' if option_value_selected?(value, selected)
          disabled_attribute = ' disabled="disabled"' if disabled && option_value_selected?(value, disabled)
          options << %(<option value="#{ value.to_s}"#{selected_attribute}#{disabled_attribute}>#{ (text.to_s)}</option>)
        end
        options_for_select.join("\n")
      end

      def extract_selected_and_disabled(selected)
        if selected.is_a?(Hash)
          [selected[:selected], selected[:disabled]]
        else
          [selected, nil]
        end
      end

      def option_value_selected?(value, selected)
        if selected.respond_to?(:include?) && !selected.is_a?(String)
          selected.include? value
        else
          value == selected
        end
      end

      def option_text_and_value(option)
        # Options are [text, value] pairs or strings used for both.
        if !option.is_a?(String) and option.respond_to?(:first) and option.respond_to?(:last)
          [option.first, option.last]
        else
          [option, option]
        end
      end
    end # FormHelper
  end # HtmlHelper
end # Qsupport
