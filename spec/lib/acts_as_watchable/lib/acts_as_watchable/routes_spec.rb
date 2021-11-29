

require 'spec_helper'

describe OpenProject::Acts::Watchable::Routes do
  let(:request) do
    Struct.new(:type, :id) do
      def path_parameters
        { object_id: id, object_type: type }
      end
    end.new(type, id)
  end

  describe 'matches?' do
    shared_examples_for 'watched model' do
      describe 'for a valid id string' do
        let(:id) { '1' }

        it 'should be true' do
          expect(OpenProject::Acts::Watchable::Routes.matches?(request)).to be_truthy
        end
      end

      describe 'for an invalid id string' do
        let(:id) { 'schmu' }

        it 'should be false' do
          expect(OpenProject::Acts::Watchable::Routes.matches?(request)).to be_falsey
        end
      end
    end

    ['work_packages', 'news', 'forums', 'messages', 'wikis', 'wiki_pages'].each do |type|
      describe "routing #{type} watches" do
        let(:type) { type }

        it_should_behave_like 'watched model'
      end
    end

    describe 'for a non watched model' do
      let(:type) { 'schmu' }
      let(:id) { '4' }

      it 'should be false' do
        expect(OpenProject::Acts::Watchable::Routes.matches?(request)).to be_falsey
      end
    end
  end
end
