# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_db/version'

Gem::Specification.new do |gem|
  gem.name          = "hash_db"
  gem.version       = HashDB::VERSION
  gem.authors       = ["Utkarsh Kukreti"]
  gem.email         = ["utkarshkukreti@gmail.com"]
  gem.description   = "A minimal, in-memory, ActiveRecord like database, " +
                      "backed by a Ruby Hash."
  gem.summary       = gem.description
  gem.homepage      = "http://utkarshkukreti.github.com/hash_db"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  %w{rake rspec guard-rspec}.each do |name|
    gem.add_development_dependency name
  end
end
