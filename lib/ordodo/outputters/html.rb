module Ordodo
  module Outputters
    class HTML < Outputter
      def prepare
        FileUtils.mkdir_p(@output_dir)
        @fw = File.open(File.join(@output_dir, 'index.html'), 'w')

        @fw.puts header.render(self, **@globals)
      end

      def before_season(season)
        @fw.puts season_header.render(self, season: season)
      end

      def before_month(month)
        @fw.puts month_header.render(self, month: month)
      end

      def <<(r)
        html = record.render(
          self, # binding
          record: r,
          unprinted_ranks: [
            CalendariumRomanum::Ranks::SUNDAY_UNPRIVILEGED,
            CalendariumRomanum::Ranks::FERIAL,
            CalendariumRomanum::Ranks::FERIAL_PRIVILEGED,
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

      # helpers used in templates

      # some of the 'primary liturgical days' are customarily
      # called "solemnities", others not
      PRIMARY_SOLEMNITIES =
        %i(nativity epiphany easter_sunday ascension pentecost).freeze
      def primary_solemnity?(celebration)
        celebration.rank == CalendariumRomanum::Ranks::PRIMARY &&
          PRIMARY_SOLEMNITIES.include?(celebration.symbol)
      end

      private

      def header
        @header ||= Tilt.new(template_path('header.html.erb'))
      end

      def footer
        @footer ||= Tilt.new(template_path('footer.html.erb'))
      end

      def season_header
        @season_header ||= Tilt.new(template_path('before_season.html.erb'))
      end

      def month_header
        @month_header ||= Tilt.new(template_path('before_month.html.erb'))
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
