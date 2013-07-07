# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'in_business/version'

Gem::Specification.new do |spec|
  spec.name          = "in_business"
  spec.version       = InBusiness::VERSION
  spec.summary       = %Q{Support for checking whether a given DateTime, Date or Time is within a predefined set of opening hours}
  spec.authors       = ["Tim Rogers"]
  spec.email         = ["tim@gocardless.com"]
  spec.description   = %q{Support for checking whether a given DateTime, Date or Time is within a predefined set of opening hours}
  spec.homepage      = "https://github.com/timrogers/in_business"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", '~> 2.14.0'
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "activesupport", '~> 4.0.0'
end
