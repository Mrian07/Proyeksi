#-- encoding: UTF-8



module Bim::Bcf::API::V2_1::Errors
  class ErrorRepresenter < Bim::Bcf::API::V2_1::BaseRepresenter
    property :message,
             getter: ->(*) {
               [message].concat(Array(errors).map(&:message)).compact.join(' ')
             },
             render_nil: true
  end
end
