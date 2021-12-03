#-- encoding: UTF-8

module Shared::BlockService
  def block_with_result(result, &_block)
    if block_given?
      yield result
    else
      result
    end
  end
end
