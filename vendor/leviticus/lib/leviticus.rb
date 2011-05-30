require File.expand_path File.join(File.dirname(__FILE__), 'source')
require File.expand_path File.join(File.dirname(__FILE__), 'page')
module Leviticus
  def self.options
    @options ||= {}
  end

  def self.options= hash
    @options = hash
  end
end
