module Ordodo
  # Record completely describing a day in an *ordo*.
  # Has at least one Entry.
  class Record
    def initialize(entries)
      @entries = entries
      @date = @entries.first.day.date
    end

    attr_reader :entries, :date
  end

  # Entry describing one particular solution of a given
  # liturgical day. (Each day may have one or more such solutions,
  # based on differences in local calendars and optional
  # transfers of temporale solemnities.)
  class Entry
    extend Forwardable

    def initialize(titles, day)
      @titles, @day = titles, day
    end

    # Usually the Array contains a single title describing
    # the calendar the solution belongs to;
    # when several calendars (which could not be reduced
    # to a common parent) share a solution, their titles are all listed
    attr_reader :titles

    # CalendariumRomanum::Day
    attr_reader :day

    def_delegators :@day, :celebrations
  end
end
