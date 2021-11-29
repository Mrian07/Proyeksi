#-- encoding: UTF-8


require 'spec_helper'

describe HookHelper do
  describe '#call_hook' do
    context 'when called within a controller' do
      let(:test_hook_controller_class) do
        # Also tests that the application controller has the model included
        Class.new(ApplicationController)
      end
      let(:instance) do
        test_hook_controller_class.new.tap do |inst|
          inst.instance_variable_set(:@project, project)
          allow(inst)
            .to receive(:request)
                  .and_return(request)
        end
      end
      let(:project) do
        instance_double('Project')
      end
      let(:request) do
        instance_double('ActiveSupport::Request')
      end

      it 'adds to the context' do
        allow(OpenProject::Hook)
          .to receive(:call_hook)

        instance.call_hook(:some_hook_identifier, {})

        expect(OpenProject::Hook)
          .to have_received(:call_hook)
                .with(:some_hook_identifier, { project: project,
                                               controller: instance,
                                               request: request,
                                               hook_caller: instance })
      end
    end

    context 'when called within a view' do
      let(:test_hook_view_class) do
        # Also tests that the application controller has the model included
        Class.new(ActionView::Base) do
          include HookHelper
        end
      end
      let(:instance) do
        test_hook_view_class
          .new(ActionView::LookupContext.new(Rails.root.join('app/views')), {}, nil)
          .tap do |inst|
          inst.instance_variable_set(:@project, project)
          allow(inst)
            .to receive(:request)
            .and_return(request)
          allow(inst)
            .to receive(:controller)
            .and_return(controller_instance)
        end
      end
      let(:project) do
        instance_double('Project')
      end
      let(:request) do
        instance_double('ActiveSupport::Request')
      end
      let(:controller_instance) do
        instance_double('ApplicationController')
      end

      it 'adds to the context' do
        # mimicks having two different classes registered for the hook
        allow(OpenProject::Hook)
          .to receive(:call_hook)
          .and_return(%w[response1 response2])

        expect(instance.call_hook(:some_hook_identifier, {}))
          .to eql "response1 response2"

        expect(OpenProject::Hook)
          .to have_received(:call_hook)
                .with(:some_hook_identifier, { project: project,
                                               controller: controller_instance,
                                               request: request,
                                               hook_caller: instance })
      end
    end
  end
end
