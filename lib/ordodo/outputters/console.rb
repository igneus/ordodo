module Ordodo
  module Outputters
    class Console < Outputter
      def prepare
        puts @year
        puts
      end

      def <<(record)
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

      private

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
    end
  end
end
