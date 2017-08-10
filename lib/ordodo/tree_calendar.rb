module Ordodo
  class TreeCalendar
    def initialize(year)
      sanctorale = CalendariumRomanum::Data::GENERAL_ROMAN_ENGLISH.load
      @calendar = CalendariumRomanum::Calendar.new(year, sanctorale)
    end

    def each_day
      @calendar.temporale.date_range.each do |date|
        yield @calendar.day date
      end
    end
  end
end
