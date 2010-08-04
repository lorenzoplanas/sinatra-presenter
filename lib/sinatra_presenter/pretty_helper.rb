# encoding: UTF-8
require 'json'
require 'net/http'
module Sinatra
  module Presenter
    module PrettyHelper
      %w{ h1 h2 h3 h4 h5 div span ul li table tr th td}.each do |html_tag|
        method_body = Proc.new do |*args, &block|
          if block.present?
            content_tag html_tag, args, &block
          else
            content_tag html_tag, args[0], args[1]
          end
        end
        define_method(html_tag, method_body) 
      end

      def crumbs
        crumbs, html = [req[:parent], (rsc.present? ? rsc._parent : rsc), req[:handler], rsc], []
        crumbs.each_index do |i|
          if crumbs[i].present? && crumbs[i].respond_to?(:save)
            html << link_to(crumbs[i].name, route_for(crumbs[i], :show)) if rsc.name.present?
          elsif crumbs[i].present?
            html << link_to(t.tabs[crumbs[i]].capitalize, "/#{crumbs[0..i].compact.join('/')}")
          end
        end
        html << t.actions[req[:action]].capitalize unless [:index, :show, :events, :event].include? req[:action]
        "<h1 class='crumbs'>#{html.join(' > ')}</h1>"
      end
    
      def bricks
        content_tag :ul, :class => 'bricks' do collection.map {|i| present(i, :brick, :req => req, :page => page)}; nil end
      end

      protected

      def abbr(str = '')
        str.length > 15 ? str[0..11] + '...' : str
      end
      
      def brick(options={})
        options = {:link => true}.merge! options
        content_tag :li, "<span>#{options[:link] ? link_to(rsc.name, rsc) : rsc.name}</span> #{delete_link}", :class => 'brick rounded'
      end

      def brickify(name, route)
        content_tag :li, :class => 'brick rounded' do
          content_tag :span, name
          link_to "", route, :class => 'delete'
        end
      end

      def stickify(text, color)
        content_tag :span, text, :class => "sticker rounded #{color}"
      end

      def delete_link
        link_to "", route_for(rsc, :delete), :class => "delete"
      end

      def localtime(datetime)
        TZInfo::Timezone.get('Europe/Madrid').utc_to_local(datetime)
      end

      def created_at
        localtime(rsc.created_at).strftime("%d-%m-%Y %H:%M")
      end

      def updated_at
        localtime(rsc.updated_at).strftime("%d-%m-%Y %H:%M")
      end

      def render_chart(chart, options={})
        if params[:charts] == 'static'
          host, port, path = '10.211.55.6', '9292', '/chart/bar.json'
          req = Net::HTTP::Post.new(path, initheader = {'Content-Type' =>'application/json'})
          req.body = chart.to_json
          response = Net::HTTP.new(host, port).start {|http| http.request(req) }
          tag :img, :src => JSON.parse(response.body)['chart_url'], :id => options[:id]
        else
          content_tag :div, :id => options[:id], :class => "#{chart['kind']} chart" do
            content_tag :p, chart['title'], :class => 'title'
            content_tag :table do
              content_tag :tr do chart['labels'].values.each { |label| content_tag :th, label, :class => :legend }; nil end
              content_tag :tr do chart['data'].last.each { |datum| content_tag :td, datum, :class => :datum }; nil end
            end
          end
        end
      end
    end # PrettyHelper
  end # Presenter
end # Sinatra
