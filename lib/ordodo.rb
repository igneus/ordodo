require 'date'
require 'calendarium-romanum'

%w{
version
cli
config
generator
}.each do |f|
  require_relative File.join('ordodo', f)
end
