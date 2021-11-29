

class ExportCardConfiguration < ApplicationRecord
  class RowsYamlValidator < ActiveModel::Validator
    REQUIRED_GROUP_KEYS = ["rows"]
    VALID_GROUP_KEYS = ["rows", "has_border", "height"]
    REQUIRED_ROW_KEYS = ["columns"]
    VALID_ROW_KEYS = ["columns", "height", "priority"]
    # TODO: Security Consideration
    # Should we define which model properties are visible and if so how?
    # VALID_MODEL_PROPERTIES = [""]
    REQUIRED_COLUMN_KEYS = []
    VALID_COLUMN_KEYS = ["has_label", "min_font_size", "max_font_size",
                         "font_size", "font_style", "text_align", "minimum_lines", "render_if_empty",
                         "width", "indented", "custom_label", "has_count"]
    NUMERIC_COLUMN_VALUE = ["min_font_size", "max_font_size", "font_size", "minimum_lines"]

    def raise_yaml_error
      raise ArgumentError, I18n.t('validation_error_yaml_is_badly_formed')
    end

    def assert_required_keys(hash, valid_keys, required_keys)
      raise_yaml_error if !hash.is_a?(Hash)

      begin
        hash.assert_valid_keys valid_keys
      rescue ArgumentError => e
        # Small hack alert: Catch a raise error again but with localised text
        raise ArgumentError, "#{I18n.t('validation_error_uknown_key')} '#{e.message.split(': ')[1]}'"
      end

      pending_keys = required_keys - hash.keys
      unless pending_keys.empty?
        raise(ArgumentError,
              "#{I18n.t('validation_error_required_keys_not_present')} #{pending_keys.join(', ')}")
      end
    end

    def check_valid_value_type(value, type)
      raise(ArgumentError, I18n.t('validation_error_yaml_is_badly_formed').to_s) unless value.is_a? type
    end

    def validate(record)
      begin
        if record.rows.nil? || !(YAML::load(record.rows)).is_a?(Hash)
          record.errors[:rows] << I18n.t('validation_error_yaml_is_badly_formed')
          return false
        end
      rescue Psych::SyntaxError => e
        record.errors[:rows] << I18n.t('validation_error_yaml_is_badly_formed')
        return false
      end

      begin
        groups = YAML::load(record.rows)
        groups.each do |_gk, gv|
          assert_required_keys(gv, VALID_GROUP_KEYS, REQUIRED_GROUP_KEYS)
          raise_yaml_error if !gv["rows"].is_a?(Hash)
          gv["rows"].each do |_rk, rv|
            assert_required_keys(rv, VALID_ROW_KEYS, REQUIRED_ROW_KEYS)
            raise_yaml_error if !rv["columns"].is_a?(Hash)
            rv["columns"].each do |_ck, cv|
              assert_required_keys(cv, VALID_COLUMN_KEYS, REQUIRED_COLUMN_KEYS)
              cv.map { |cname, cvalue| check_valid_value_type(cvalue, Numeric) if NUMERIC_COLUMN_VALUE.include?(cname) }
            end
          end
        end
      rescue ArgumentError => e
        record.errors[:rows] << "#{I18n.t('yaml_error')} #{e.message}"
      end
    end
  end

  include OpenProject::PDFExport::Exceptions

  validates :name, presence: true
  validates :rows, rows_yaml: true
  validates :per_page, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :page_size, inclusion: { in: %w(A4) }, allow_nil: false
  validates :orientation, inclusion: { in: %w(landscape portrait) }, allow_nil: true

  scope :active, -> { where(active: true) }

  def self.default
    ExportCardConfiguration.active.select { |c| c.is_default? }.first || ExportCardConfiguration.active.first
  end

  def activate
    update!({ active: true })
  end

  def deactivate
    if !is_default?
      update!({ active: false })
    else
      false
    end
  end

  def landscape?
    !portrait?
  end

  def portrait?
    orientation == "portrait"
  end

  def rows_hash
    config = YAML::load(rows)
    raise BadlyFormedExportCardConfigurationError.new(I18n.t('validation_error_yaml_is_badly_formed')) if !config.is_a?(Hash)

    config
  end

  def is_default?
    name.downcase == "default"
  end

  def can_delete?
    !is_default?
  end

  def can_activate?
    !active
  end

  def can_deactivate?
    active && !is_default?
  end
end
