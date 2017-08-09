module Ordodo
  class TreeCalendar
    def initialize(year)
      @calendar = CalendariumRomanum::Calendar.new(year)
    end

    def each_day
      @calendar.temporale.date_range.each do |date|
        yield @calendar.day date
      end
    end
  end
end
