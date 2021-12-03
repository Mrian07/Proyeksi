#-- encoding: UTF-8

module API
  module Errors
    class InvalidRequestBody < ErrorBase
      identifier 'InvalidRequestBody'
      code 400
    end
  end
end
