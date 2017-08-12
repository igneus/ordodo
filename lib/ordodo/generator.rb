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
      calendar.each_day do |day_tree|
        record = linearizer.linearize reducer.reduce day_tree
        print "#{record.date} "
        if record.entries.size == 1
          print_day record.entries.first
        else
          record.entries.each_with_index do |entry, i|
            print "-> #{entry.titles.join(', ')}: " if i != 0
            print_day entry
          end
          puts
        end
      end
    end

    def print_day(day)
      spacer = ' ' * 11
      day.celebrations.each_with_index do |c, i|
        print spacer if i > 0
        print "#{c.title}"

        if c.rank >= CalendariumRomanum::Ranks::MEMORIAL_PROPER ||
           c.rank < CalendariumRomanum::Ranks::FERIAL
          print ", #{c.rank.short_desc}"
        end

        puts
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
