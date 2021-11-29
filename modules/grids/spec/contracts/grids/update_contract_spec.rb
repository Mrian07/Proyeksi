#-- encoding: UTF-8



require 'spec_helper'
require_relative './shared_examples'

describe Grids::UpdateContract do
  include_context 'model contract'
  include_context 'grid contract'

  it_behaves_like 'shared grid contract attributes'

  describe 'type' do
    before do
      grid.type = 'Grid'
    end

    it 'is not writable' do
      expect(instance.validate)
        .to be_falsey
    end

    it 'explains the not writable error' do
      instance.validate
      # scope because that is what type is called on the outside for grids
      expect(instance.errors.details[:scope])
        .to match_array [{ error: :error_readonly }, { error: :inclusion }]
    end
  end

  describe 'user_id' do
    it_behaves_like 'is not writable' do
      let(:model) { grid }
      let(:attribute) { :user_id }
      let(:value) { 5 }
    end
  end

  describe 'project_id' do
    it_behaves_like 'is not writable' do
      let(:model) { grid }
      let(:attribute) { :project_id }
      let(:value) { 5 }
    end
  end
end
