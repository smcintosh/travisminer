# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'travisminer/version'

Gem::Specification.new do |gem|
  gem.name          = "travisminer"
  gem.version       = TravisMiner::VERSION
  gem.authors       = ["Shane McIntosh"]
  gem.email         = ["shanemcintosh@acm.org"]
  gem.description   = %q{Data extraction and mining scripts for Travis CI data}
  gem.summary       = %q{Extract Travis CI data through RESTful web services and put into data mining formats}
  gem.homepage      = "https://github.com/smcintosh/travisminer"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
