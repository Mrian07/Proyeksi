#-- encoding: UTF-8

##
# A custom option is a possible value for a given custom field
# which is restricted to a set of specific values.
class CustomOption < ApplicationRecord
  acts_as_list

  belongs_to :custom_field, touch: true

  validates :value, presence: true, length: { maximum: 255 }

  before_destroy :assure_at_least_one_option

  def to_s
    value
  end

  alias :name :to_s

  protected

  def assure_at_least_one_option
    return if CustomOption.where(custom_field_id: custom_field_id).where.not(id: id).count > 0

    errors[:base] << I18n.t(:'activerecord.errors.models.custom_field.at_least_one_custom_option')

    throw :abort
  end
end
