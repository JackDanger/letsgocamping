require 'activesupport'
require 'nokogiri'
require File.expand_path File.join(File.dirname(__FILE__), '..', 'vendor', 'leviticus/lib/leviticus')

class Recreation < Leviticus::Source

  DataDotGov = File.join File.dirname(__FILE__), '..', 'vendor', 'us_government_recreation_sites_and_facilities.xml'

  def initialize
    @data = File.open DataDotGov
  end

  def compile
    p Leviticus::Page.all
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

require File.expand_path(File.join(File.dirname(__FILE__), 'data'))
Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), 'pages', '*'))).each do |page|
  require page
end
