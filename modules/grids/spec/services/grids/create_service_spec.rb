#-- encoding: UTF-8



require 'spec_helper'
require 'services/base_services/behaves_like_create_service'

describe Grids::CreateService, type: :model do
  it_behaves_like 'BaseServices create service' do
    let(:model_class) { Grids::Grid }
  end
end
