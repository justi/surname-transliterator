# frozen_string_literal: true

require_relative "transliterator/version"

module Surname
  module Transliterator
    class Error < StandardError; end

    # Language mappings for transliteration (remove diacritics/Cyrillic to base Latin)
    DIACRITIC_MAPPINGS = {
      polish: {
        'ą' => 'a',
        'ć' => 'c',
        'ę' => 'e',
        'ł' => 'l',
        'ń' => 'n',
        'ó' => 'o',
        'ś' => 's',
        'ź' => 'z',
        'ż' => 'z'
      },
      lithuanian: {
        'ą' => 'a',
        'č' => 'c',
        'ę' => 'e',
        'ė' => 'e',
        'į' => 'i',
        'š' => 's',
        'ų' => 'u',
        'ū' => 'u',
        'ž' => 'z'
      },
      czech: {
        'á' => 'a',
        'č' => 'c',
        'ď' => 'd',
        'é' => 'e',
        'ě' => 'e',
        'í' => 'i',
        'ň' => 'n',
        'ó' => 'o',
        'ř' => 'r',
        'š' => 's',
        'ť' => 't',
        'ú' => 'u',
        'ů' => 'u',
        'ý' => 'y',
        'ž' => 'z'
      },
      russian: {
        'а' => 'a',
        'б' => 'b',
        'в' => 'v',
        'г' => 'g',
        'д' => 'd',
        'е' => 'e',
        'ё' => 'e',
        'ж' => 'zh',
        'з' => 'z',
        'и' => 'i',
        'й' => 'i',
        'к' => 'k',
        'л' => 'l',
        'м' => 'm',
        'н' => 'n',
        'о' => 'o',
        'п' => 'p',
        'р' => 'r',
        'с' => 's',
        'т' => 't',
        'у' => 'u',
        'ф' => 'f',
        'х' => 'kh',
        'ц' => 'ts',
        'ч' => 'ch',
        'ш' => 'sh',
        'щ' => 'shch',
        'ъ' => '',
        'ы' => 'y',
        'ь' => '',
        'э' => 'e',
        'ю' => 'iu',
        'я' => 'ia'
      }
    }

    # Polonization/de-polonization mappings for specific pairs (based on genealogical sources)
    POLONIZATION_MAPPINGS = {
      'polish_to_lithuanian' => {
        'owicz' => 'avičius',
        'owski' => 'auskas',
        'ewski' => 'evskis',
        'icki' => 'ickis',
        'ski' => 'skis',
        'cki' => 'ckis'
      },
      'lithuanian_to_polish' => {
        'avičius' => 'owicz',
        'auskas' => 'owski',
        'evskis' => 'ewski',
        'ickis' => 'icki',
        'skis' => 'ski',
        'ckis' => 'cki',
        'onis' => 'owicz',  # e.g., Jonas → Janowicz
        'aitis' => 'owicz'  # rarer, e.g., Kazlauskas variations
      },
      'polish_to_russian' => {
        'ski' => 'skii',
        'cki' => 'tskii',
        'owicz' => 'ovich',
        'owski' => 'ovskii'
      },
      'russian_to_polish' => {
        'skii' => 'ski',
        'tskii' => 'cki',
        'ovich' => 'owicz',
        'ovskii' => 'owski'
      }
    }

    # General transliteration (remove diacritics)
    def self.transliterate(surname, from_lang)
      return surname if surname.nil? || surname.empty?

      normalized = surname.downcase
      mappings = DIACRITIC_MAPPINGS[from_lang.to_sym] || {}

      mappings.each do |accented, base|
        normalized = normalized.gsub(accented, base)
      end

      normalized.capitalize
    end

    # Polonization/de-polonization between languages
    def self.transform_ending(surname, from_lang, to_lang)
      return surname if surname.nil? || surname.empty?

      key = "#{from_lang}_to_#{to_lang}"
      endings = POLONIZATION_MAPPINGS[key] || {}

      normalized = surname.downcase
      endings.each do |from_ending, to_ending|
        if normalized.end_with?(from_ending)
          return normalized.sub(/#{from_ending}$/, to_ending).capitalize
        end
      end

      surname
    end

    # Full cross-language surname normalization
    def self.normalize_surname(surname, from_lang, to_lang)
      # First, transliterate to remove diacritics
      transliterated = transliterate(surname, from_lang)
      # Then, transform endings if applicable
      transformed = transform_ending(transliterated, from_lang, to_lang)
      # Return variants: only add transformed if different from transliterated
      variants = [ transliterated ]
      variants << transformed if transformed != transliterated
      variants.compact
    end

    # Convenience methods
    def self.polish_to_lithuanian(surname)
      normalize_surname(surname, 'polish', 'lithuanian')
    end

    def self.lithuanian_to_polish(surname)
      normalize_surname(surname, 'lithuanian', 'polish')
    end

    def self.polish_to_russian(surname)
      normalize_surname(surname, 'polish', 'russian')
    end

    def self.russian_to_polish(surname)
      normalize_surname(surname, 'russian', 'polish')
    end

    # Add more pairs as needed, e.g., polish_to_czech, etc.
  end
end
