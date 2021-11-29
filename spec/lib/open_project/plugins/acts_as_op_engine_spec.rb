

require 'spec_helper'
require 'roar/decorator'

describe OpenProject::Plugins::ActsAsOpEngine do
  class ActsAsOpEngineTestEngine < Rails::Engine
    include OpenProject::Plugins::ActsAsOpEngine
  end

  subject(:engine) { ActsAsOpEngineTestEngine }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:patches) }
  it { is_expected.to respond_to(:assets) }
  it { is_expected.to respond_to(:additional_permitted_attributes) }
  it { is_expected.to respond_to(:register) }

  describe '#name' do
    subject { engine.name }
    it { is_expected.to eq 'ActsAsOpEngineTestEngine' }
  end
end
