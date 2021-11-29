

require 'spec_helper'
require 'open_project/configuration/helpers'

describe OpenProject::Configuration::Helpers do
  let(:config) do
    {}.tap do |config|
      config.extend OpenProject::Configuration::Helpers
    end
  end

  describe '#array' do
    def array(value)
      config.send :array, value
    end

    context 'with single string value' do
      it 'returns an array containing the value' do
        arr = array 'test'

        expect(arr).to eq ['test']
      end
    end

    context 'with an array' do
      it 'returns the array' do
        arr = ['arrgh']

        expect(array(arr)).to eq arr
      end
    end

    context 'with a space separated string' do
      it 'returns an array of the values' do
        value = 'one two three'

        expect(array(value)).to eq ['one', 'two', 'three']
      end
    end
  end

  describe '#hidden_menu_items' do
    before do
      items = config['hidden_menu_items'] = {}
      items['admin_menu'] = 'users colors'
      items['project_menu'] = 'info'
      items['top_menu'] = []
    end

    it 'works with arrays' do
      expect(config.hidden_menu_items['top_menu']).to eq []
    end

    it 'works with single string values' do
      expect(config.hidden_menu_items['project_menu']).to eq ['info']
    end

    it 'work with space separated string values' do
      expect(config.hidden_menu_items['admin_menu']).to eq ['users', 'colors']
    end
  end
end
