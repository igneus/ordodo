require 'date'
require 'delegate'
require 'tilt'

require 'cells'
require 'cells-erb'
require 'calendarium-romanum'
require 'i18n'
require 'nokogiri'
require 'rubytree'

CR = CalendariumRomanum

%w{
version
application_error
cli
config
generator
linearizer
office
outputters/outputter
outputters/console
outputters/html
cells/cell
cells/record
cells/entry
cells/celebration
record
tree_calendar
tree_reducer
}.each do |f|
  require_relative File.join('ordodo', f)
end

locale_wildcard = File.expand_path('../config/locales/*.yml', File.dirname(__FILE__))
I18n.config.load_path += Dir[locale_wildcard]
