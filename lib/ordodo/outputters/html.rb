module Ordodo
  module Outputters
    class HTML < Outputter
      def prepare
        FileUtils.mkdir_p(@output_dir)
        @fw = File.open(File.join(@output_dir, 'index.html'), 'w')

        @fw.puts header.render(self)
      end

      def <<(r)
        html = record.render(
          self, # binding
          record: r,
          unprinted_ranks: [
            CalendariumRomanum::Ranks::SUNDAY_UNPRIVILEGED,
            CalendariumRomanum::Ranks::FERIAL,
            CalendariumRomanum::Ranks::MEMORIAL_OPTIONAL
          ],
          notbold_ranks: [
            CalendariumRomanum::Ranks::MEMORIAL_OPTIONAL,
            CalendariumRomanum::Ranks::COMMEMORATION,
          ],
        )
        @fw.puts html
      end

      def finish
        @fw.puts footer.render(self)

        @fw.close
      end

      private

      def header
        @header ||= Tilt.new(template_path('header.html.erb'))
      end

      def footer
        @footer ||= Tilt.new(template_path('footer.html.erb'))
      end

      def record
        @record ||= Tilt.new(template_path('record.html.erb'))
      end

      def template_path(fname)
        File.join @templates_dir, fname
      end
    end
  end
end
