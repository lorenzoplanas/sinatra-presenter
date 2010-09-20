# encoding: UTF-8
require 'sinatra/base'
require 'page'

module Sinatra
  module Presenter
    VERSION = "1.0.1"

    module Helpers
      # rsc is an underlying model instance if present. If a collections is passed,
      # rsc is nil and the collection is assigned to a member with this name.
      # After initialization, method is called on the presenter.
      def present(record, method, args={})
        if record.kind_of?(Enumerable) || args[:class].present?
          Object.const_get("#{args.delete(:class)}Presenter").new(nil, args.merge!(:collection => record)).send(method.to_sym)
        else
          Object.const_get("#{record.class}Presenter").new(record, args).send(method.to_sym)
        end
      end
    end
  
    class Base
      include Sinatra::Presenter::Helpers
      attr_reader :rsc, :page

      # All passed options are assigned to members with the same name.
      # @page references the +Page+ instance
      def initialize(rsc, options={})
        @rsc = rsc
        @page = Page.new
        options.each_pair do |option, value| 
          self.class.class_eval { attr_reader option }
          instance_variable_set "@#{option}", value
        end
      end

      # Renders @page content
      def draw(options = {})
        if protected_methods.include?(:layout) && options[:api].blank?
          self.layout # It should call self.page.content
        else
          self.page.content
        end
      end

      protected
  
      def method_missing(method, *args)
        rsc.send(method, *args)
      end
    end # Base
  end # Presenter
  helpers Presenter::Helpers
end # Sinatra
