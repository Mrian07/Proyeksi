

module Bim::Bcf::API::V2_1
  module ProjectExtensions
    class API < ::API::OpenProjectAPI
      get :extensions do
        work_package = WorkPackage.new project: @project
        contract = WorkPackages::CreateContract.new(work_package, current_user)
        Representer.new(contract)
      end
    end
  end
end
