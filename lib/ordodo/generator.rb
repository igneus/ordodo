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

      outputters = [
        Outputters::Console.new(@config),
        Outputters::HTML.new(
          @config,
          templates_dir: 'templates/html',
          output_dir: "ordo_#{@config.year}"
        )
      ]
      outputters.each &:prepare

      last_season = nil
      calendar.each_day do |day_tree|
        record = linearizer.linearize reducer.reduce day_tree

        if record.season != last_season
          outputters.each {|o| o.before_season record.season }
          last_season = record.season
        end

        outputters.each {|o| o << record }
      end

      outputters.each &:finish
    end
  end
end
