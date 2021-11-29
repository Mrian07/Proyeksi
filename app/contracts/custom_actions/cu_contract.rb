#-- encoding: UTF-8



require 'model_contract'

# Contract for create (c) and update (u)
module CustomActions
  class CuContract < ::ModelContract
    def self.model
      CustomAction
    end

    def initialize(model, user = nil)
      super(model, user)
    end

    attribute :name
    attribute :description

    attribute :actions do
      if model.actions.empty?
        errors.add :actions, :empty
      end
      model.actions.each do |action|
        action.validate(errors)
      end
    end

    attribute :conditions do
      model.conditions.each do |condition|
        condition.validate(errors)
      end
    end
  end
end
