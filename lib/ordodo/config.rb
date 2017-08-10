module Ordodo
  class Config
    def initialize
      @locale = :en
      @temporale_options = {}
      @temporale_extensions = []

      yield self if block_given?
      freeze

      begin
        I18n.locale = @locale
      rescue I18n::InvalidLocale => e
        raise Error.new(e.message)
      end
    end

    attr_accessor :locale, :temporale_options, :temporale_extensions

    def self.from_xml(xml)
      begin
        doc = Nokogiri::XML(xml) do |config|
          config.strict.noblanks
        end
      rescue Nokogiri::SyntaxError => e
        raise Error.new("invalid XML document: #{e.message}")
      end

      new do |c|
        c.locale = doc.root['locale'] || c.locale

        doc.root.xpath('./temporale/options/option').each do |option|
          c.temporale_option option['type'], option['feast'], option['apply']
        end

        doc.root.xpath('./temporale/extensions/extension').each do |ext|
          c.temporale_extension ext.text
        end
      end
    end

    def create_tree_calendar(year)
      TreeCalendar.new(year)
    end

    class Error < ApplicationError
      def initialize(message)
        super 'configuration error: ' + message
      end
    end

    OPTION_TYPES = %w(transfer_to_sunday).freeze
    TRANSFERABLE_FEASTS = ['Epiphany', 'Ascension', 'Corpus Christi'].freeze
    APPLY_OPTIONS = %w(always optional never).freeze

    def temporale_option(type, feast, apply)
      unless OPTION_TYPES.include? type
        raise Error.new("unknown temporale option type #{type.inspect}, supported types are #{OPTION_TYPES}")
      end

      unless TRANSFERABLE_FEASTS.include? feast
        raise Error.new("cannot transfer #{value.inspect} on Sunday, transfer supported only for #{TRANSFERABLE_FEASTS}")
      end

      unless APPLY_OPTIONS.include? apply
        raise Error.new("invalid 'apply' value #{apply.inspect}, supported values are #{APPLY_OPTIONS}")
      end

      return if apply == 'never'

      append_to =
        @temporale_options[apply.to_sym] ||= {transfer_to_sunday: []}
      append_to[:transfer_to_sunday] << feast.sub(' ', '_').downcase.to_sym
    end

    def temporale_extension(name)
      const_name = name.gsub(' ', '')

      extensions_module = CalendariumRomanum::Temporale::Extensions
      supported_extensions = extensions_module.constants.collect &:to_s
      error = Error.new("unsupported temporale extension #{name.inspect}, supported are #{supported_extensions}")

      raise error unless const_name =~ /\A[\w\d]+\Z/

      begin
        @temporale_extensions <<
          extensions_module.const_get(const_name)
      rescue NameError
        raise error
      end
    end
  end
end
