

require 'spec_helper'

describe PlaceholderUser, type: :model do
  let(:placeholder_user) { FactoryBot.build(:placeholder_user) }

  subject { placeholder_user }

  describe '#name' do
    it 'updates the name' do
      subject.name = "Foo"
      expect(subject.name).to eq("Foo")
    end
    it 'updates the lastname attribute' do
      subject.name = "Foo"
      expect(subject.lastname).to eq("Foo")
    end

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of :name }
  end

  describe "#to_s" do
    it 'returns the lastname' do
      expect(subject.to_s).to eq(subject.lastname)
    end
  end
end
