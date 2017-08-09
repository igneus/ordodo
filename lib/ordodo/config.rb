module Ordodo
  class Config
    def initialize
      @locale = :en

      yield self if block_given?
      freeze
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
  end
end
