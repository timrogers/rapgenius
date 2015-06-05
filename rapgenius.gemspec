# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rapgenius/version"

Gem::Specification.new do |s|
  s.name        = "rapgenius"
  s.version     = RapGenius::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tim Rogers"]
  s.email       = ["me@timrogers.co.uk"]
  s.homepage    = "https://github.com/timrogers/rapgenius"
  s.summary     = %q{A gem for accessing texts and explanations on Genius.com}

  s.add_runtime_dependency "httparty",    "~>0.11.0"
  s.add_development_dependency "rspec",   "~>2.14.1"
  s.add_development_dependency "mocha",   "~>0.14.0"
  s.add_development_dependency "webmock", "~>1.11.0"
  s.add_development_dependency "vcr",     "~>2.5.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.license       = 'MIT'
end
