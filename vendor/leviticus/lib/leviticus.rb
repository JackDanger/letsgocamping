require File.expand_path File.join(File.dirname(__FILE__), 'compiler')
require File.expand_path File.join(File.dirname(__FILE__), 'page')

module Leviticus
  class << self
    def output_to site
      @site = site
    end

    def views_directory views
      @views = views
    end

    def site
      @site  ||= File.expand_path File.join(`pwd`.chomp, '_site')
    end

    def views
      @views ||= File.expand_path File.join(`pwd`.chomp, 'views')
    end

    def pages
      @pages ||= {}
    end
  end
end