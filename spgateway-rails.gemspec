$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spgateway/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spgateway-rails"
  s.version     = Spgateway::Rails::VERSION
  s.authors     = ["zetavg"]
  s.email       = ["mail@zeta.vg"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Spgateway::Rails."
  s.description = "TODO: Description of Spgateway::Rails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.0"
end
