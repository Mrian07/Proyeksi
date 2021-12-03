#-- encoding: UTF-8



module ProyeksiApp
  module SafeParams
    def safe_query_params(whitelist = [], current_request = request)
      current_request.query_parameters.select { |k, _| whitelist.include?(k) }
    end

    def pagination_params_whitelist(current_request = request)
      safe_query_params(%w(per_page page), current_request)
    end
  end
end
