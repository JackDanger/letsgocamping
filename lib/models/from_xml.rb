module Recreation
  module FromXML
    def create_from_xml nokogiri
      record = new
      nokogiri.css("*").each do |attr|
        record.send attribute_setter_for(attr.name),
                    attr.content
      end
    end
  end
end