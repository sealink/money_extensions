# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'money_extensions/version'

Gem::Specification.new do |spec|
  spec.name          = 'money_extensions'
  spec.version       = MoneyExtensions::VERSION
  spec.authors       = ["Michael Noack", "Alessandro Berardi"]
  spec.email         = 'support@travellink.com.au'
  spec.description   = "These are extensions from the money/currency classes."
  spec.summary       = "Set of extensions to the money gem used by TravelLink Technology."
  spec.homepage      = 'http://github.com/sealink/money_extensions'

  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'money', '>= 6.0.0'
  spec.add_dependency 'activesupport', '>= 6'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coverage-kit'
  spec.add_development_dependency 'simplecov-rcov'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'pry-byebug'
end
