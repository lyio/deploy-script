# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fio/deploy/version'

Gem::Specification.new do |spec|
  spec.name          = "fio-deploy"
  spec.version       = Fio::Deploy::VERSION
  spec.authors       = ["Thomas Fiedler"]
  spec.email         = ["t.fiedler@fio.de"]

  spec.summary       = %q{Internal continuous deployment script for fio-vermarktung}
  spec.description   = %q{Copies a specified folder of build output to a folder of a samba share.}
  spec.homepage      = "http://10.8.0.102/fio/scripts/"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    #raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = 'fio-deploy.rb' #spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
end
