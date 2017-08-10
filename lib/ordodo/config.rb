module Ordodo
  class Config
    def initialize
      yield self if block_given?
      set_defaults
      freeze

      begin
        I18n.locale = @locale
      rescue I18n::InvalidLocale => e
        raise Error.new(e.message)
      end
    end

    attr_accessor :locale

    def self.from_xml(xml)
      doc = Nokogiri::XML(xml)

      new do |c|
        c.locale = doc.root['locale']
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

    private

    def set_defaults
      @locale ||= :en
    end
  end
end
