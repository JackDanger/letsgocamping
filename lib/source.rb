module Recreation
  class Source < Leviticus::Source
    DataDotGov = File.join File.dirname(__FILE__), '..', 'vendor', 'us_government_recreation_sites_and_facilities.xml'

    def initialize
      require 'activesupport'
      @content = File.read DataDotGov
    end

    def compile
      parse_xml!
    end

    protected

      def parse_xml!
        @hash = Hash.from_xml @content
      end
  end
end