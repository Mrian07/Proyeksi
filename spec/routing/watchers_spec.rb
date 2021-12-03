

require 'spec_helper'

describe WatchersController, type: :routing do
  shared_examples_for 'watched model routes' do
    before do
      expect(ProyeksiApp::Acts::Watchable::Routes).to receive(:matches?).and_return(true)
    end

    it 'should connect POST /:object_type/:object_id/watch to watchers#watch' do
      expect(post("/#{type}/1/watch")).to route_to(controller: 'watchers',
                                                   action: 'watch',
                                                   object_type: type,
                                                   object_id: '1')
    end

    it 'should connect DELETE /:object_type/:id/unwatch to watchers#unwatch' do
      expect(delete("/#{type}/1/unwatch")).to route_to(controller: 'watchers',
                                                       action: 'unwatch',
                                                       object_type: type,
                                                       object_id: '1')
    end
  end

  ['issues', 'news', 'boards', 'messages', 'wikis', 'wiki_pages'].each do |type|
    describe "routing #{type} watches" do
      let(:type) { type }

      it_should_behave_like 'watched model routes'
    end
  end
end
