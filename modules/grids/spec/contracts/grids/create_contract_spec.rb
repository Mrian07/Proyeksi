#-- encoding: UTF-8



require 'spec_helper'
require_relative './shared_examples'

describe Grids::CreateContract do
  include_context 'grid contract'
  include_context 'model contract'

  it_behaves_like 'shared grid contract attributes'

  describe 'type' do
    let(:grid) { FactoryBot.build_stubbed(:grid, default_values) }

    it_behaves_like 'is writable' do
      let(:attribute) { :type }
      let(:value) { 'Grids::Grid' }
    end
  end

  describe 'user_id' do
    let(:grid) { FactoryBot.build_stubbed(:grid, default_values) }

    it_behaves_like 'is not writable' do
      let(:attribute) { :user_id }
      let(:value) { 5 }
    end
  end

  describe 'project_id' do
    let(:grid) { FactoryBot.build_stubbed(:grid, default_values) }

    it_behaves_like 'is not writable' do
      let(:attribute) { :project_id }
      let(:value) { 5 }
    end
  end

  describe '#assignable_values' do
    context 'for scope' do
      it 'calls the grid configuration for the available values' do
        scopes = double('scopes')

        allow(Grids::Configuration)
          .to receive(:all_scopes)
          .and_return(scopes)

        expect(instance.assignable_values(:scope, user))
          .to eql scopes
      end
    end

    context 'for widgets' do
      it 'calls the grid configuration for the available values but allows only those eligible' do
        widgets = %i[widget1 widget2]

        allow(Grids::Configuration)
          .to receive(:all_widget_identifiers)
          .and_return(widgets)

        allow(Grids::Configuration)
          .to receive(:allowed_widget?)
          .with(Grids::Grid, :widget1, user, nil)
          .and_return(true)

        allow(Grids::Configuration)
          .to receive(:allowed_widget?)
          .with(Grids::Grid, :widget2, user, nil)
          .and_return(false)

        expect(instance.assignable_values(:widgets, user))
          .to match_array [:widget1]
      end
    end

    context 'for something else' do
      it 'returns nil' do
        expect(instance.assignable_values(:something, user))
          .to be_nil
      end
    end
  end
end
