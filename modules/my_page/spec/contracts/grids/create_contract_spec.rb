#-- encoding: UTF-8



require 'spec_helper'
require_relative './shared_examples'

describe Grids::CreateContract do
  include_context 'grid contract'
  include_context 'model contract'

  it_behaves_like 'shared grid contract attributes'

  describe 'user_id' do
    context 'for a Grids::MyPage' do
      let(:grid) { FactoryBot.build_stubbed(:my_page, default_values) }

      it_behaves_like 'is writable' do
        let(:attribute) { :user_id }
        let(:value) { 5 }
      end
    end
  end

  describe 'project_id' do
    context 'for a Grids::MyPage' do
      let(:grid) { FactoryBot.build_stubbed(:my_page, default_values) }

      it_behaves_like 'is not writable' do
        let(:attribute) { :project_id }
        let(:value) { 5 }
      end
    end
  end
end
