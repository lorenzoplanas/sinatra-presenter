# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra-presenter}
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lorenzo Planas"]
  s.date = %q{2010-08-01}
  s.description = %q{It really is a view replacement for Sinatra using the presenter pattern}
  s.email = %q{lorenzo.planas@gmail.com}
  s.files = [
    "Rakefile",
     "VERSION",
     "lib/sinatra_presenter.rb",
     "lib/sinatra_presenter/.pretty_helper.rb.swp",
     "lib/sinatra_presenter/form_helper.rb",
     "lib/sinatra_presenter/pretty_helper.rb",
     "lib/sinatra_presenter/request_helper.rb",
     "lib/sinatra_presenter/tag_helper.rb",
     "pkg/sinatra-presenter-0.0.4.gem",
     "pkg/sinatra-presenter-0.0.5.gem",
     "sinatra-presenter.gemspec"
  ]
  s.homepage = %q{http://github.com/lplanas/sinatra-presenter}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{View replacement for Sinatra using the presenter pattern}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

