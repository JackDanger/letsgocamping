module Recreation
  module FromXML
    def create_schema_from_xml nokogiri
      return if table_exists?
      connection.create_table table_name, :id => false do |t|
        nokogiri.css("*").each do |attr|
          column_name = attribute_name_for(attr.name)
          column_type = case column_name
          when /_?id$/
            t.integer column_name
          when /latitude|longitude/
            t.decimal column_name
          else
            t.string  column_name
          end
        end
      end
    end

    def create_from_xml nokogiri
      record = new
      nokogiri.css("*").each do |attr|

        column_name = attribute_name_for attr.name
        content =
          if column_name =~ /latitude|longitude/
            # 362915N
            coord = attr.content.sub(/[NSEW]$/, '').to_f
            coord > 10_000 ? coord / 10_000 : coord
          else
            attr.content
          end

        record.send column_name + '=', content
      end

      record.save
    rescue => e
      p e
      p record
    end

    def attribute_name_for xml_node_name
      model_name_start = name.underscore.split('_').first.camelize
      xml_node_name.sub(/^#{model_name_start}(.*)$/, '\1').underscore
    end
  end
end