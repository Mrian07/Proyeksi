#-- encoding: UTF-8



require 'spec_helper'
require 'services/base_services/behaves_like_create_service'

describe PlaceholderUsers::CreateService, type: :model do
  it_behaves_like 'BaseServices create service'
end
