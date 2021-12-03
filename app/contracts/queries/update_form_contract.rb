#-- encoding: UTF-8

require 'queries/base_contract'

module Queries
  class UpdateFormContract < BaseContract
    # Maintains validations from the base contract
    # to ensure users without saving permissions can still
    # alter existing queries through the form
  end
end
