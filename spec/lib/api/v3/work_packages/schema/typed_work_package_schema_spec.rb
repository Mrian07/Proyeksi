

require 'spec_helper'

describe ::API::V3::WorkPackages::Schema::TypedWorkPackageSchema do
  let(:project) { FactoryBot.build(:project) }
  let(:type) { FactoryBot.build(:type) }

  let(:current_user) do
    double('user').tap do |u|
      allow(u)
        .to receive(:allowed_to?)
        .and_return(true)
    end
  end
  subject { described_class.new(project: project, type: type) }

  before do
    login_as(current_user)
  end

  it 'has the project set' do
    expect(subject.project).to eql(project)
  end

  it 'has the type set' do
    expect(subject.type).to eql(type)
  end

  it 'does not know assignable statuses' do
    expect(subject.assignable_values(:status, current_user)).to eql(nil)
  end

  it 'does not know assignable versions' do
    expect(subject.assignable_values(:version, current_user)).to eql(nil)
  end

  describe '#writable?' do
    it 'percentage done is writable' do
      expect(subject.writable?(:percentage_done)).to be true
    end

    it 'estimated time is writable' do
      expect(subject.writable?(:estimated_time)).to be true
    end

    it 'start date is writable' do
      expect(subject.writable?(:start_date)).to be true
    end

    it 'finish date is writable' do
      expect(subject.writable?(:due_date)).to be true
    end
  end

  describe '#milestone?' do
    before do
      allow(type)
        .to receive(:is_milestone?)
              .and_return(true)
    end

    it 'is the value the type has' do
      is_expected.to be_milestone

      allow(type)
        .to receive(:is_milestone?)
        .and_return(false)

      is_expected.not_to be_milestone
    end

    it 'has a writable date' do
      expect(subject.writable?(:date)).to be true
    end
  end

  describe '#assignable_custom_field_values' do
    let(:list_cf) { FactoryBot.build_stubbed(:list_wp_custom_field) }
    let(:version_cf) { FactoryBot.build_stubbed(:version_wp_custom_field) }

    it 'is nil for a list cf' do
      expect(subject.assignable_custom_field_values(list_cf)).to be_nil
    end

    it 'is nil for a version cf' do
      expect(subject.assignable_custom_field_values(version_cf)).to be_nil
    end
  end
end
