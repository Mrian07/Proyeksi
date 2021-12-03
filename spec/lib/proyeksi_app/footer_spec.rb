

require 'spec_helper'
require 'proyeksi_app/footer'

describe ProyeksiApp::Footer do
  describe '.add_content' do
    context 'empty content' do
      before do
        ProyeksiApp::Footer.content = nil
        ProyeksiApp::Footer.add_content('ProyeksiApp', 'footer')
      end
      it { expect(ProyeksiApp::Footer.content.class).to eq(Hash) }
      it { expect(ProyeksiApp::Footer.content['ProyeksiApp']).to eq('footer') }
    end

    context 'existing content' do
      before do
        ProyeksiApp::Footer.content = nil
        ProyeksiApp::Footer.add_content('ProyeksiApp', 'footer')
        ProyeksiApp::Footer.add_content('footer_2', 'footer 2')
      end

      it { expect(ProyeksiApp::Footer.content.count).to eq(2) }
      it { expect(ProyeksiApp::Footer.content).to eq('ProyeksiApp' => 'footer', 'footer_2' => 'footer 2') }
    end
  end
end
