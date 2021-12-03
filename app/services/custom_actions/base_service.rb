#-- encoding: UTF-8

class CustomActions::BaseService
  include Shared::BlockService

  attr_accessor :user

  def call(attributes:,
           action:,
           &block)
    set_attributes(action, attributes)

    contract = CustomActions::CuContract.new(action)
    result = ServiceResult.new(success: contract.validate && action.save,
                               result: action,
                               errors: contract.errors)

    block_with_result(result, &block)
  end

  private

  def set_attributes(action, attributes)
    actions_attributes = attributes.delete(:actions)
    conditions_attributes = attributes.delete(:conditions)
    action.attributes = attributes

    set_actions(action, actions_attributes.symbolize_keys) if actions_attributes
    set_conditions(action, conditions_attributes.symbolize_keys) if conditions_attributes
  end

  def set_actions(action, actions_attributes)
    existing_action_keys = action.actions.map(&:key)

    remove_actions(action, existing_action_keys - actions_attributes.keys)
    update_actions(action, actions_attributes.slice(*existing_action_keys))
    add_actions(action, actions_attributes.slice(*(actions_attributes.keys - existing_action_keys)))
  end

  def remove_actions(action, keys)
    keys.each do |key|
      remove_action(action, key)
    end
  end

  def update_actions(action, key_values)
    key_values.each do |key, values|
      update_action(action, key, values)
    end
  end

  def add_actions(action, key_values)
    key_values.each do |key, values|
      add_action(action, key, values)
    end
  end

  def update_action(action, key, values)
    action.actions.detect { |a| a.key == key }.values = values
  end

  def add_action(action, key, values)
    action.actions << available_action_for(action, key).new(values)
  end

  def remove_action(action, key)
    action.actions.reject! { |a| a.key == key }
  end

  def set_conditions(action, conditions_attributes)
    action.conditions = conditions_attributes.map do |key, values|
      available_condition_for(action, key).new(values)
    end
  end

  def available_action_for(action, key)
    action.available_actions.detect { |a| a.key == key } || CustomActions::Actions::Inexistent
  end

  def available_condition_for(action, key)
    action.available_conditions.detect { |a| a.key == key } || CustomActions::Conditions::Inexistent
  end
end
