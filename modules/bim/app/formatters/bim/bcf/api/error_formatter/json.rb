#-- encoding: UTF-8



module Bim::Bcf
  module API
    module ErrorFormatter
      module Json
        extend Grape::ErrorFormatter::Base

        class << self
          def call(message, _backtrace, _options = {}, env = nil, _original_exception = nil)
            present(message, env)
          end
        end
      end
    end
  end
end
