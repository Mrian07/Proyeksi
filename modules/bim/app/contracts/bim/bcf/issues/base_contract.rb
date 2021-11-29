#-- encoding: UTF-8



module Bim::Bcf
  module Issues
    class BaseContract < ::ModelContract
      include ::Bim::Bcf::Concerns::ManageBcfGuarded

      attribute :index
    end
  end
end
