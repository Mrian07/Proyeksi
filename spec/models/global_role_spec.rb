

require 'spec_helper'

describe GlobalRole, type: :model do
  before { GlobalRole.create name: 'globalrole', permissions: ['permissions'] }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to validate_length_of(:name).is_at_most(30) }

  describe 'attributes' do
    before { @role = GlobalRole.new }

    subject { @role }

    it { is_expected.to respond_to :name }
    it { is_expected.to respond_to :permissions }
    it { is_expected.to respond_to :position }
  end

  describe 'instance methods' do
    before do
      @role = GlobalRole.new
    end

    describe 'WITH no attributes set' do
      before do
        @role = GlobalRole.new
      end

      describe '#permissions' do
        subject { @role.permissions }

        it { is_expected.to be_an_instance_of(Array) }
        it 'has no items' do
          expect(subject.size).to eq(0)
        end
      end

      describe '#has_permission?' do
        it { expect(@role.has_permission?(:perm)).to be_falsey }
      end

      describe '#allowed_to?' do
        describe 'WITH requested permission' do
          it { expect(@role.allowed_to?(:perm1)).to be_falsey }
        end
      end
    end

    describe 'WITH set permissions' do
      before { @role = GlobalRole.new permissions: %i[perm1 perm2 perm3] }

      describe '#has_permission?' do
        it { expect(@role.has_permission?(:perm1)).to be_truthy }
        it { expect(@role.has_permission?('perm1')).to be_truthy }
        it { expect(@role.has_permission?(:perm5)).to be_falsey }
      end

      describe '#allowed_to?' do
        describe 'WITH requested permission' do
          it { expect(@role.allowed_to?(:perm1)).to be_truthy }
          it { expect(@role.allowed_to?(:perm5)).to be_falsey }
        end
      end
    end

    describe 'WITH set name' do
      before { @role = GlobalRole.new name: 'name' }

      describe '#to_s' do
        it { expect(@role.to_s).to eql('name') }
      end
    end
  end
end
