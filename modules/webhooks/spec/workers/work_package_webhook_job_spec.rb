#-- encoding: UTF-8



require 'spec_helper'

describe WorkPackageWebhookJob, type: :model, webmock: true do
  shared_let(:user) { FactoryBot.create :admin }
  shared_let(:title) { "Some workpackage subject" }
  shared_let(:request_url) { "http://example.net/test/42" }
  shared_let(:work_package) { FactoryBot.create :work_package, subject: title }
  shared_let(:webhook) { FactoryBot.create :webhook, all_projects: true, url: request_url, secret: nil }

  shared_examples "a work package webhook call" do
    let(:event) { "work_package:created" }
    let(:job) { described_class.perform_now webhook.id, work_package, event }

    let(:stubbed_url) { request_url }

    let(:request_headers) do
      { content_type: "application/json", accept: "application/json" }
    end

    let(:response_code) { 200 }
    let(:response_body) { "hook called" }
    let(:response_headers) do
      { content_type: "text/plain", x_spec: "foobar" }
    end

    let(:stub) do
      stub_request(:post, stubbed_url.sub("http://", ""))
        .with(
          body: hash_including(
            "action" => event,
            "work_package" => hash_including(
              "_type" => "WorkPackage",
              "subject" => title
            )
          ),
          headers: request_headers
        )
        .to_return(
          status: response_code,
          body: response_body,
          headers: response_headers
        )
    end

    subject { job }

    before do
      allow(::Webhooks::Webhook).to receive(:find).with(webhook.id).and_return(webhook)
      login_as user
      stub
    end

    it 'requests with all projects' do
      expect(webhook)
        .to receive(:enabled_for_project?).with(work_package.project_id)
        .and_call_original

      subject
      expect(stub).to have_been_requested
    end

    it 'does not request when project does not match' do
      expect(webhook)
        .to receive(:enabled_for_project?).with(work_package.project_id)
        .and_return(false)

      subject
      expect(stub).not_to have_been_requested
    end

    describe 'successful flow' do
      before do
        subject
      end

      it "calls the webhook url" do
        expect(stub).to have_been_requested
      end

      it "creates a log for the call" do
        log = Webhooks::Log.last

        expect(log.webhook).to eq webhook
        expect(log.url).to eq webhook.url
        expect(log.event_name).to eq event
        expect(log.request_headers).to eq request_headers
        expect(log.response_code).to eq response_code
        expect(log.response_body).to eq response_body
        expect(log.response_headers).to eq response_headers
      end
    end
  end

  describe "triggering a work package update" do
    it_behaves_like "a work package webhook call" do
      let(:event) { "work_package:updated" }
    end
  end

  describe "triggering a work package creation" do
    it_behaves_like "a work package webhook call" do
      let(:event) { "work_package:created" }
    end
  end

  describe "triggering a work package update with an invalid url" do
    it_behaves_like "a work package webhook call" do
      let(:event) { "work_package:updated" }
      let(:response_code) { 404 }
      let(:response_body) { "not found" }
    end
  end
end
