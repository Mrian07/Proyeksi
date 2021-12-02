#-- encoding: UTF-8



module ProyeksiApp::TextFormatting::Formats
  class BaseFormatter
    attr_reader :context,
                :pipeline

    def initialize(context)
      @context = context
      @pipeline = HTML::Pipeline.new(located_filters, context)
    end

    def to_html(text)
      raise NotImplementedError
    end

    protected

    def filters
      []
    end

    def located_filters
      filters.map do |f|
        if [Symbol, String].include? f.class
          ProyeksiApp::TextFormatting::Filters.const_get("#{f}_filter".classify)
        else
          f
        end
      end
    end
  end
end
