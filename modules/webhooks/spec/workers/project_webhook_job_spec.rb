#-- encoding: UTF-8



require 'spec_helper'

describe ProjectWebhookJob, type: :job, webmock: true do
  shared_let(:user) { FactoryBot.create :admin }
  shared_let(:request_url) { "http://example.net/test/42" }
  shared_let(:project) { FactoryBot.create :project, name: 'Foo Bar' }
  shared_let(:webhook) { FactoryBot.create :webhook, all_projects: true, url: request_url, secret: nil }

  shared_examples "a project webhook call" do
    let(:event) { "project:created" }
    let(:job) { ProjectWebhookJob.perform_now(webhook.id, project, event) }

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
            "project" => hash_including(
              "_type" => "Project",
              "name" => 'Foo Bar'
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

    subject do
      job
    rescue StandardError
      # ignoring it as it's expected to throw exceptions in certain scenarios
      nil
    end

    before do
      allow(::Webhooks::Webhook).to receive(:find).with(webhook.id).and_return(webhook)
      login_as user
      stub
    end

    it 'requests with all projects' do
      allow(webhook)
        .to receive(:enabled_for_project?).with(project.id)
        .and_call_original

      subject
      expect(stub).to have_been_requested
    end

    it 'does not request when project does not match unless create case' do
      allow(webhook)
        .to receive(:enabled_for_project?).with(project.id)
        .and_return(false)

      subject
      if event == 'project:created'
        expect(stub).to have_been_requested
      else
        expect(stub).not_to have_been_requested
      end
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

  describe "triggering a project update" do
    it_behaves_like "a project webhook call" do
      let(:event) { "project:updated" }
    end
  end

  describe "triggering a projec creation" do
    it_behaves_like "a project webhook call" do
      let(:event) { "project:created" }
    end
  end

  describe "triggering a work package create with an invalid url" do
    it_behaves_like "a project webhook call" do
      let(:event) { "project:update" }
      let(:response_code) { 404 }
      let(:response_body) { "not found" }
    end
  end
end
