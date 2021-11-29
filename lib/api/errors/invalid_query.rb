#-- encoding: UTF-8



module API
  module Errors
    class InvalidQuery < ErrorBase
      identifier 'InvalidQuery'
      code 400
    end
  end
end
