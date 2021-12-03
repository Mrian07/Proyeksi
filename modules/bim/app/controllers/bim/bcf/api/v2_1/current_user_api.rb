

module Bim::Bcf::API::V2_1
  class CurrentUserAPI < ::API::ProyeksiAppAPI
    resources :'current-user' do
      get &::Bim::Bcf::API::V2_1::Endpoints::Show.new(model: User,
                                                      instance_generator: ->(*) { current_user }).mount
    end
  end
end
