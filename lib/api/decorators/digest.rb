#-- encoding: UTF-8



module API
  module Decorators
    class Digest < Single
      def initialize(model, algorithm:)
        @algorithm = algorithm

        super(model, current_user: nil)
      end

      property :algorithm,
               exec_context: :decorator,
               getter: ->(*) { @algorithm },
               writable: false,
               render_nil: true
      property :hash,
               exec_context: :decorator,
               getter: ->(*) { represented },
               render_nil: true
    end
  end
end
