require 'spec_helper'

describe Ordodo::Config do
  describe 'configuration effects' do
    describe 'locale' do
      describe 'known' do
        let(:xml) { '<ordodo locale="it"></ordodo>' }

        it 'loads it' do
          config = described_class.from_xml xml
          expect(config.locale).to eq 'it'
        end

        it 'sets it globally' do
          I18n.locale = :en

          expect do
            config = described_class.from_xml xml
          end.to change { I18n.locale }.to :it
        end
      end

      describe 'unknown' do
        let(:xml) { '<ordodo locale="xx"></ordodo>' }

        it 'fails loudly' do
          expect do
            described_class.from_xml xml
          end.to raise_exception(Ordodo::Config::Error, /not a valid locale/)
        end
      end
    end
  end
end
