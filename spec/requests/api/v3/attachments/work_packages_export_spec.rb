

require 'spec_helper'
require_relative './attachment_resource_shared_examples'

describe "WorkPackages::Export attachments" do
  it_behaves_like "an APIv3 attachment resource", include_by_container = false do
    let(:attachment_type) { :export }

    let(:create_permission) { :export_work_packages }
    let(:read_permission) { :export_work_packages }
    let(:update_permission) { :export_work_packages }

    let(:export) { FactoryBot.create(:work_packages_export) }

    let(:missing_permissions_user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    let(:other_user_attachment) { FactoryBot.create(:attachment, container: export, author: other_user) }

    describe '#get' do
      subject(:response) { last_response }
      let(:get_path) { api_v3_paths.attachment attachment.id }

      before do
        get get_path
      end

      context 'for a user different from the author' do
        let(:attachment) { other_user_attachment }

        it 'responds with 404' do
          expect(subject.status).to eq(404)
        end
      end
    end

    describe '#delete' do
      let(:path) { api_v3_paths.attachment attachment.id }

      before do
        delete path
      end

      context 'for a user different from the author' do
        let(:attachment) { other_user_attachment }

        subject(:response) { last_response }

        it "responds with 404" do
          expect(subject.status).to eq 404
        end

        it 'does not delete the attachment' do
          expect(Attachment.exists?(attachment.id)).to be_truthy
        end
      end
    end

    describe '#content' do
      let(:path) { api_v3_paths.attachment_content attachment.id }

      before do
        get path
      end

      subject(:response) { last_response }

      context 'for a user different from the author' do
        let(:attachment) { other_user_attachment }

        it "responds with 404" do
          expect(subject.status).to eq 404
        end
      end
    end
  end
end
