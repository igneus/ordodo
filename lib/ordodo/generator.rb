module Ordodo
  # orchestrates generating of the ordo
  class Generator
    def initialize(config)
      @config = config
    end

    def call(year=nil)
      generate year
    end

    private

    def generate(year=nil)
      year ||= upcoming_year
      puts "Generating ordo for liturgical year #{year}"

      spacer = ' ' * 11

      calendar = @config.create_tree_calendar(year)
      calendar.each_day do |day_tree|
        day = TreeReducer.reduce day_tree
        print day.date
        print ' '
        day.celebrations.each_with_index do |c, i|
          print spacer if i > 0
          puts c.title
        end
      end
    end

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
