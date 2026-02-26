# Surname::Transliterator

A Ruby gem for cross-language surname transliteration and transformation, based on genealogical rules. Supports transliteration (removing diacritics/Cyrillic) and polonization/de-polonization endings between languages like Polish-Lithuanian, Polish-Russian. Extensible for more pairs. Useful for reducing false positives in genealogical matching.

Features:
- Transliterate surnames (remove diacritics/Cyrillic, handle Polish digraphs like sz/č/cz/rz).
- Transform endings between languages (polonization/de-polonization based on genealogical rules).
- Generate W/V interchange variants for better genealogical matching.
- Support for Polish ↔ Lithuanian, Polish ↔ Russian transformations (asymmetric).

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add surname-transliterator
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install surname-transliterator
```

## Usage

```ruby
require 'surname/transliterator'

# Convenience methods
polish_to_lith = Surname::Transliterator.polish_to_lithuanian("Łukasiewicz")
# => ["Lukasiewič"] (transliterated with Polish digraphs)

polish_to_lith2 = Surname::Transliterator.polish_to_lithuanian("Antonowicz")
# => ["Antonavičius", "Antonowič"] (transliterated + transformed)

lith_to_polish = Surname::Transliterator.lithuanian_to_polish("Jankauskas")
# => ["Jankowski", "Jankauskas"] (transformed + transliterated)

polish_to_russian = Surname::Transliterator.polish_to_russian("Kowalski")
# => ["Kowalski", "Kowalskii"]

russian_to_polish = Surname::Transliterator.russian_to_polish("Иванов")
# => ["Ivanov"]

# General cross-language normalization (includes W/V interchange for genealogical matching)
variants = Surname::Transliterator.normalize_surname("Wiszniewski", 'polish', 'lithuanian')
# => ["Wišnievskis", "Wišnievskas", "Wišniewski", "Višnievskis", "Višnievskas", "Višniewski"] (transformed + W/V)

# Just transliterate (remove diacritics/Cyrillic)
clean_polish = Surname::Transliterator.transliterate("Świętochowski", 'polish')
# => "Swietochowski"

clean_russian = Surname::Transliterator.transliterate("Иванов", 'russian')
# => "Ivanov"
```

## Important Notes

- **Asymmetric Transformations**: Translations between languages are not symmetric due to historical genealogical adaptations. For example, Polish -owicz may become Lithuanian -avičius, but reversing it doesn't always restore -owicz exactly. Use `polish_to_lithuanian` and `lithuanian_to_polish` as separate methods with their own mappings.

## Supported Languages and Pairs

The gem supports transliteration and transformation for the following languages:

- **Polish**: Full transliteration (diacritics + digraphs like sz/č/cz/rz).
- **Lithuanian**: Full transliteration.
- **Russian**: Full transliteration.
- **Czech**: Basic transliteration (diacritics only, no ending transformations).

### Supported Language Pairs for Transformations

| From ↓ / To → | Polish | Lithuanian | Russian |
|---------------|--------|------------|---------|
| **Polish**   | -      | ✅ (polish_to_lithuanian) | ✅ (polish_to_russian) |
| **Lithuanian**| ✅ (lithuanian_to_polish) | - | - |
| **Russian**  | ✅ (russian_to_polish) | - | - |

Note: Transformations are asymmetric (see below). Add more pairs by editing `POLONIZATION_MAPPINGS`.

## Transformation Matrix Examples

Below is a matrix showing example transformations between languages (not symmetric):

| From → To          | Polish → Lithuanian | Lithuanian → Polish |
|--------------------|---------------------|---------------------|
| Antonowicz        | Antonavičius, Antonowič | - |
| Jankauskas        | - | Jankowski, Jankauskas |
| Kowalski          | Kovalskis           | - |
| Wiśniewski        | Višnievskis, Višnievskas | - |
| Dombrovskis       | - | Dombrowski          |

This illustrates why separate methods are needed for each direction.

## Adding New Languages

Edit `DIACRITIC_MAPPINGS` and `POLONIZATION_MAPPINGS` in the code to add support for more languages/pairs.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/justi/surname-transliterator.
