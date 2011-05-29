module Leviticus
  class Source

    attr_reader :content
    attr_accessor :owner

    def process *media
      run_compiler!
      media.each do |medium|
        yield medium
      end
    end

    protected

      def run_compiler!
        unless respond_to? :compile
          raise <<-DOC
            Please define a `compile` method to your #{self.class} class.
            This should read all source data and instantiate each page object,
            assigning to each page the values needed to render a complete html document.
          DOC
        end
        compile
      end
  end
end