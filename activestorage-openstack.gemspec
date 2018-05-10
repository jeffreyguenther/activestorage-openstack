# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_storage/openstack/version"

Gem::Specification.new do |spec|
  spec.name          = "activestorage-openstack"
  spec.version       = ActiveStorage::Openstack::VERSION
  spec.authors       = ["Jeffrey Guenther"]
  spec.email         = ["guenther.jeffrey@gmail.com"]

  spec.summary       = %q{ActiveStorage support for OpenStack storage}
  spec.description   = %q{Provides a Service to allow ActiveStorage to be used with OpenStack services}
  spec.homepage      = "https://github.com/jeffreyguenther/activestorage-openstack"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "activestorage", "~> 5.2.0.beta2"
  spec.add_dependency "fog-openstack"
  spec.add_dependency "mime-types"

  spec.add_development_dependency "rails", "~> 5.2.0"
  spec.add_development_dependency "sqlite3"
end
