#-- encoding: UTF-8



require 'grids/base_contract'

module Grids
  class CreateContract < BaseContract
    attribute :user_id,
              writeable: -> { !!model.class.reflect_on_association(:user) }

    attribute :project_id,
              writeable: -> { !!model.class.reflect_on_association(:project) }

    attribute :type

    def writable?(attribute)
      attribute == :scope || super
    end

    def assignable_scopes
      Grids::Configuration.all_scopes
    end
  end
end
