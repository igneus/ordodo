module Ordodo
  # orchestrates generating of the ordo
  class Generator
    def initialize(config)
      @config = config
    end

    def call
      if @config.calendars.nil?
        raise ApplicationError.new('no calendars loaded. Please, specify at least one calendar.')
      end

      puts "Loaded calendars:"
      @config.calendars.print_tree
      puts
      puts "Generating ordo for liturgical year #{@config.year}"

      reducer = TreeReducer.new
      linearizer = Linearizer.new

      calendar = @config.create_tree_calendar

      globals = {months: months}

      outputters = [
        Outputters::Console.new(@config, globals: globals),
        Outputters::HTML.new(
          @config,
          templates_dir: 'templates/html',
          output_dir: "ordo_#{@config.year}",
          globals: globals,
        )
      ]
      outputters.each &:prepare

      last_season = last_month = nil
      calendar.each_day do |day_tree|
        record = linearizer.linearize reducer.reduce day_tree

        if record.season != last_season
          outputters.each {|o| o.before_season record.season }
          last_season = record.season
        end

        if record.date.month != last_month
          outputters.each {|o| o.before_month record.date }
          last_month = record.date.month
        end

        outputters.each {|o| o << record }
      end

      outputters.each &:finish
    end

    private

    # returns an Array of Dates of beginnings of months
    # in the liturgical year (only year and month are significant -
    # used to generate month navigation)
    def months
      temporale = CalendariumRomanum::Temporale.new(@config.year)
      first_month = temporale.start_date.month
      last_month = temporale.end_date.month

      (first_month .. 12)
        .collect {|m| Date.new(@config.year, m, 1) } \
      + (1 .. last_month)
        .collect {|m| Date.new(@config.year + 1, m, 1) }
    end
  end
end
