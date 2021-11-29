

require 'spec_helper'
require 'open_project/footer'

describe OpenProject::Footer do
  describe '.add_content' do
    context 'empty content' do
      before do
        OpenProject::Footer.content = nil
        OpenProject::Footer.add_content('OpenProject', 'footer')
      end
      it { expect(OpenProject::Footer.content.class).to eq(Hash) }
      it { expect(OpenProject::Footer.content['OpenProject']).to eq('footer') }
    end

    context 'existing content' do
      before do
        OpenProject::Footer.content = nil
        OpenProject::Footer.add_content('OpenProject', 'footer')
        OpenProject::Footer.add_content('footer_2', 'footer 2')
      end

      it { expect(OpenProject::Footer.content.count).to eq(2) }
      it { expect(OpenProject::Footer.content).to eq('OpenProject' => 'footer', 'footer_2' => 'footer 2') }
    end
  end
end
