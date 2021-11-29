#-- encoding: UTF-8



require 'spec_helper'
require 'services/base_services/behaves_like_update_service'

describe Messages::UpdateService, type: :model do
  it_behaves_like 'BaseServices update service'
end
