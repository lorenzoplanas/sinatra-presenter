module Sinatra
  module Presenter
    module RequestHelper
      def route_for(handler_or_resource, action, options={})
        url = [req[:locale]] 
        if handler_or_resource.respond_to? :save
          if handler_or_resource._parent.present?
            url << "#{handler_or_resource._parent.class.to_s.tableize}/#{handler_or_resource._parent.id}" 
          else
            url.concat [req[:parent], req[:pid]] if options.delete(:nested)
          end
          url << handler_or_resource.class.to_s.tableize
          rsc_id = handler_or_resource.id
        else 
          url.concat [req[:parent], req[:pid]] if options.delete(:nested)
          url << handler_or_resource
          rsc_id = options.delete :rsc_id
        end
        case action.to_s
          when 'index'    then nil
          when 'show'     then url << rsc_id
          else                 url.concat [rsc_id, action] 
        end

        if options.present?
          tag_options = []
          options.each_pair { |k, v| tag_options << ["#{k}=#{v}"] }
          url << ("?" + tag_options.join('&'))
        end
        "/#{url.compact.join "/"}"
      end

      def current_user
        req[:current_user]
      end

      def params
        req[:params]
      end

      def flash
        req[:flash]
      end
    end # RequestHelper
  end # Presenter
end # Sinatra
