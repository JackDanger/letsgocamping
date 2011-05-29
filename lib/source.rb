require 'activesupport'
require 'nokogiri'
module Recreation
  class Source < Leviticus::Source

    DataDotGov = File.join File.dirname(__FILE__), '..', 'vendor', 'us_government_recreation_sites_and_facilities.xml'

    def initialize
      @data = File.open DataDotGov
    end

    def compile
      parse_xml!
    end

    protected
      def parse_xml!
        @doc = Nokogiri::XML @data
        models.each do |model|
          @doc.xpath("//arc:#{model}").each_with_index do |node, idx|
            if 0 == idx
              # create the table
              model.create_schema_from_xml node
            end
            model.create_from_xml node
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