require_relative "lib/s2/version"

Gem::Specification.new do |spec|
  spec.name = "s2-ruby"
  spec.version = S2::VERSION
  spec.authors = ["Team Stekker"]
  spec.email = ["support@stekker.com"]

  spec.summary = "Ruby implementation of the S2 protocol for smart grid communication"
  spec.description = "S2 is a protocol for communication between energy management systems (CEM) " \
                     "and resource managers (RM) for demand-response and flexible power control."
  spec.homepage = "https://github.com/stekker/s2-ruby"
  spec.license = "Apache-2.0"
  spec.required_ruby_version = ">= 3.3" # rubocop:disable Gemspec/RequiredRubyVersion

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/stekker/s2-ruby"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 7.0"
  spec.add_dependency "async"
  spec.add_dependency "async-websocket"
  spec.add_dependency "dry-struct", "~> 1.6"
  spec.add_dependency "dry-types", "~> 1.7"
end
