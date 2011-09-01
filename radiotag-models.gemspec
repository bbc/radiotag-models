# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{radiotag-models}
  s.version = "0.1.5"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Lowis", "Sean O'Halpin"]
  s.date = %q{2011-05-25}
  s.description = <<-EOT
DataMapper models to be used in the various RadioTAG applications
EOT
  s.email = %q{chris.lowis@bbc.co.uk}
  s.files = Dir["lib/**"] + Dir["config/**"]
  s.has_rdoc = false
  s.homepage = %q{}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{radiotag-models}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{DataMapper models for the RadioTAG suite of applications}

  s.add_dependency "data_mapper"
  s.add_dependency "dm-sqlite-adapter"
  s.add_dependency "dm-mysql-adapter"
  s.add_dependency "json"
  s.add_dependency "bbc_service_map"

  s.add_development_dependency "shoulda"
  s.add_development_dependency "mocha"
  s.add_development_dependency "rake"
end
