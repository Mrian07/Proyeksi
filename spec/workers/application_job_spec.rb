

require 'spec_helper'

describe ApplicationJob do
  class JobMock < ApplicationJob
    def initialize(callback)
      @callback = callback
    end

    def perform
      @callback.call
    end
  end

  describe 'resets request store' do
    it 'resets request store on each perform' do
      job = JobMock.new(-> do
        expect(RequestStore[:test_value]).to be_nil
        RequestStore[:test_value] = 42
      end)

      RequestStore[:test_value] = 'my value'
      expect { job.perform_now }.not_to change { RequestStore[:test_value] }

      RequestStore[:test_value] = 'my value2'
      expect { job.perform_now }.not_to change { RequestStore[:test_value] }

      expect(RequestStore[:test_value]).to eq 'my value2'
    end
  end

  describe 'email configuration' do
    let(:ports) { [] }

    before do
      # pick a random job to test if the settings are updated
      allow_any_instance_of(Principals::DeleteJob).to receive(:perform) do
        ports << ActionMailer::Base.smtp_settings[:port]
      end
    end

    it "is reloaded for each job" do
      # the email delivery method has to be smtp for the settings to be reloaded
      Setting.email_delivery_method = :smtp

      Principals::DeleteJob.perform_now nil

      expect(ports).not_to be_empty
      expect(ports.last).not_to be 42

      # We have to change the time here for Setting.settings_updated_at to actually be different from before
      # since this is of course all running within the same second.
      Timecop.travel(1.second.from_now) do
        # While we're in the worker here, this simulates another process changing the setting.
        Setting.create!(name: "smtp_port", value: 42)

        Principals::DeleteJob.perform_now nil

        expect(ports.last).to eq 42
      end
    end
  end
end
