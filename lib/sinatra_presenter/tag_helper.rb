module Sinatra
  module Presenter
    module TagHelper
      protected

      def content_tag(tag, content_or_options_with_block = nil, options = nil, &block)
        html_attrs = [] 
        if block_given?
          options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
          options.each_pair { |k, v| html_attrs << " #{k}='#{v}'"} if options.present?
          buf "<#{tag} #{html_attrs.join(' ')}>"
          (html = yield if block_given?) ? (buf(html) if html.kind_of?(String)) : nil
          buf "</#{tag}>"
        else
          options.each_pair { |k, v| html_attrs << " #{k}='#{v}'"} if options.present?
          buf "<#{tag} #{html_attrs.join(' ')}>#{content_or_options_with_block}</#{tag}>"
        end
      end

      def tag(tag, options={})
        html_attrs = []
        options.each_pair { |k, v| html_attrs << "#{k}='#{v}'"}
        buf "<#{tag} #{html_attrs.join(' ')} />"
      end

      def link_to(*args)
        name         = args.first
        href_attr    = args.second || {}
        options      = args.third
        tag_options  = []

        if href_attr.kind_of?(Array) && href.attr.first.respond_to?(:save)
          href_attr = route_for(href_attr.first, :index)
        elsif href_attr.respond_to?(:save)
          href_attr = route_for(href_attr, :show)
        end

        options.each_pair { |k, v| tag_options << "#{k}='#{v}'" } if options.present?
        "<a href='#{href_attr}' #{tag_options.join(' ')}>#{name}</a>"
      end
    end # TagHelper
  end # Presenter
end # Sinatra
