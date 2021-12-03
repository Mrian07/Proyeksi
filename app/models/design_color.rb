class DesignColor < ApplicationRecord
  after_commit -> do
    # CustomStyle.current.updated_at determines the cache key for inline_css
    # in which the CSS color variables will be overwritten. That is why we need
    # to ensure that a CustomStyle.current exists and that the time stamps change
    # whenever we change a color_variable.
    if CustomStyle.current
      CustomStyle.current.touch
    else
      CustomStyle.create
    end
  end

  before_validation :normalize_hexcode

  validates_uniqueness_of :variable
  validates_presence_of :hexcode, :variable
  validates_format_of :hexcode, with: /\A#[0-9A-F]{6}\z/, unless: lambda { |e| e.hexcode.blank? }

  class << self
    def setables
      overwritten_values = overwritten
      ProyeksiApp::CustomStyles::Design.customizable_variables.map do |varname|
        overwritten_value = overwritten_values.detect { |var| var.variable == varname }
        overwritten_value || new(variable: varname)
      end
    end

    def overwritten
      overridable = ProyeksiApp::CustomStyles::Design.customizable_variables

      all.to_a.select do |color|
        overridable.include?(color.variable) && color.hexcode.present?
      end
    end
  end

  protected

  # This could be DRY! This method is taken from model Color.
  def normalize_hexcode
    if hexcode.present? and hexcode_changed?
      self.hexcode = hexcode.strip.upcase

      unless hexcode.starts_with? '#'
        self.hexcode = '#' + hexcode
      end

      if hexcode.size == 4 # =~ /#.../
        self.hexcode = hexcode.gsub(/([^#])/, '\1\1')
      end
    end
  end
end
