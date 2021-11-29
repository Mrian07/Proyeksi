

class CostType < ApplicationRecord
  has_many :material_budget_items
  has_many :cost_entries, dependent: :destroy
  has_many :rates, class_name: 'CostRate', foreign_key: 'cost_type_id', dependent: :destroy

  validates_presence_of :name, :unit, :unit_plural
  validates_uniqueness_of :name

  after_update :save_rates

  include ActiveModel::ForbiddenAttributesProtection

  scope :active, -> { where(deleted_at: nil) }

  # finds the default CostType
  def self.default
    CostType.find_by(default: true) || CostType.first
  end

  def is_default?
    default
  end

  def <=>(other)
    name.downcase <=> other.name.downcase
  end

  def current_rate
    rate_at(Date.today)
  end

  def rate_at(date)
    CostRate.where(['cost_type_id = ? and valid_from <= ?', id, date])
            .order(Arel.sql('valid_from DESC'))
            .first
  end

  def visible?(user)
    user.admin?
  end

  def to_s
    name
  end

  def new_rate_attributes=(rate_attributes)
    rate_attributes.each do |_index, attributes|
      attributes[:rate] = Rate.parse_number_string(attributes[:rate])
      rates.build(attributes)
    end
  end

  def existing_rate_attributes=(rate_attributes)
    rates.reject(&:new_record?).each do |rate|
      attributes = rate_attributes[rate.id.to_s]

      has_rate = false
      if attributes && attributes[:rate].present?
        attributes[:rate] = Rate.parse_number_string(attributes[:rate])
        has_rate = true
      end

      if has_rate
        rate.attributes = attributes
      else
        rates.delete(rate)
      end
    end
  end

  def save_rates
    rates.each(&:save!)
  end
end
