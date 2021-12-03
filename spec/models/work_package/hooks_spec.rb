

require 'spec_helper'

describe WorkPackage, type: :model do
  describe "#create" do
    it "calls the create hook" do
      subject = "A new work package"

      expect(ProyeksiApp::Hook).to receive(:call_hook) do |hook, context|
        expect(hook).to eq :work_package_after_create
        expect(context[:work_package].subject).to eq subject
      end

      FactoryBot.create :work_package, subject: subject
    end
  end

  describe "#update" do
    let!(:work_package) { FactoryBot.create :work_package }

    it "calls the update hook" do
      expect(ProyeksiApp::Hook).to receive(:call_hook) do |hook, context|
        expect(hook).to eq :work_package_after_update
        expect(context[:work_package]).to eq work_package
        expect(context[:work_package].journals.last.details[:description].last).to eq "changed description"
      end

      work_package.description = "changed description"
      work_package.save!
    end
  end
end
