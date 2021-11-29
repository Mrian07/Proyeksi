#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Projects::Filters::CreatedAtFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :created_at }
    let(:type) { :datetime_past }
    let(:model) { Project }
    let(:attribute) { :created_at }
    let(:values) { ['3'] }
    let(:admin) { FactoryBot.build_stubbed(:admin) }
    let(:user) { FactoryBot.build_stubbed(:user) }

    describe '#available?' do
      context 'for an admin' do
        before do
          login_as admin
        end

        it 'is true' do
          expect(instance)
            .to be_available
        end
      end

      context 'for non admin' do
        before do
          login_as user
        end

        it 'is false' do
          expect(instance)
            .not_to be_available
        end
      end
    end
  end
end
