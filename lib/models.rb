require 'activerecord'
require File.expand_path(File.join(File.dirname(__FILE__), 'models', 'from_xml'))

Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), 'models', '*'))).each do |model|
  require model
end
