# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0] - 2026-02-26

### Changed
- Migrated repo from justi-blue org to justi user account
- Replaced StandardRB with RuboCop + rubocop-rspec + rubocop-rake
- Added bundler-audit security scanning to CI
- Updated CI workflow with separate audit, lint, and test steps
- Cleaned up gemspec (fixed URLs, removed boilerplate)
- Removed .gem build artifacts from repo

### Fixed
- Fixed Gemfile.lock version mismatch causing CI failures
- Fixed duplicate specs and merged repeated describe blocks

## [0.4.3] - 2025-01-01

### Added
- Improved lithuanian_to_polish mappings: 'auskas' → 'owski' for better genealogical transformations (e.g., Jankauskas → Jankowski).

### Fixed
- Corrected README examples to match actual gem outputs (including digraph handling).
- Updated installation instructions.

## [0.4.0] - 2025-01-01

### Added
- Support for additional polonization mappings: 'ak' → 'akas', 'cki' → 'ckis'/'ckas', 'owski' → 'ovicius'
- Polish digraph handling in transliteration: 'sz' → 'š', 'cz' → 'č', 'rz' → 'ž'
- W/V interchange variants for genealogical matching
- Expanded test suite with more FN examples and edge cases
- MFA requirement in gemspec for security

### Changed
- Improved transform_ending to handle multiple overlapping suffixes
- Updated normalize_surname to include original transliterated forms
- Enhanced gemspec metadata for better compliance

## [0.3.0] - 2025-01-01

### Changed
- Require Ruby 3.1+ for compatibility

## [0.2.0] - 2025-01-01

### Added
- Support for Russian transliteration and polonization mappings
- Additional mappings for Lithuanian polonization (onis, aitis)
- License and changelog metadata

### Changed
- Improved normalize_surname to avoid duplicate variants
- Updated README with more examples

## [0.1.0] - 2025-01-01

### Added
- Initial implementation of surname transliteration between Polish and Lithuanian
- Basic polonization/de-polonization mappings
- Gem structure with tests and CI setup