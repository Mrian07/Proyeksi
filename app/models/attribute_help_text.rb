

class AttributeHelpText < ApplicationRecord
  acts_as_attachable viewable_by_all_users: true

  def self.available_types
    subclasses.map { |child| child.name.demodulize }
  end

  def self.used_attributes(type)
    where(type: type)
      .select(:attribute_name)
      .distinct
      .pluck(:attribute_name)
  end

  def self.all_by_scope
    all.group_by(&:attribute_scope)
  end

  def self.visible(user)
    scope = AttributeHelpText.subclasses[0].visible_condition(user)

    AttributeHelpText.subclasses[1..-1].each do |subclass|
      scope = scope.or(subclass.visible_condition(user))
    end

    scope
  end

  validates :help_text, presence: true
  validates :attribute_name, uniqueness: { scope: :type }

  def attribute_caption
    @attribute_caption ||= self.class.available_attributes[attribute_name]
  end

  def attribute_scope
    self.class.to_s.demodulize
  end

  def type_caption
    raise NotImplementedError
  end

  def self.visible_condition
    raise NotImplementedError
  end

  def self.available_attributes
    raise NotImplementedError
  end
end

require_dependency 'attribute_help_text/work_package'
require_dependency 'attribute_help_text/project'
