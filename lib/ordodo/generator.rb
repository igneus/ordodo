module Ordodo
  # orchestrates generating of the ordo
  class Generator
    def initialize(config)
      @config = config
    end

    def call(year=nil)
      year ||= upcoming_year
      puts "Generating ordo for liturgical year #{year}"
    end

    private

    def upcoming_year
      today = Date.today
      civil = today.year

      if CalendariumRomanum::Temporale::Dates
          .first_advent_sunday(civil) > today
        return civil
      end

      civil + 1
    end
  end
end
