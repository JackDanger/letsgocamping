require 'sqlite3'
require 'activesupport'
require 'nokogiri'
module Recreation
  class Source < Leviticus::Source

    DataDotGov = File.join File.dirname(__FILE__), '..', 'vendor', 'us_government_recreation_sites_and_facilities.xml'
    DBFile     = File.join File.dirname(__FILE__), '..', 'vendor', 'db.sqlite'

    def initialize
      @data = File.open DataDotGov
    end

    def compile
      parse_xml!
    end

    protected
      def database
        @database ||= SQLite3::Database.new DBFile
      end

      def parse_xml!
        @doc = Nokogiri::XML @data
        models.each do |model|
          @doc.xpath("//arc:#{model}").each do |node|
            model.create_from_xml node
            return
          end
        end
      end

      def models
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
        }.map(&:constantize)
      end
  end
end