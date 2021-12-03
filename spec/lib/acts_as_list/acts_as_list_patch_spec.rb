

require 'spec_helper'

describe 'Models acting as list (acts_as_list)' do
  it 'should include the patch' do
    expect(ActiveRecord::Acts::List::InstanceMethods.included_modules).to include(ProyeksiApp::Patches::ActsAsList)
  end

  describe '#move_to=' do
    let(:includer) do
      class ActsAsListPatchIncluder
        include ProyeksiApp::Patches::ActsAsList
      end

      ActsAsListPatchIncluder.new
    end

    it 'should move to top when wanting to move highest' do
      expect(includer).to receive :move_to_top

      includer.move_to = 'highest'
    end

    it 'should move to bottom when wanting to move lowest' do
      expect(includer).to receive :move_to_bottom

      includer.move_to = 'lowest'
    end

    it 'should move higher when wanting to move higher' do
      expect(includer).to receive :move_higher

      includer.move_to = 'higher'
    end

    it 'should move lower when wanting to move lower' do
      expect(includer).to receive :move_lower

      includer.move_to = 'lower'
    end
  end
end
