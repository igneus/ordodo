module Ordodo
  module Outputters
    class HTML < Outputter
      def prepare
        FileUtils.mkdir_p(@output_dir)
	   # filename = 'index_' + @output_filename + '.html'
        @fw = File.open(File.join(@output_dir, @output_filename), 'w')

        @fw.puts header.render(self, **@globals)
      end

      def before_season(season)
        @fw.puts season_header.render(self, season: season)
      end

      def before_month(month)
        @fw.puts month_header.render(self, month: month)
      end

      def <<(r)
        html = Cells::Record.(r).()
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
