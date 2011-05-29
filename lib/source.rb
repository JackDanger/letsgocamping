require 'sqlite3'
require 'activesupport'
require 'nokogiri'
module Recreation
  class Source < Leviticus::Source
    DataDotGov = File.join File.dirname(__FILE__), '..', 'vendor', 'us_government_recreation_sites_and_facilities.xml'

    def initialize
      @content = File.read DataDotGov
    end

    def compile
      parse_xml!
    end

    protected
      def database
        @database ||= SQLite3::Database.new "test.db"
      end

      def parse_xml!
        @doc = Nokogiri::XML.parse @content
        xml_node_types.each do |node_type|
          @doc.search node_type do |variable|
            
          end
        end
      end

      def xml_node_types
        %w{
          arc:Event
          arc:Facility
          arc:FacilityActivity
          arc:FacilityAddress
          arc:FacilityEvent
          arc:OrgFacilityRole
          arc:OrgRecAreaRole
          arc:Organization
          arc:RecArea
          arc:RecAreaActivity
          arc:RecAreaAddress
          arc:RecAreaAdvisory
          arc:RecAreaEvent
          arc:RecAreaFacility
          arc:RecreationalActivity
        }
      end
  end
end