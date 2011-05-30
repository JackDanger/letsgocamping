module Leviticus
  module Page
    def self.all
      @all ||= []
    end

    def self.index
      all.detect {|klass| 'Index' == klass.name.split(':').last }
    end

    def self.included klass
      all << klass
      klass.instance_exec do
        attr_accessor :path, :title, :medium
        extend Leviticus::Page::ClassMethods
      end
      define_enumerable_on klass
    end

    def self.define_enumerable_on klass
      unless respond_to?(:each)
        if respond_to? :all
          def each
            all.each
          end
        elsif respond_to?(:find_all)
          def each
            find_all.each
          end
        else
          raise "Please define the method `each` on #{klass}"
        end
      end
    end

    def prepare
      raise <<-DOC
        Please subclass the prepare method on #{self.class}.
        This is where you set up all page content before the view is processed.
        Any data that you want to use in your view must be available as an instance
        method on #{self.class}.
        Either write these methods explicitly or call `locals` to pass in simple values
      DOC
    end

    def write
      File.open(outfile, 'w') {|f| f.write render }
    end

    def render
      template.render(self) {
        view.render(self)
      }
    end

    def template
      template_file    = File.join Leviticus.views, "template.#{medium}.haml"
      template_content = File.read template_file
      Haml::Engine.new template_content, :filename => 'template'
    end

    def view
      view_file    = File.join Leviticus.views, "#{Leviticus.underscore self.class.name}.#{medium}.haml"
      view_content = File.read view_file
      Haml::Engine.new view_content, :filename => src
    end

    module ClassMethods
      # Add a method to your page to make that value available in the view
      # as a helper method:
      #
      #  class MySpecialPage < Leviticus::Page
      #    def page_number
      #      data[:current_page] # assuming you've implemented 'data' elsewhere
      #    end
      #  end
      #
      # Add any simple values you want to the page (like page number or author)
      # just by calling locals:
      #
      #  class MySpecialPage < Leviticus::Page
      #    locals :author => "Jack Danger",
      #           :show_contact_form => true
      #
      def locals variables
        variables.each do |key, value|
          if respond_to?(key)
            raise %Q{#{self.class} already has a "#{key}" method, pick a different name}
          end
          define_method(key) { value }
        end
      end
    end
  end
end