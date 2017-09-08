module Ordodo
  # Record completely describing a day in an *ordo*.
  # Has at least one Entry.
  class Record
    def initialize(entries)
      @entries = entries
      @date = @entries.first.day.date
    end

    attr_reader :entries, :date

    def season
      @entries.first.season
    end

    def psalter_week
      @entries.first.psalter_week
    end
  end
end
