#-- encoding: UTF-8


require 'spec_helper'

describe OpenProject::Hook do
  let(:test_hook_class) do
    Class.new(OpenProject::Hook::ViewListener)
  end
  let(:test_hook1_class) do
    Class.new(test_hook_class) do
      def view_layouts_base_html_head(_context)
        'Test hook 1 listener.'
      end
    end
  end
  let(:test_hook2_class) do
    Class.new(test_hook_class) do
      def view_layouts_base_html_head(_context)
        'Test hook 2 listener.'
      end
    end
  end
  let(:test_hook3_class) do
    Class.new(test_hook_class) do
      def view_layouts_base_html_head(context)
        "Context keys: #{context.keys.map(&:to_s).sort.join(', ')}."
      end
    end
  end
  let!(:previous_listener_classes) { described_class.listener_classes.dup }

  before do
    described_class.clear_listeners
  end

  after do
    described_class.clear_listeners
    described_class.instance_variable_set(:@listener_classes, previous_listener_classes)
  end

  describe '#add_listeners' do
    context 'when inheriting from the class' do
      it 'is automatically added' do
        expect(described_class.hook_listeners(:view_layouts_base_html_head))
          .to be_empty

        test_hook1_class

        expect(described_class.hook_listeners(:view_layouts_base_html_head))
          .to match_array([test_hook1_class])
      end
    end

    context 'when explicitly adding' do
      let(:test_class) do
        Class.new do
          include Singleton

          def view_layouts_base_html_head(_context)
            'Test hook listener.'
          end
        end
      end

      it 'adds listeners' do
        described_class.add_listener(test_class)
        expect(described_class.hook_listeners(:view_layouts_base_html_head))
          .to match_array([test_class])
      end
    end

    context 'when not having the Singleton module included' do
      let(:test_class) do
        Class.new do
          def view_layouts_base_html_head(_context)
            'Test hook listener.'
          end
        end
      end

      it 'adds listeners' do
        expect { described_class.add_listener(test_class) }
          .to raise_error ArgumentError
      end
    end
  end

  describe '#clear_listeners' do
    before do
      # implicitly adding by class creation
      test_hook1_class
    end

    it 'clears the registered listeners' do
      described_class.clear_listeners
      expect(described_class.hook_listeners(:view_layouts_base_html_head))
        .to be_empty
    end
  end

  describe '#call_hook' do
    context 'with a class registered for the hook' do
      before do
        # implicitly adding by class creation
        test_hook1_class
      end

      it 'calls the registered method' do
        expect(described_class.call_hook(:view_layouts_base_html_head))
          .to match_array test_hook1_class.instance.view_layouts_base_html_head(nil)
      end
    end

    context 'without a class registered for the hook' do
      it 'calls the registered method' do
        expect(described_class.call_hook(:view_layouts_base_html_head))
          .to be_empty
      end
    end

    context 'with multiple listeners' do
      before do
        # implicitly adding by class creation
        test_hook1_class
        test_hook2_class
      end

      it 'calls all registered methods' do
        expect(described_class.call_hook(:view_layouts_base_html_head))
          .to match_array [test_hook1_class.instance.view_layouts_base_html_head(nil),
                           test_hook2_class.instance.view_layouts_base_html_head(nil)]
      end
    end

    context 'with a context' do
      let!(:test_hook_context_class) do
        # implicitly adding by class creation
        Class.new(test_hook_class) do
          def view_layouts_base_html_head(context)
            context
          end
        end
      end

      let(:context) { { foo: 1, bar: 'a'} }

      it 'passes the context through' do
        expect(described_class.call_hook(:view_layouts_base_html_head, **context))
          .to match_array [context]
      end
    end

    context 'with a link rendered in the hooked to method' do
      let!(:test_hook_link_class) do
        # implicitly adding by class creation
        Class.new(test_hook_class) do
          def view_layouts_base_html_head(_context)
            link_to('Work packages', controller: '/work_packages')
          end
        end
      end

      it 'renders the link' do
        expect(described_class.call_hook(:view_layouts_base_html_head))
          .to match_array ['<a href="/work_packages">Work packages</a>']
      end
    end

    context 'when called within a controller' do
      let(:test_hook_controller_class) do
        # Also tests that the application controller has the model included
        Class.new(ApplicationController)
      end
      let!(:test_hook_context_class) do
        # implicitly adding by class creation
        Class.new(test_hook_class) do
          def view_layouts_base_html_head(context)
            context
          end
        end
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
        expect(instance.call_hook(:view_layouts_base_html_head, {}))
          .to match_array [{ project: project, controller: instance, request: request, hook_caller: instance }]
      end
    end
  end

  context 'called within email rendering' do
    let!(:test_hook_link_class) do
      # implicitly adding by class creation
      Class.new(test_hook_class) do
        def view_layouts_base_html_head(_context)
          link_to('Work packages', controller: '/work_packages')
        end
      end
    end
    let(:test_hook_controller_class) do
      # Also tests that the application controller has the model included
      Class.new(ApplicationController)
    end

    let(:user) { FactoryBot.build_stubbed(:user) }
    let(:author) { FactoryBot.build_stubbed(:user) }
    let(:work_package) do
      FactoryBot.build_stubbed(:work_package,
                               type: FactoryBot.build_stubbed(:type),
                               status: FactoryBot.build_stubbed(:status)).tap do |wp|

        allow(wp)
          .to receive(:reload)
                .and_return(wp)
      end
    end
    let!(:comparison_mail) do
      WorkPackageMailer.watcher_changed(work_package, user, author, :added).deliver_now
      ActionMailer::Base.deliveries.last
    end

    it 'does not_change_the_default_url_for_email_notifications' do
      test_hook_controller_class.new.call_hook(:view_layouts_base_html_head)

      ActionMailer::Base.deliveries.clear
      WorkPackageMailer.watcher_changed(work_package, user, author, :added).deliver_now
      mail2 = ActionMailer::Base.deliveries.last

      assert_equal comparison_mail.text_part.body.encoded, mail2.text_part.body.encoded
    end
  end
end
