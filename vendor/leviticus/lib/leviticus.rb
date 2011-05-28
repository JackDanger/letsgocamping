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

    def index page = nil
      @index = page if page
      @index
    end

    def write_all media = [:html]
      Dir.mkdir @site rescue ''
      media.each do |medium|
        Leviticus.pages.each do |page_class|
          page_class.each do |page|
            page.medium = medium
            page.write
            print '.'
            STDOUT.flush
          end
        end
        puts "Wrote #{Leviticus.pages.sum {|_,pages| pages.size}} pages"
      end
    end
  end
end