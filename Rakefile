# encoding: UTF-8
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "sinatra_presenter"
 
task :build do
  system "gem build sinatra-presenter.gemspec"
end
 
task :release => :build do
  system "gem push qsupport-#{Sinatra::Presenter::VERSION}"
end
