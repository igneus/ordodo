require 'spec_helper'

describe 'handling of real examples' do
  let(:config_fullpath) { File.expand_path "../../examples/#{config_file}", __FILE__ }
  let(:config) { Ordodo::Config.from_xml File.read config_fullpath }
  let(:year) { 2017 }
  let(:tree_calendar) { config.create_tree_calendar year }
  let(:reducer) { Ordodo::TreeReducer.new }

  shared_examples 'any example configuration' do
    it 'loads without error' do
      expect do
        File.open(config_fullpath) do |fr|
          Ordodo::Config.from_xml fr
        end
      end.not_to raise_exception
    end
  end

  describe 'Czech calendar' do
    let(:config_file) { 'czech_republic.xml' }

    it_behaves_like 'any example configuration'

    it 'November 3rd' do
      day = tree_calendar.day Date.new(2018, 11, 3)
      reduced = reducer.reduce day
      expect(reduced.size).to eq 1
      celebration_titles = reduced.content.celebrations.collect &:title
      expect(celebration_titles)
        .to eq ['Sobota 30. týdne v mezidobí', 'Sv. Martina de Porres, řeholníka']
    end

    it 'Christ Eternal Priest' do
      day = tree_calendar.day Date.new(2018, 5, 24)
      reduced = reducer.reduce day
      expect(reduced.size).to eq 1
      celebration_titles = reduced.content.celebrations.collect &:title
      expect(celebration_titles)
        .to eq ['Ježíše Krista, nejvyššího a věčného kněze']
    end
  end

  describe 'General Roman Calendar (English)' do
    let(:config_file) { 'general_roman.xml' }

    it_behaves_like 'any example configuration'
  end
end
