$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
MODELS = File.join(File.dirname(__FILE__), "../models")
$LOAD_PATH.unshift(MODELS)

require 'mongoid'
require 'rspec'
require 'sinatra_presenter'
#Dir[ File.join(MODELS, "*.rb") ].sort.each { |file| require File.basename(file) }

Mongoid.configure do |config| 
  config.master = Mongo::Connection.new.db('sinatra_presenter_testing') 
end 

Rspec.configure do |config|
  config.after :suite do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end

class Doc
  include Mongoid::Document
  field :name
end

class DocPresenter < Sinatra::Presenter::Base
end
