

require 'spec_helper'
require File.join(File.dirname(__FILE__), '..', '..', 'support', 'configuration_helper')

describe CostQuery::Cache do
  include ProyeksiApp::Reporting::SpecHelper::ConfigurationHelper

  def all_caches
    [CostQuery::GroupBy::CustomFieldEntries,
     CostQuery::GroupBy,
     CostQuery::Filter::CustomFieldEntries,
     CostQuery::Filter]
  end

  def expect_reset_on_caches
    all_caches.each do |klass|
      expect(klass).to receive(:reset!)
    end
  end

  def expect_no_reset_on_caches
    all_caches.each do |klass|
      expect(klass).to_not receive(:reset!)
    end
  end

  def reset_cache_keys
    # resetting internal caching keys to avoid dependencies with other specs
    described_class.send(:latest_custom_field_change=, nil)
    described_class.send(:custom_field_count=, 0)
  end

  def custom_fields_exist
    allow(WorkPackageCustomField).to receive(:maximum).and_return(Time.now)
    allow(WorkPackageCustomField).to receive(:count).and_return(23)
  end

  def no_custom_fields_exist
    allow(WorkPackageCustomField).to receive(:maximum).and_return(nil)
    allow(WorkPackageCustomField).to receive(:count).and_return(0)
  end

  before do
    reset_cache_keys
  end

  after do
    reset_cache_keys
  end

  describe '.check' do
    context 'with cache_classes configuration enabled' do
      before do
        mock_cache_classes_setting_with(true)
      end

      it 'resets the caches on filters and group by' do
        custom_fields_exist
        expect_reset_on_caches

        described_class.check
      end

      it 'stores when the last update was made and does not reset again if nothing changed' do
        custom_fields_exist
        expect_reset_on_caches

        described_class.check

        expect_no_reset_on_caches

        described_class.check
      end

      it 'does reset the cache if last CustomField is removed' do
        custom_fields_exist
        expect_reset_on_caches

        described_class.check

        no_custom_fields_exist
        expect_reset_on_caches

        described_class.check
      end
    end

    context 'with_cache_classes configuration disabled' do
      before do
        mock_cache_classes_setting_with(false)
      end

      it 'resets the cache again even if nothing changed' do
        custom_fields_exist
        expect_reset_on_caches

        described_class.check

        expect_reset_on_caches

        described_class.check
      end
    end
  end
end
