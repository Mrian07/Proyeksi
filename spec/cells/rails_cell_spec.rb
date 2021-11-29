#-- encoding: UTF-8


require 'spec_helper'

describe ::RailsCell do
  let(:controller) { double(ApplicationController) }
  let(:action_view) { ActionView::Base.new(ActionView::LookupContext.new(''), {}, controller) }
  let(:model) { double('model', foo: '<strong>Some HTML here!</strong>') }
  let(:context) do
    { controller: controller }
  end
  let(:options) do
    { context: context }
  end

  let(:test_cell) do
    Class.new(described_class) do
      property :foo

      def link
        link_to "<strong>HTML</strong>", '/foo/bar'
      end

      def content
        content_tag(:div) do
          content_tag(:span) do
            "<script>foo</script>"
          end
        end
      end
    end
  end

  let(:instance) { test_cell.new model, options }

  before do
    allow(controller).to receive(:view_context).and_return(action_view)
  end

  shared_examples 'uses action_view helpers' do
    describe '#link' do
      subject { instance.link }

      it 'uses link_to from rails with escaping' do
        expect(subject.to_s).to eq %(<a href="/foo/bar">&lt;strong&gt;HTML&lt;/strong&gt;</a>)
      end
    end

    describe '#foo' do
      subject { instance.foo }

      it 'escapes the property' do
        expect(subject.to_s).to eq "&lt;strong&gt;Some HTML here!&lt;/strong&gt;"
      end
    end

    describe '#content' do
      subject { instance.content }

      it 'uses content_tag from rails with escaping', :aggregate_failures do
        expect(action_view).to receive(:content_tag).twice.and_call_original
        expect(subject.to_s).to eq "<div><span>&lt;script&gt;foo&lt;/script&gt;</span></div>"
      end
    end
  end

  describe 'delegate to action_view' do
    context 'when action_view set' do
      let(:context) do
        { controller: controller, action_view: action_view }
      end

      it_behaves_like 'uses action_view helpers'
    end

    context 'when not set' do
      it_behaves_like 'uses action_view helpers'
    end
  end
end
