module Ordodo
  class CLI
    def self.run!(argv)
      config_path = argv[0] || die('Specify path to the configuration file.')
      year = argv[1]

      config = Config.from_xml File.read config_path
      Generator.new(config).call year
    end

    def self.die(message)
      STDERR.puts message
      exit 1
    end
  end
end
