require 'spec_helper'

describe Ordodo::Config do
  describe 'configuration parsing' do
    describe 'malformed document' do
      let(:xml) { '<ordodo><broken</ordodo>' }

      it 'fails' do
        expect do
          described_class.from_xml xml
        end.to raise_exception(Ordodo::Config::Error, /invalid XML/)
      end
    end
  end

  describe 'configuration effects' do
    let(:config) { described_class.from_xml xml }

    describe 'locale' do
      describe 'not specified' do
        let(:xml) { '<ordodo></ordodo>' }

        it 'loads default' do
          config = described_class.from_xml xml
          expect(config.locale).to eq :en
        end

        it 'sets default globally' do
          I18n.locale = :it

          expect do
            config = described_class.from_xml xml
          end.to change { I18n.locale }.to :en
        end
      end

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

    describe 'temporale options' do
      let(:xml) do
        "<ordodo>
           <temporale>
             <options>
               <option type=\"transfer_to_sunday\" feast=\"Epiphany\" apply=\"#{apply}\" />
         </options></temporale></ordodo>"
      end

      describe 'applied always' do
        let(:apply) { 'always' }

        it 'loaded data structure' do
          expect(config.temporale_options)
            .to eq({always: {transfer_to_sunday: [:epiphany]}})
        end
      end

      describe 'applied optionally' do
        let(:apply) { 'optional' }

        it 'loaded data structure' do
          expect(config.temporale_options)
            .to eq({optional: {transfer_to_sunday: [:epiphany]}})
        end
      end

      describe 'never applied' do
        let(:apply) { 'never' }

        it 'has no effect on loaded data structure' do
          expect(config.temporale_options)
            .to eq({})
        end
      end
    end

    describe 'temporale extensions' do
      describe 'supported' do
        let(:xml) do
        "<ordodo>
           <temporale>
             <extensions>
               <extension>Christ Eternal Priest</extension>
         </extensions></temporale></ordodo>"
        end

        it 'is loaded' do
          expect(config.temporale_extensions)
            .to eq [CalendariumRomanum::Temporale::Extensions::ChristEternalPriest]
        end
      end

      describe 'unsupported' do
        let(:xml) do
        "<ordodo>
           <temporale>
             <extensions>
               <extension>Apparition of St. Michael</extension>
         </extensions></temporale></ordodo>"
        end

        it 'is loaded' do
          expect do
            described_class.from_xml xml
          end.to raise_exception(Ordodo::Config::Error, /unsupported temporale extension/)
        end
      end
    end
  end
end
