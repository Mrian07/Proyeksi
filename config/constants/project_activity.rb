#-- encoding: UTF-8



module Constants
  module ProjectActivity
    class << self
      def register(on:, attribute:, chain: [])
        @registered ||= []

        @registered << { on: on,
                         chain: chain,
                         attribute: attribute }
      end

      attr_reader :registered
    end
  end
end
