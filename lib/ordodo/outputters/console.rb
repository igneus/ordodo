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
        day.offices.each_with_index do |o, i|
          print spacer if i > 0
          print "#{o.title}"

          if o.rank >= CalendariumRomanum::Ranks::MEMORIAL_PROPER ||
             o.rank < CalendariumRomanum::Ranks::FERIAL
            print ", #{o.rank.short_desc}"
          end

          puts
        end
      end
    end
  end
end
