module Leviticus
  class Source

    def initialize *args
      raise <<-DOC
        Please subclass the initialize method of your source.
        It should store a `@content` instance variable with the
        full contents of your source material
      DOC
    end

    def process *media
      run_compiler!
      write media
    end

    protected

      def run_compiler!
        unless respond_to? :compile
          raise <<-DOC
            Please define a `compile` method to your #{self.class} class.
            This should read the @content string and instantiate each page object,
            assigning to each page the values needed to render a complete html document.
          DOC
        end
        compile @content
      end

      def write media
        Leviticus.index.prepare
        Leviticus.pages.each do |page_class|
          next if Leviticus.index.class == page_class
          page_class.each do |page|
            page.prepare
          end
        end
        Leviticus.write_all media
      end
  end
end