
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lp/serializable/version"

Gem::Specification.new do |spec|
  spec.name          = "lp-serializable"
  spec.version       = Lp::Serializable::VERSION
  spec.authors       = ["mrjonesbot"]
  spec.email         = ["nate@mrjones.io"]

  spec.summary       = "Serialize with Fast JSON API, flatten like AWS"
  spec.description   = "JSON API(jsonapi.org) serializer wrapper methods that work with Rails and can be used to serialize any kind of ruby object with AMS style output."
  spec.homepage      = "https://www.github.com/launchpadlab/lp-serializable"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency(%q<activerecord>, [">= 4.2"])
  spec.add_development_dependency(%q<active_model_serializers>, ["~> 0.10.7"])
  spec.add_development_dependency(%q<jsonapi-rb>, ["~> 0.5.0"])
  spec.add_development_dependency(%q<sqlite3>, ["~> 1.3"])
  spec.add_development_dependency(%q<jsonapi-serializers>, ["~> 1.0.0"])
  spec.add_development_dependency(%q<oj>, ["~> 3.3"])
  spec.add_development_dependency(%q<rspec-benchmark>, ["~> 0.3.0"])
  spec.add_runtime_dependency(%q<activesupport>, [">= 4.2"])
  spec.add_development_dependency(%q<byebug>, [">= 0"])

  spec.add_dependency "fast_jsonapi", '>= 1.3'
end