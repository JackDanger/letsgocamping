module Leviticus
  class Source

    attr_reader :content
    attr_accessor :owner

    # Configure the 
    def self.output_to site
      @site = site
    end

    def self.views_directory views
      @views = views
    end

    def site
      @@site  ||= File.expand_path File.join(`pwd`.chomp, '_site')
    end

    def views
      @@views ||= File.expand_path File.join(`pwd`.chomp, 'views')
    end

    def process! media = [:html]
      run_compiler!
      prepare_all media
      write_all   media
    end

    def prepare_all
      index_page_class = Leviticus::Page.index
      index_page_class.new.prepare
      Leviticus::Page.all.each do |page_class|
        puts "Preparing: #{page_class}"
        next if index_page_class == page_class
        page_class.each do |page|
          page.prepare
          print '.'
          STDOUT.flush
        end
      end
    end

    def write_all media
      Dir.mkdir @site rescue ''
      media.each do |medium|
        Leviticus::Page.all.each do |page_class|
          page_class.each do |page|
            page.medium = medium
            page.write
            print '.'
            STDOUT.flush
          end
          puts "Processing: #{page_class}"
        end
        puts "#{medium.to_s.upcase}: Wrote #{pages.sum {|_,p| p.size}} pages"
      end
    end

    protected

      def process *media
        run_compiler!
        media.each do |medium|
          yield medium
        end
      end

      def run_compiler!
        unless respond_to? :compile
          raise <<-DOC
            Please define a `compile` method to your #{self.class} class.
            This should read all source data and instantiate each page object,
            assigning to each page the values needed to render a complete html document.
          DOC
        end
        compile
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