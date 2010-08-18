# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'sinatra_presenter'
 
Gem::Specification.new do |s|
  s.name        = "sinatra-presenter"
  s.version     = Sinatra::Presenter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lorenzo Planas"]
  s.email       = ["lplanas@qindio.com"]
  s.homepage    = "http://github.com/lplanas/sinatra-presenter"
  s.summary     = "Sinatra extension implementing the presenter pattern for HTML views."
  s.description = "Includes asset and tag helpers inspired on Ruby on Rails."
 
  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{lib}/**/*")
  s.require_path = 'lib'
end
