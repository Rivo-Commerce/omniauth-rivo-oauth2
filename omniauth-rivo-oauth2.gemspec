require_relative "lib/omniauth/rivo/oauth2/version"

Gem::Specification.new do |spec|
  spec.name = "omniauth-rivo-oauth2"
  spec.version = OmniAuth::Rivo::OAuth2::VERSION
  spec.authors = ["Rivo Commerce"]
  spec.email = ["developers@rivo.io"]

  spec.summary = "Rivo OAuth 2 strategy for OmniAuth"
  spec.homepage = "https://github.com/Rivo-Commerce/omniauth-rivo-oauth2"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.metadata["source_code_uri"]}/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.metadata["source_code_uri"]}/issues"

  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_runtime_dependency "omniauth-oauth2", "~> 1.8"
  spec.add_runtime_dependency "oauth2", ">= 2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
