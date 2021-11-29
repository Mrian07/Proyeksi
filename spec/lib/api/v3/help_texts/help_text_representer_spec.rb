

require 'spec_helper'

describe ::API::V3::HelpTexts::HelpTextRepresenter do
  include ::API::V3::Utilities::PathHelper

  let(:user) { FactoryBot.build_stubbed :admin }

  let(:help_text) do
    FactoryBot.build_stubbed :work_package_help_text,
                             attribute_name: 'status',
                             help_text: 'This is a help text for **status** attribute.'
  end

  let(:representer) { described_class.new help_text, current_user: user }

  let(:result) do
    {
      "_type" => "HelpText",
      "_links" => {
        "self" => {
          "href" => "/api/v3/help_texts/#{help_text.id}"
        },
        "editText" => {
          "href" => edit_attribute_help_text_path(help_text.id),
          "type" => "text/html"
        },
        "attachments" => {
          "href" => api_v3_paths.attachments_by_help_text(help_text.id)
        },
        "addAttachment" => {
          "href" => api_v3_paths.attachments_by_help_text(help_text.id),
          "method" => "post"
        }
      },
      "id" => help_text.id,
      "scope" => "WorkPackage",
      "attribute" => "status",
      "attributeCaption" => "Status",
      "helpText" => {
        "format" => 'markdown',
        "raw" => 'This is a help text for **status** attribute.',
        "html" => '<p class="op-uc-p">This is a help text for <strong>status</strong> attribute.</p>'
      }
    }
  end

  it 'serializes the relation correctly' do
    data = JSON.parse representer.to_json
    expect(data).to eq result
  end
end
