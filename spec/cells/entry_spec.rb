require_relative '../spec_helper'

describe Ordodo::Cells::Entry do
  let(:cferial) { CR::Celebration.new('', CR::Ranks::FERIAL) }
  let(:csunday) { CR::Celebration.new('', CR::Ranks::SUNDAY_UNPRIVILEGED) }
  let(:cpsunday) { CR::Celebration.new('', CR::Ranks::PRIMARY) }
  let(:csolemnity) { CR::Celebration.new('', CR::Ranks::SOLEMNITY_GENERAL) }

  let(:any_year) { 1980 }
  let(:any_date) { Date.new(any_year, 9, 9) } # Tuesday
  let(:titles) { ['Entry title'] }
  let(:day) { CR::Day.new }
  let(:entry) { Ordodo::Entry.new(titles, day) }
  let(:cell) { described_class.(entry) }

  before :each do
    I18n.locale = :cs # there is currently no other locale available
  end

  describe '#vespers' do
    describe 'from following Sunday' do
      let(:day) do
        CR::Day.new(celebrations: [cferial], vespers: csunday)
      end

      it { expect(cell.vespers).to include 'z následující neděle' }
    end

    describe 'from following privileged Sunday' do
      let(:date) { CR::Temporale::Dates.first_advent_sunday(any_year) - 1 }
      let(:day) do
        CR::Day.new(date: date, celebrations: [cferial], vespers: cpsunday)
      end

      it { expect(cell.vespers).to include 'z následující neděle' }
    end

    describe 'from following solemnity' do
      let(:day) do
        CR::Day.new(date: any_date, celebrations: [cferial], vespers: csolemnity)
      end

      it { expect(cell.vespers).to include 'z následující slavnosti' }
    end

    describe 'from following "primary solemnity"' do
      describe 'on regular day' do
        let(:day) do
          CR::Day.new(date: any_date, celebrations: [cferial], vespers: CR::Temporale::CelebrationFactory.nativity)
        end

        it { expect(cell.vespers).to include 'z následující slavnosti' }
      end

      describe 'on Sunday' do
        let(:sunday_christmas) { CR::Temporale::Dates.nativity(2016) }
        let(:day) do
          CR::Day.new(date: sunday_christmas - 1, celebrations: [cferial], vespers: CR::Temporale::CelebrationFactory.nativity)
        end

        it do
          expect(sunday_christmas).to be_sunday # make sure

          expect(cell.vespers).to include 'z následující slavnosti'
        end
      end
    end
  end
end
