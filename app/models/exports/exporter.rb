#-- encoding: UTF-8

module Exports
  class Exporter
    include Redmine::I18n
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::NumberHelper

    attr_accessor :object,
                  :options,
                  :current_user

    class_attribute :model

    def initialize(object, options = {})
      self.object = object
      self.options = options
      self.current_user = options.fetch(:current_user) { User.current }
    end

    def self.key
      name.demodulize.underscore.to_sym
    end

    # Remove characters that could cause problems on popular OSses
    def sane_filename(name)
      parts = name.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

      parts.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

      parts.join '.'
    end

    # Run the export, yielding the result of the render output
    def export!
      raise NotImplementedError
    end

    protected

    def formatter_for(attribute)
      ::Exports::Register.formatter_for(model, attribute)
    end

    def format_attribute(object, attribute, **options)
      formatter = formatter_for(attribute)
      formatter.format(object, **options)
    end
  end
end
