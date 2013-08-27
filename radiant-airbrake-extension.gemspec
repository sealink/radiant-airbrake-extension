# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'radiant-airbrake-extension/version'

Gem::Specification.new do |spec|
  spec.name          = 'radiant-airbrake-extension'
  spec.version       = RadiantAirbrakeExtension::VERSION
  spec.authors       = ['Michael Noack', 'Michael Smirnoff']
  spec.email         = ['support@travellink.com.au']
  spec.summary       = 'Extension to handle server-side/client-side integration of Airbrake/Hoptoad.'
  spec.description   = 'See README for full details on how to install, use, etc.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'airbrake'
  spec.add_dependency 'radius'
  spec.add_dependency 'radiant_extension_helper'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
