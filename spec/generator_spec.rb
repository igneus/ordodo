require 'spec_helper'

describe Ordodo::Generator do
  let(:generator) { described_class.new config }

  describe 'configuration error handling' do
    describe 'no calendars' do
      let(:config) { Ordodo::Config.new }

      it 'fails' do
        expect { generator.call(2017) }
          .to raise_exception(Ordodo::ApplicationError, /no calendars/)
      end
    end
  end
end
