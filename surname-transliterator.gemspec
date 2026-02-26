# frozen_string_literal: true

require_relative "lib/surname/transliterator/version"

Gem::Specification.new do |spec|
  spec.name = "surname-transliterator"
  spec.version = Surname::Transliterator::VERSION
  spec.authors = ["Justyna"]
  spec.email = ["justine84@gmail.com"]

  spec.summary = "Cross-language surname transliteration and polonization"
  spec.description = "Ruby gem for cross-language surname transliteration and " \
                     "polonization/de-polonization of endings. Supports Polish, " \
                     "Lithuanian, Russian. Useful for reducing false positives " \
                     "in genealogical data matching."
  spec.homepage = "https://github.com/justi/surname-transliterator"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "#{spec.homepage}/tree/main"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end

  spec.require_paths = ["lib"]
end
