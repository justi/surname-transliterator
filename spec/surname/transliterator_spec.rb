# frozen_string_literal: true

require "bundler/setup"
require "surname/transliterator"

RSpec.describe Surname::Transliterator do
  describe ".transliterate" do
    it "removes Polish diacritics" do
      expect(described_class.transliterate("Świętochowski", "polish")).to eq("Swietochowski")
    end

    it "transliterates Russian" do
      expect(described_class.transliterate("Иванов", "russian")).to eq("Ivanov")
    end

    it "handles Polish digraphs" do
      expect(described_class.transliterate("Wiszniewski", "polish")).to eq("Wišniewski")
    end

    it "returns nil/empty input unchanged" do
      expect(described_class.transliterate(nil, "polish")).to be_nil
      expect(described_class.transliterate("", "polish")).to eq("")
    end

    it "handles unknown language gracefully" do
      expect(described_class.transliterate("Smith", "english")).to eq("Smith")
    end
  end

  describe ".transform_ending" do
    it "changes owicz to avičius" do
      expect(described_class.transform_ending("Antonowicz", "polish", "lithuanian")).to eq(["Antonavičius"])
    end

    it "returns empty array for no matching ending" do
      expect(described_class.transform_ending("Smith", "polish", "lithuanian")).to eq([])
    end

    it "returns original for nil/empty input" do
      expect(described_class.transform_ending(nil, "polish", "lithuanian")).to eq([nil])
      expect(described_class.transform_ending("", "polish", "lithuanian")).to eq([""])
    end

    it "matches longest ending first" do
      result = described_class.transform_ending("Jankauskas", "lithuanian", "polish")
      expect(result).to eq(["Jankowski"])
    end
  end

  describe ".polish_to_lithuanian" do
    it "transliterates Łukasiewicz to Lukasiewič" do
      expect(described_class.polish_to_lithuanian("Łukasiewicz")).to eq(["Lukasiewič"])
    end

    it "transforms Antonowicz to Antonowicz and Antanavicius" do
      expect(described_class.polish_to_lithuanian("Antonowicz")).to eq(%w[Antonavičius Antonowič])
    end

    it "handles multiple endings for owski" do
      result = described_class.polish_to_lithuanian("Janowski")
      expect(result).to include("Janovskis", "Janovskas", "Janovicius")
    end

    it "handles W/V interchange" do
      result = described_class.polish_to_lithuanian("Walski")
      expect(result).to include("Walski", "Walskis", "Walskas", "Valski", "Valskis", "Valskas")
    end

    it "handles akas suffix" do
      result = described_class.polish_to_lithuanian("Nowak")
      expect(result).to include("Nowakas")
    end
  end

  describe ".lithuanian_to_polish" do
    it "transforms Jankauskas to Jankowski and Jankauskas" do
      expect(described_class.lithuanian_to_polish("Jankauskas")).to eq(%w[Jankowski Jankauskas])
    end
  end

  describe ".polish_to_russian" do
    it "transforms Kowalski" do
      result = described_class.polish_to_russian("Kowalski")
      expect(result).to include("Kowalskii")
    end
  end

  describe ".russian_to_polish" do
    it "transforms Иванов" do
      result = described_class.russian_to_polish("Иванов")
      expect(result).to include("Ivanov")
    end
  end

  describe ".normalize_surname" do
    it "adds V variant for W-starting surname" do
      result = described_class.normalize_surname("Walski", "polish", "lithuanian")
      w_variants = result.select { |v| v.start_with?("W") }
      v_variants = result.select { |v| v.start_with?("V") }
      expect(w_variants).not_to be_empty
      expect(v_variants).not_to be_empty
    end

    it "adds W variant for V-starting surname" do
      result = described_class.normalize_surname("Valski", "polish", "lithuanian")
      expect(result).to include("Walski")
    end

    it "includes transliterated original when ending is transformed" do
      result = described_class.normalize_surname("Antonowicz", "polish", "lithuanian")
      expect(result).to include("Antonowič")
    end
  end
end
