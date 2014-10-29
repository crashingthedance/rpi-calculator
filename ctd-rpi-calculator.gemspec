# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crashing_the_dance/rpi_calculator/version'

Gem::Specification.new do |spec|
  spec.name          = "ctd-rpi-calculator"
  spec.version       = CrashingTheDance::RpiCalculator::VERSION
  spec.authors       = ["Andy Cox"]
  spec.email         = ["andy@crashingthedance.com"]
  spec.summary       = %q{On your computer, calculatin' your RPI.}
  spec.description   = %q{}
  spec.homepage      = "http://crashingthedance.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.99"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
end
