require 'sinatra/base'
require 'i18n'
require 'sinatra_presenter/request_helper'
require 'sinatra_presenter/tag_helper'
require 'sinatra_presenter/form_helper'
require 'sinatra_presenter/pretty_helper'

module Sinatra
  module Presenter
    module Helpers
      def present(record, method, args={})
        method = :"#{method}_for_mobile" if args[:req] && args[:req][:mobile]
        if record.respond_to? :save
          Object.const_get("#{record.class}Presenter").new(record, args).send(method.to_sym)
        else
          Object.const_get("#{args.delete(:class)}Presenter").new(nil, args.merge!(:collection => record)).send(method.to_sym)
        end
      end
    end
  
    class Base
      include Sinatra::Presenter::Helpers
      include Sinatra::Presenter::RequestHelper
      include Sinatra::Presenter::TagHelper
      include Sinatra::Presenter::FormHelper
      include Sinatra::Presenter::PrettyHelper
      #include ApplicationPresenter
      attr_reader :rsc, :page

      def initialize(rsc, options={})
        @rsc = rsc
        options.each_pair do |k,v| 
          self.class.class_eval do 
            attr_reader k
          end
          instance_variable_set "@#{k}", v
        end

        @page ||= Page.new
      end

      protected

      def buf(html)
        self.page.content = self.page.content + html.to_s
        nil
      end

      def t(*args)
        I18n::t(*args)
      end

      def draw(options = {})
        if options[:api]
          self.page.content
        elsif protected_methods.include?(:layout_mobile) && req[:mobile]
          self.layout_mobile
        elsif protected_methods.include? :layout
          self.layout
        end
      end

      def method_missing(method, *args)
        rsc.send(method, *args)
      end
    end # Base

    class Page
      attr_accessor :content

      def initialize
        @content = ""
      end
    end # Page
  end # Presenter
  helpers Presenter::Helpers
end # Sinatra
