require 'date'
require 'tilt'

require 'calendarium-romanum'
require 'nokogiri'
require 'rubytree'

%w{
version
application_error
cli
config
generator
linearizer
outputters/outputter
outputters/console
outputters/html
record
tree_calendar
tree_reducer
}.each do |f|
  require_relative File.join('ordodo', f)
end
