

require 'spec_helper'

describe OpenProject::StaticRouting do
  describe '.recognize_route' do
    subject { described_class.recognize_route path }

    context 'with no relative URL root', with_config: { rails_relative_url_root: nil } do
      let(:path) { '/news/1' }

      it 'detects the route' do
        expect(subject).to be_present
        expect(subject[:controller]).to be_present
      end
    end

    context 'with a relative URL root', with_config: { rails_relative_url_root: '/foobar' } do
      let(:path) { '/foobar/news/1' }

      it 'detects the route' do
        expect(subject).to be_present
        expect(subject[:controller]).to be_present
      end
    end
  end
end
