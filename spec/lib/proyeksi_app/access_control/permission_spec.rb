

require 'spec_helper'

describe ProyeksiApp::AccessControl::Permission do
  describe '#dependencies' do
    context 'for a permission with a dependency' do
      subject { ProyeksiApp::AccessControl.permission(:edit_work_packages) }

      it 'denotes the prerequiresites' do
        expect(subject.dependencies)
          .to match_array([:view_work_packages])
      end
    end

    context 'for a permission without a dependency' do
      subject { ProyeksiApp::AccessControl.permission(:view_work_packages) }

      it 'is empty' do
        expect(subject.dependencies)
          .to be_empty
      end
    end
  end

  describe '#global?' do
    describe 'setting global permission' do
      before { @permission = ProyeksiApp::AccessControl::Permission.new(:perm, { cont: [:action] }, { global: true }) }

      it { expect(@permission.global?).to be_truthy }
    end

    describe 'setting non global permission' do
      before { @permission = ProyeksiApp::AccessControl::Permission.new :perm, { cont: [:action] }, { global: false } }

      it 'is false' do
        expect(@permission.global?).to be_falsey
      end
    end

    describe 'not specifying -> default' do
      before { @permission = ProyeksiApp::AccessControl::Permission.new :perm, { cont: [:action] }, {} }

      it 'is false' do
        expect(@permission.global?).to be_falsey
      end
    end
  end
end
