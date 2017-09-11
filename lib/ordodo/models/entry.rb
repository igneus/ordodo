module Ordodo
  # Entry describing one particular solution of a given
  # liturgical day. (Each day may have one or more such solutions,
  # based on differences in local calendars and optional
  # transfers of temporale solemnities.)
  class Entry
    extend Forwardable

    def initialize(titles, day)
      @titles, @day = titles, day
      @offices =
        day.celebrations.collect {|c| Office.new(day, c) }
    end

    # Usually the Array contains a single title describing
    # the calendar the solution belongs to;
    # when several calendars (which could not be reduced
    # to a common parent) share a solution, their titles are all listed
    attr_reader :titles

    # CalendariumRomanum::Day
    attr_reader :day

    # Array of Ordodo::Office
    attr_reader :offices

    def_delegators :@day, :season, :vespers, :vespers_from_following?

    def psalter_week
      w = @day.season_week % 4
      w == 0 ? 4 : w
    end

    def vespers_from_following_feast?
      day.vespers&.rank == CalendariumRomanum::Ranks::FEAST_LORD_GENERAL
    end

    def vespers_from_following_sunday?
      rank = vespers&.rank

      rank == CalendariumRomanum::Ranks::SUNDAY_UNPRIVILEGED ||
        (rank == CalendariumRomanum::Ranks::PRIMARY && day.date.saturday? && vespers.symbol.nil?)
    end
  end
end
