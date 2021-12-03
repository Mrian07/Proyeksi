

module Bim::Bcf::API::V2_1
  class AuthAPI < ::API::ProyeksiAppAPI
    resources :auth do
      get do
        ::Bim::Bcf::API::V2_1::Auth::SingleRepresenter.new(nil)
      end
    end
  end
end
