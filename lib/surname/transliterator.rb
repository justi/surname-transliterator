# frozen_string_literal: true

require_relative "transliterator/version"

module Surname
  # Cross-language surname transliteration and polonization/de-polonization.
  module Transliterator
    # Raised for transliteration errors
    class Error < StandardError; end

    LANG_POLISH = "polish"
    LANG_LITHUANIAN = "lithuanian"
    LANG_RUSSIAN = "russian"

    POLISH_DIGRAPHS = { "sz" => "š", "cz" => "č", "rz" => "ž" }.freeze

    DIACRITIC_MAPPINGS = {
      polish: {
        "ą" => "a", "ć" => "c", "ę" => "e", "ł" => "l", "ń" => "n",
        "ó" => "o", "ś" => "s", "ź" => "z", "ż" => "z"
      },
      lithuanian: {
        "ą" => "a", "č" => "c", "ę" => "e", "ė" => "e", "į" => "i",
        "š" => "s", "ų" => "u", "ū" => "u", "ž" => "z"
      },
      czech: {
        "á" => "a", "č" => "c", "ď" => "d", "é" => "e", "ě" => "e",
        "í" => "i", "ň" => "n", "ó" => "o", "ř" => "r", "š" => "s",
        "ť" => "t", "ú" => "u", "ů" => "u", "ý" => "y", "ž" => "z"
      },
      russian: {
        "а" => "a", "б" => "b", "в" => "v", "г" => "g", "д" => "d",
        "е" => "e", "ё" => "e", "ж" => "zh", "з" => "z", "и" => "i",
        "й" => "i", "к" => "k", "л" => "l", "м" => "m", "н" => "n",
        "о" => "o", "п" => "p", "р" => "r", "с" => "s", "т" => "t",
        "у" => "u", "ф" => "f", "х" => "kh", "ц" => "ts", "ч" => "ch",
        "ш" => "sh", "щ" => "shch", "ъ" => "", "ы" => "y", "ь" => "",
        "э" => "e", "ю" => "iu", "я" => "ia"
      }
    }.freeze

    POLONIZATION_MAPPINGS = {
      "polish_to_lithuanian" => {
        "owicz" => ["avičius"],
        "owski" => %w[ovskis ovskas ovicius],
        "ewski" => %w[evskis evskas],
        "icki" => ["ickis"],
        "ak" => ["akas"],
        "ski" => %w[skis skas],
        "cki" => %w[ckis ckas]
      },
      "lithuanian_to_polish" => {
        "auskas" => ["owski"],
        "avičius" => ["owicz"],
        "ovicius" => ["owski"],
        "ovskis" => ["owski"],
        "ovskas" => ["owski"],
        "evskis" => ["ewski"],
        "evskas" => ["ewski"],
        "aitis" => ["owicz"],
        "ickis" => ["icki"],
        "onis" => ["owicz"],
        "akas" => ["ak"],
        "skis" => ["ski"],
        "skas" => ["ski"],
        "ckis" => ["cki"],
        "ckas" => ["cki"]
      },
      "polish_to_russian" => {
        "owicz" => "ovich",
        "owski" => "ovskii",
        "ski" => "skii",
        "cki" => "tskii"
      },
      "russian_to_polish" => {
        "ovskii" => "owski",
        "ovich" => "owicz",
        "tskii" => "cki",
        "skii" => "ski"
      }
    }.freeze

    def self.transliterate(surname, from_lang)
      return surname if surname.to_s.empty?

      normalized = apply_diacritics(surname.downcase, from_lang)
      normalized = apply_polish_digraphs(normalized) if from_lang == LANG_POLISH
      normalized.capitalize
    end

    def self.transform_ending(surname, from_lang, to_lang)
      return [surname] if surname.to_s.empty?

      endings = POLONIZATION_MAPPINGS["#{from_lang}_to_#{to_lang}"] || {}
      find_matching_ending(surname.downcase, endings)
    end

    def self.normalize_surname(surname, from_lang, to_lang)
      transformed = transform_ending(surname, from_lang, to_lang)
      variants = transformed.map { |variant| transliterate(variant, from_lang) }
      variants << transliterate(surname, from_lang) unless transformed == [surname]

      with_wv_interchange(variants)
    end

    def self.polish_to_lithuanian(surname)
      normalize_surname(surname, LANG_POLISH, LANG_LITHUANIAN)
    end

    def self.lithuanian_to_polish(surname)
      normalize_surname(surname, LANG_LITHUANIAN, LANG_POLISH)
    end

    def self.polish_to_russian(surname)
      normalize_surname(surname, LANG_POLISH, LANG_RUSSIAN)
    end

    def self.russian_to_polish(surname)
      normalize_surname(surname, LANG_RUSSIAN, LANG_POLISH)
    end

    class << self
      private

      def apply_diacritics(text, lang)
        mappings = DIACRITIC_MAPPINGS[lang.to_sym] || {}
        mappings.reduce(text) { |result, (accented, base)| result.gsub(accented, base) }
      end

      def apply_polish_digraphs(text)
        POLISH_DIGRAPHS.reduce(text) { |result, (digraph, replacement)| result.gsub(digraph, replacement) }
      end

      def find_matching_ending(normalized, endings)
        from_ending, to_endings = endings.sort_by { |ending, _| -ending.length }
                                         .find { |ending, _| normalized.end_with?(ending) }
        return [] unless from_ending

        Array(to_endings).map { |to| normalized.sub(/#{from_ending}$/, to).capitalize }.uniq
      end

      def with_wv_interchange(variants)
        interchange = variants.filter_map do |variant|
          if variant.start_with?("W")
            variant.sub(/^W/, "V")
          elsif variant.start_with?("V")
            variant.sub(/^V/, "W")
          end
        end

        (variants + interchange).uniq.compact.reject(&:empty?)
      end
    end
  end
end
