

module API
  module Decorators
    module MetaForm
      def payload_representer
        payload_representer_class
          .create(represented, meta: meta, current_user: current_user)
      end
    end
  end
end
