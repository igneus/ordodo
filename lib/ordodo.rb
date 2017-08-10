require 'date'

require 'calendarium-romanum'
require 'nokogiri'

%w{
version
application_error
cli
config
generator
tree_calendar
tree_reducer
}.each do |f|
  require_relative File.join('ordodo', f)
end
