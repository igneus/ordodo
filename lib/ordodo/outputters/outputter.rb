module Ordodo
  module Outputters
    class Outputter
      extend Forwardable

      def initialize(config, output_dir: nil, templates_dir: nil)
        @config = config
        @output_dir = output_dir
        @templates_dir = templates_dir
      end

      attr_reader :config
      def_delegators :@config, :year, :title

      def prepare
      end

      def before_season(season)
      end

      def <<(record)
      end

      def finish
      end
    end
  end
end
