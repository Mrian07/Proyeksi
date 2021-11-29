

module Bim::Bcf::API::V2_1
  class AuthAPI < ::API::OpenProjectAPI
    resources :auth do
      get do
        ::Bim::Bcf::API::V2_1::Auth::SingleRepresenter.new(nil)
      end
    end
  end
end
