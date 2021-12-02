

require File.expand_path('../../../spec_helper', __dir__)

describe ProyeksiApp::GithubIntegration::NotificationHandler do
  let(:payload) { {} }

  shared_examples_for 'a notification handler' do
    let(:handler) { instance_double(handler_class) }

    before do
      allow(handler_class).to receive(:new).and_return(handler)
      allow(handler).to receive(:process).and_return(nil)
    end

    it 'forwards the payload to a new handler instance' do
      process
      expect(handler).to have_received(:process).with(payload)
    end

    context 'when the handler throws an error' do
      before do
        allow(handler).to receive(:process).and_raise("oops")
        allow(Rails.logger).to receive(:error)
      end

      it 'logs the error message' do
        expect { process }.to raise_error("oops")
        expect(Rails.logger).to have_received(:error)
      end
    end
  end

  describe '.check_run' do
    subject(:process) { described_class.check_run(payload) }

    let(:handler_class) { described_class::CheckRun }

    it_behaves_like 'a notification handler'
  end

  describe '.issue_comment' do
    subject(:process) { described_class.issue_comment(payload) }

    let(:handler_class) { described_class::IssueComment }

    it_behaves_like 'a notification handler'
  end

  describe '.pull_request' do
    subject(:process) { described_class.pull_request(payload) }

    let(:handler_class) { described_class::PullRequest }

    it_behaves_like 'a notification handler'
  end
end
