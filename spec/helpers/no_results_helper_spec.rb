

require 'spec_helper'

describe NoResultsHelper do
  before do
    allow(helper).to receive(:t).with('.no_results_title_text', cascade: true) { "Nothing here!" }
    allow(helper).to receive(:t).with('.no_results_content_text') { "Add some foo" }
  end

  describe '#no_results_box' do
    it "contains the just the title" do
      expect(helper.no_results_box).to have_content 'Nothing here!'
      expect(helper.no_results_box).to_not have_link 'Add some foo'
    end

    it "contains the title and content link" do
      no_results_box = helper.no_results_box(action_url: root_path,
                                             display_action: true)

      expect(no_results_box).to have_content 'Nothing here!'
      expect(no_results_box).to have_link 'Add some foo', href: '/'
    end

    it 'contains title and content_link with custom text' do
      no_results_box = helper.no_results_box(action_url: root_path,
                                             display_action: true,
                                             custom_title: 'This is a different title about foo',
                                             custom_action_text: 'Link to nowhere')

      expect(no_results_box).to have_content 'This is a different title about foo'
      expect(no_results_box).to have_link 'Link to nowhere', href: '/'
    end
  end
end
