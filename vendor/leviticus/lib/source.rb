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
  end
end