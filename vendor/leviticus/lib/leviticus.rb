require File.expand_path File.join(File.dirname(__FILE__), 'source')
require File.expand_path File.join(File.dirname(__FILE__), 'page')

module Leviticus
  extend self

  def self.included klass
    klass.instance_eval do
      extend Leviticus
    end
  end

  def output_to site
    @site = site
  end

  def views_directory views
    @views = views
  end

  def source source_class = nil
    @source = source_class.new if source_class
    @source
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

  def process! media = [:html]
    raise "Source content not yet supplied" unless @source
    @source.process media do |medium|
      index.prepare
      pages.each do |page_class|
        next if index.class == page_class
        page_class.each do |page|
          page.prepare
        end
      end
      write_all media
    end
  end

  def write_all media = [:html]
    Dir.mkdir @site rescue ''
    media.each do |medium|
      pages.each do |page_class|
        page_class.each do |page|
          page.medium = medium
          page.write
          print '.'
          STDOUT.flush
        end
      end
      puts "Wrote #{pages.sum {|_,p| p.size}} pages"
    end
  end

  # swiped from ActiveSupport
  def underscore word
    word = word.to_s.dup
    word.gsub! /([A-Z]+)([A-Z][a-z])/,'\1_\2'
    word.gsub! /([a-z\d])([A-Z])/,'\1_\2'
    word.tr! "-", "_"
    word.downcase!
    word
  end
end