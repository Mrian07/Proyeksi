

require 'spec_helper'

describe ProyeksiApp::AccessControl do
  before do
    ProyeksiApp::AccessControl.instance_variable_set(:'@disabled_project_modules', nil)
  end

  after do
    ProyeksiApp::AccessControl.instance_variable_set(:'@disabled_project_modules', nil)
  end

  describe '.sorted_module_names' do
    context 'with bim disabled' do
      before do
        allow(ProyeksiApp::Configuration)
          .to receive(:bim?)
          .and_return false
      end

      context 'if including disabled modules' do
        it 'includes the bim module' do
          expect(subject.sorted_module_names)
            .to include('bim')
        end
      end

      context 'if excluding disabled modules' do
        it 'does not include the bim module' do
          expect(subject.sorted_module_names(false))
            .not_to include('bim')
        end
      end
    end

    context 'with bim enabled' do
      before do
        allow(ProyeksiApp::Configuration)
          .to receive(:bim?)
          .and_return true
      end

      context 'if including disabled modules' do
        it 'includes the bim module' do
          expect(subject.sorted_module_names)
            .to include('bim')
        end
      end

      context 'if excluding disabled modules' do
        it 'includes the bim module' do
          expect(subject.sorted_module_names(false))
            .to include('bim')
        end
      end
    end
  end
end
