require 'sqlite3'
require 'activesupport'
require 'nokogiri'
module Recreation
  class Source < Leviticus::Source

    DataDotGov = File.join File.dirname(__FILE__), '..', 'vendor', 'us_government_recreation_sites_and_facilities.xml'
    DBFile     = File.join File.dirname(__FILE__), '..', 'vendor', 'db.sqlite'

    def initialize
      @content = File.read DataDotGov
    end

    def compile
      parse_xml!
    end

    protected
      def database
        @database ||= SQLite3::Database.new DBFile
      end

      def parse_xml!
        @doc = Nokogiri::XML.parse @content
        xml_record_types.each do |record_type|
          @doc.search "arc:#{record_type}" do |variable|
            p variable
          end
          break
        end
      end

      def xml_record_types
        %w{
          Event
          Facility
          FacilityActivity
          FacilityAddress
          FacilityEvent
          OrgFacilityRole
          OrgRecAreaRole
          Organization
          RecArea
          RecAreaActivity
          RecAreaAddress
          RecAreaAdvisory
          RecAreaEvent
          RecAreaFacility
          RecreationalActivity
        }
      end
  end
end