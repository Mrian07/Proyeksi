#-- encoding: UTF-8

module CustomFields
  class CreateService < ::BaseServices::Create
    def self.careful_new_custom_field(type)
      if type.to_s =~ /.+CustomField\z/
        klass = type.to_s.constantize
        klass.new if klass.ancestors.include? CustomField
      end
    rescue NameError => e
      Rails.logger.error "#{e.message}:\n#{e.backtrace.join("\n")}"
      nil
    end

    def perform(params)
      super
    rescue StandardError => e
      ServiceResult.new(success: false, message: e.message)
    end

    def instance(params)
      cf = self.class.careful_new_custom_field(params[:type])
      raise ArgumentError.new("Invalid CF type") unless cf

      cf
    end

    def after_perform(call)
      cf = call.result

      if cf.is_a?(ProjectCustomField)
        add_cf_to_visible_columns(cf.id)
      end

      call
    end

    private

    def add_cf_to_visible_columns(id)
      Setting.enabled_projects_columns = (Setting.enabled_projects_columns + ["cf_#{id}"]).uniq
    end
  end
end
