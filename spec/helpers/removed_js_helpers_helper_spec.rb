

require 'spec_helper'

describe RemovedJsHelpersHelper, type: :helper do
  include RemovedJsHelpersHelper

  describe 'link_to_function' do
    it 'returns a valid link' do
      allow(SecureRandom).to receive(:uuid).and_return 'uuid'
      expect(self).to receive(:content_for).with(:additional_js_dom_ready)
      expect(link_to_function('blubs', nil))
        .to be_html_eql %{
          <a id="link-to-function-uuid" href="">blubs</a>
        }
    end

    it 'adds the provided method to the onclick handler' do
      expect(self).to receive(:content_for).with(:additional_js_dom_ready)
      expect(link_to_function('blubs', 'doTheMagic(now)', id: :foo))
        .to be_html_eql %{
          <a id="foo" href="">blubs</a>
        }
    end
  end
end
