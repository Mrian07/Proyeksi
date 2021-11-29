#-- encoding: UTF-8



module Bim::Bcf::API::V2_1::Errors
  class ErrorMapper
    extend ActiveModel::Naming
    extend ActiveModel::Translation

    def read_attribute_for_validation(_attr)
      nil
    end

    # In case the error lookups collide, we need to provide
    # separate error mappers for every class.
    def self.lookup_ancestors
      [::Bim::Bcf::Issue, ::Bim::Bcf::Viewpoint]
    end

    def self.map(original_errors)
      mapped_errors = ActiveModel::Errors.new(new)

      original_errors.details.each do |key, errors|
        errors.each do |error|
          mapped_errors.add(error_key_mapper(key), error[:error], *error.except(:error))
        end
      end

      mapped_errors
    end

    def self.i18n_scope
      :activerecord
    end

    def self.error_key_mapper(key)
      { subject: :title,
        json_viewpoint: :base }[key] || key
    end
  end
end
