

require 'spec_helper'
require_relative './expected_markdown'

describe ProyeksiApp::TextFormatting,
         'Setting variable' do
  include_context 'expected markdown modules'

  describe 'attribute label macros' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          Inline reference to variable setting: {{opSetting:host_name}}

          Inline reference to base_url variable: {{opSetting:base_url}}

          [Link with setting]({{opSetting:base_url}}/foo/bar)

          Inline reference to invalid variable: {{opSetting:smtp_password}}

          Inline reference to missing variable: {{opSetting:does_not_exist}}
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <p class="op-uc-p">
            Inline reference to variable setting: #{ProyeksiApp::StaticRouting::UrlHelpers.host}
          </p>
          <p class="op-uc-p">
            Inline reference to base_url variable: #{ProyeksiApp::Application.root_url}
          </p>
          <p class="op-uc-p">
            <a href="#{ProyeksiApp::Application.root_url}/foo/bar" rel="noopener noreferrer"
               class="op-uc-link">Link with setting</a>
          </p>
          <p class="op-uc-p">
            Inline reference to invalid variable: {{opSetting:smtp_password}}
          </p>
          <p class="op-uc-p">
            Inline reference to missing variable: {{opSetting:does_not_exist}}
          </p>
        EXPECTED
      end
    end
  end
end
