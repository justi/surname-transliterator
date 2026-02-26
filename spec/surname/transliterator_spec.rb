require 'bundler/setup'
require 'surname/transliterator'

RSpec.describe Surname::Transliterator do
  describe '.polish_to_lithuanian' do
    it 'transliterates Łukasiewicz to Lukasiewič' do
      expect(described_class.polish_to_lithuanian('Łukasiewicz')).to eq(['Lukasiewič'])
    end

    it 'transforms Antonowicz to Antonowicz and Antanavicius' do
      expect(described_class.polish_to_lithuanian('Antonowicz')).to eq(%w[Antonavičius Antonowič])
    end
  end

  describe '.lithuanian_to_polish' do
    it 'transforms Jankauskas to Jankowski and Jankauskas' do
      expect(described_class.lithuanian_to_polish('Jankauskas')).to eq(%w[Jankowski Jankauskas])
    end
  end

  describe '.transliterate' do
    it 'removes Polish diacritics' do
      expect(described_class.transliterate('Świętochowski', 'polish')).to eq('Swietochowski')
    end

    it 'transliterates Russian' do
      expect(described_class.transliterate('Иванов', 'russian')).to eq('Ivanov')
    end
  end

  describe '.transform_ending' do
    it 'changes owicz to avičius' do
      expect(described_class.transform_ending('Antonowicz', 'polish', 'lithuanian')).to eq(['Antonavičius'])
    end
  end

  describe '.polish_to_lithuanian' do
    it 'handles multiple endings for owski' do
      result = described_class.polish_to_lithuanian('Janowski')
      expect(result).to include('Janovskis', 'Janovskas', 'Janovicius')
    end

    it 'handles W/V interchange' do
      result = described_class.polish_to_lithuanian('Walski')
      expect(result).to include('Walski', 'Walskis', 'Walskas', 'Valski', 'Valskis', 'Valskas')
    end

    it 'handles akas suffix' do
      result = described_class.polish_to_lithuanian('Nowak')
      expect(result).to include('Nowakas')
    end

    it 'handles akas suffix' do
      result = described_class.polish_to_lithuanian('Nowak')
      expect(result).to include('Nowakas')
    end
  end

  describe '.transliterate' do
    it 'handles Polish digraphs' do
      expect(described_class.transliterate('Wiszniewski', 'polish')).to eq('Wišniewski')
    end
  end
end
