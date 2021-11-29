#-- encoding: UTF-8



module Bim::Bcf::API::V2_1
  class BaseRepresenter < Roar::Decorator
    include Representable::JSON

    defaults render_nil: true

    def datetime_formatter
      ::API::V3::Utilities::DateTimeFormatter
    end
  end
end
