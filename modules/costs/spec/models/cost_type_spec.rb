

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe CostType, type: :model do
  let(:klass) { CostType }
  let(:cost_type) do
    klass.new name: 'ct1',
              unit: 'singular',
              unit_plural: 'plural'
  end
  before do
    # as the spec_helper loads fixtures and they are probably needed by other tests
    # we delete them here so they do not interfere.
    # on the long run, fixtures should be removed

    CostType.destroy_all
  end

  describe 'class' do
    describe 'active' do
      describe 'WHEN a CostType instance is deleted' do
        before do
          cost_type.deleted_at = Time.now
          cost_type.save!
        end

        it { expect(klass.active.size).to eq(0) }
      end

      describe 'WHEN a CostType instance is not deleted' do
        before do
          cost_type.save!
        end

        it { expect(klass.active.size).to eq(1) }
        it { expect(klass.active[0]).to eq(cost_type) }
      end
    end
  end
end
