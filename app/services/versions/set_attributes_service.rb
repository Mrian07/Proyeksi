#-- encoding: UTF-8

module Versions
  class SetAttributesService < ::BaseServices::SetAttributes
    private

    def set_default_attributes(*)
      return unless model.new_record?

      model.sharing ||= 'none'
      model.status ||= 'open'
    end
  end
end
