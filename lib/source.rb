module Recreation
  class Source < Leviticus
    DataDotGov = File.join File.dirname(__FILE__), '..', 'vendor', 'us_government_recreation_sites_and_facilities.xml'

    def initialize
      @content = File.read DataDotGov
    end

    def compile
      parse_xml src
    end
  end
end