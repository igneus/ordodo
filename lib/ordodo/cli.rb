module Ordodo
  class CLI
    def self.run!(argv)
      
      options = {}
      optparse = OptionParser.new do|opts|
        # Set a banner, displayed at the top
        # of the help screen.
        opts.banner = "Usage: ordodo [OPTIONS] myconfig.xml"
      
        # Define the options, and what they do
        options[:outputfile] = nil
        opts.on( '-o', '--output FILE', 'Write output to FILE' ) do|file|
          options[:outputfile] = file
        end
        
        options[:year] = nil
        opts.on( '-y', '--year YEAR', 'Specify the YEAR for which the ordo should be produced' ) do|year|
          options[:year] = Integer(year)
        end
        
        # This displays the help screen
        opts.on( '-h', '--help', 'Display this screen' ) do
          puts opts
          exit
      end
    end
    # Parse the command-line. 
    optparse.parse!
      
      config_path = argv[0] || die('Specify path to the configuration file.')
      
      if options[:outputfile]
      output_dir = File.dirname(options[:outputfile])
      output_filename = File.basename(options[:outputfile])
      else
      output_dir = nil
      output_filename = "index_" + File.basename(config_path, ".xml") + ".html"
      end
      
      year = options[:year]
      
     begin
        config =
          File.open(config_path) do |fr|
          Config.from_xml(fr) do |config|
            config.year = year if year
            if output_dir
            config.output_dir = output_dir
            else
            config.output_dir = "ordo_#{config.year}"
            end
            config.output_filename = output_filename
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
