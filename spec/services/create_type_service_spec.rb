#-- encoding: UTF-8



require 'spec_helper'
require 'services/shared_type_service'

describe CreateTypeService do
  let(:type) { instance.type }
  let(:user) { FactoryBot.build_stubbed(:admin) }

  let(:instance) { described_class.new(user) }
  let(:service_call) { instance.call({ name: 'foo' }.merge(params), {}) }

  it_behaves_like 'type service'
end
