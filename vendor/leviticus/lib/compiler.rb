module Leviticus
  class Source

    def initialize source
      @source = source
    end

    def process *media
      @compiled = run_compiler!
      write_layout media
    end

    def compile &block
      @compiler = block
    end

    protected

      def run_compiler!
        raise "Compiler not defined" unless @compiler
        @compiler.call @source
      end

      def write_layout media
        Leviticus.index.prepare
        Leviticus.pages.each do |page_class|
          next if Leviticus.index.class == page_class
          page_class.each do |page|
            page.prepare
          end
        end
        Leviticus.write_all media
      end

      def each_book
        ret = []
        @source.split(/^Book*/).each do |book|
          next unless book =~ /^ (\d\d) (.*)/
          header       = book[/^ (\d\d) (.*)/]
          number, name = book.scan(/^ (\d\d) (.*)/).first.flatten
          puts ''
          print "compiling: #{name} "
          book         = book[header.size, book.size] # trim the header
          chapters     = yield book
          ret << { :name => name,
                   :number => number,
                   :chapters => chapters }
        end
        ret
      end

      def each_chapter string
        marker = '001'
        ret = []
        begin
          print '.'
          STDOUT.flush
          index = string.index /^#{marker}:/
          next_index = string.index /^#{marker.succ}:/
          endpoint = next_index ? next_index : string.size
          verses = yield string[index, endpoint-index]
          ret << {:number => marker.dup,
                  :verses => verses}
          marker.succ!
        end while next_index
        ret
      end

      def each_verse string
        marker = '001'
        ret = []
        begin
          index = string.index /^\d\d\d:#{marker}/
          line  = string[/^\d\d\d:#{marker}\s?/]
          next_index = string.index /^\d\d\d:#{marker.succ}/
          endpoint = next_index ? next_index : string.size
          text = yield string[index + line.size, endpoint - index - line.size]
          ret << {:number => marker.dup,
                  :text   => text}
          marker.succ!
        end while next_index
        ret
      end

      def normalize string
        string.gsub(/[\s\n]+/, ' ').sub(/^[\s\n]|[\s\n]$/, '')
      end

      def strip_comments string
        string = string.gsub(/<</, '(').gsub(/>>/, ')')
        string = string.gsub /(.*)?(\{.*\})(.*)?/, '\1\3'
        string = string.gsub /\[(.*)\]/, '\1'
        string
      end

      def feminize string
        Gender.feminize_text string
      end

      def set_feminizing_forms
        Feminizer.forms = SilentVoices::Gender.forms
      end
  end
end