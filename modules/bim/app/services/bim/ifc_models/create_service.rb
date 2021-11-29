

module Bim
  module IfcModels
    class CreateService < ::BaseServices::Create
      protected

      def after_perform(call)
        if call.success?
          IfcConversionJob.perform_later(call.result)
        end

        call
      end

      def instance(_params)
        ::Bim::IfcModels::IfcModel.new
      end
    end
  end
end
