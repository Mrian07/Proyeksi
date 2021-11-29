

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VersionSetting, type: :model do
  let(:version_setting) { FactoryBot.build(:version_setting) }

  it { is_expected.to belong_to(:project) }
  it { is_expected.to belong_to(:version) }
  it { expect(VersionSetting.column_names).to include('display') }

  describe 'Instance Methods' do
    describe 'WITH display set to left' do
      before(:each) do
        version_setting.display_left!
      end

      it { expect(version_setting.display_left?).to be_truthy }
    end

    describe 'WITH display set to right' do
      before(:each) do
        version_setting.display_right!
      end

      it { expect(version_setting.display_right?).to be_truthy }
    end

    describe 'WITH display set to none' do
      before(:each) do
        version_setting.display_none!
      end

      it { expect(version_setting.display_none?).to be_truthy }
    end
  end
end
