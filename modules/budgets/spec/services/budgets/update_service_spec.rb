#-- encoding: UTF-8



require 'spec_helper'
require 'services/base_services/behaves_like_update_service'

describe Budgets::UpdateService, type: :model do
  it_behaves_like 'BaseServices update service'
end
