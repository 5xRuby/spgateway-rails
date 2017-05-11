$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spgateway/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spgateway-rails"
  s.version     = Spgateway::VERSION
  s.authors     = ["zetavg"]
  s.email       = ["mail@zeta.vg"]
  # s.homepage    = "TODO"
  s.summary     = "API wrapper for www.spgateway.com."
  # s.description = "TODO: Description of Spgateway."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.0", "< 5.2"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "appraisal"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "coveralls"
end
