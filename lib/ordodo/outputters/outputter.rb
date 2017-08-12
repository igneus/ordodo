module Ordodo
  module Outputters
    class Outputter
      def initialize(year, output_dir: nil, templates_dir: nil)
        @year = year
        @output_dir = output_dir
        @templates_dir = templates_dir
      end

      def prepare
      end

      def <<(record)
      end

      def finish
      end
    end
  end
end
