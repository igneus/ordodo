module Ordodo
  class CLI
    def self.run!(argv)
      config_path = argv[0] || die('Specify path to the configuration file.')
      year = argv[1]&.to_i

      begin
        config =
          File.open(config_path) do |fr|
          Config.from_xml(fr) do |config|
            config.year = year if year
          end
        end
        Generator.new(config).call
      rescue ApplicationError => e
        die e.message
      end
    end

    def self.die(message)
      STDERR.puts message
      exit 1
    end
  end
end
