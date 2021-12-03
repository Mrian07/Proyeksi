#-- encoding: UTF-8

class CustomValue < ApplicationRecord
  belongs_to :custom_field
  belongs_to :customized, polymorphic: true

  validate :validate_presence_of_required_value
  validate :validate_format_of_value
  validate :validate_type_of_value
  validate :validate_length_of_value

  delegate :typed_value,
           :formatted_value,
           to: :strategy

  delegate :editable?,
           :visible?,
           :required?,
           :max_length,
           :min_length,
           to: :custom_field

  def to_s
    value.to_s
  end

  def value=(val)
    parsed_value = strategy.parse_value(val)

    super(parsed_value)
  end

  def strategy
    @strategy ||= begin
                    format = custom_field&.field_format || 'empty'
                    ProyeksiApp::CustomFieldFormat.find_by_name(format).formatter.new(self)
                  end
  end

  protected

  def validate_presence_of_required_value
    errors.add(:value, :blank) if custom_field.required? && !strategy.value_present?
  end

  def validate_format_of_value
    if value.present? && custom_field.has_regexp? && !(value =~ Regexp.new(custom_field.regexp))
      errors.add(:value, :invalid)
    end
  rescue RegexpError => e
    errors.add(:base, :regex_invalid)
    Rails.logger.error "Custom Field ID#{custom_field_id} has an invalid regex: #{e.message}"
  end

  def validate_type_of_value
    if value.present?
      validation_error = strategy.validate_type_of_value
      if validation_error
        errors.add(:value, validation_error)
      end
    end
  end

  def validate_length_of_value
    if value.present? && (min_length.present? || max_length.present?)
      validate_min_length_of_value
      validate_max_length_of_value
    end
  end

  private

  def validate_min_length_of_value
    errors.add(:value, :too_short, count: min_length) if min_length > 0 && value.length < min_length
  end

  def validate_max_length_of_value
    errors.add(:value, :too_long, count: max_length) if max_length > 0 && value.length > max_length
  end
end
