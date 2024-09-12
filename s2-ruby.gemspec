require_relative "lib/s2/version"

Gem::Specification.new do |spec|
  spec.name = "s2-ruby"
  spec.version = S2::VERSION
  spec.authors = ["Bob Forma", "Martijn Versluis"]
  spec.email = ["bforma@users.noreply.github.com", "martijnversluis@users.noreply.github.com"]

  spec.summary = "Ruby gem for parsing or generating S2 messages"
  spec.homepage = "https://github.com/stekker/alliander-poc"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/stekker/alliander-poc"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.add_dependency "dry-struct", "~> 1.6"
  spec.add_dependency "dry-types", "~> 1.7", ">= 1.7.2"
end
