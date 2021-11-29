

module Bim::Bcf
  module Viewpoints
    class DeleteContract < ::DeleteContract
      delete_permission :manage_bcf
    end
  end
end
