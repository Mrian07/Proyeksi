module API
  module V3
    module Utilities
      module EpropsConversion
        def raise_invalid_eprops(error, i18n_key)
          mapped_error = OpenStruct.new(params: [:eprops], message: I18n.t(i18n_key, message: error.message))
          raise ::Grape::Exceptions::ValidationErrors.new errors: [mapped_error]
        end

        def transform_eprops
          if params && params[:eprops]
            props = ::JSON.parse(Zlib::Inflate.inflate(Base64.decode64(params[:eprops]))).with_indifferent_access
            params.merge!(props)
          end
        rescue Zlib::DataError => e
          raise_invalid_eprops(e, 'api_v3.errors.eprops.invalid_gzip')
        rescue JSON::ParserError, NoMethodError => e
          raise_invalid_eprops(e, 'api_v3.errors.eprops.invalid_json')
        end
      end
    end
  end
end
