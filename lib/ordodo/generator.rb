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

      if @config.calendars.nil?
        raise ApplicationError.new('no calendars loaded. Please, specify at least one calendar.')
      end

      puts "Loaded calendars:"
      @config.calendars.print_tree
      puts
      puts "Generating ordo for liturgical year #{year}"

      reducer = TreeReducer.new
      linearizer = Linearizer.new

      calendar = @config.create_tree_calendar(year)

      outputters = [Outputters::Console.new(year)]
      outputters.each &:prepare

      calendar.each_day do |day_tree|
        record = linearizer.linearize reducer.reduce day_tree
        outputters.each {|o| o << record }
      end

      outputters.each &:finish
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
