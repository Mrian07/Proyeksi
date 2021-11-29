

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VersionSettingsHelper, type: :helper do
  describe '#position_display_options' do
    before(:each) do
      @expected_options = [[I18n.t('version_settings_display_option_none'), 1],
                           [I18n.t('version_settings_display_option_left'), 2],
                           [I18n.t('version_settings_display_option_right'), 3]]
    end

    it { expect(helper.send(:position_display_options)).to eql @expected_options }
  end
end
