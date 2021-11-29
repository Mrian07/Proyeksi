

module Bim::Bcf
  module Issues
    class DeleteContract < ::DeleteContract
      delete_permission :delete_bcf
    end
  end
end
