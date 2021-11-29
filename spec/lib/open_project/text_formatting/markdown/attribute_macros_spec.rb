

require 'spec_helper'
require_relative './expected_markdown'

describe OpenProject::TextFormatting,
         'Attribute macros' do
  include_context 'expected markdown modules'

  describe 'attribute label macros' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          # My headline

          Inline reference to WP by ID: workPackageLabel:1234:subject

          Inline reference to WP by subject: workPackageLabel:"Some subject":"Some custom field with spaces"

          Inline reference to project: projectLabel:status

          Inline reference to project with id: projectLabel:"some id":status
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <h1 class="op-uc-h1" id="my-headline">
            My headline
            <a class="op-uc-link_permalink icon-link op-uc-link" aria-hidden="true" href="#my-headline"></a>
          </h1>
          <p class="op-uc-p">
            Inline reference to WP by ID: <macro class="macro--attribute-label" data-model="workPackage" data-id="1234" data-attribute="subject"></macro>
          </p>
          <p class="op-uc-p">
            Inline reference to WP by subject: <macro class="macro--attribute-label" data-model="workPackage" data-id="Some subject" data-attribute="Some custom field with spaces"></macro>
          </p>
          <p class="op-uc-p">
            Inline reference to project: <macro class="macro--attribute-label" data-model="project" data-attribute="status"></macro>
          </p>
          <p class="op-uc-p">
            Inline reference to project with id: <macro class="macro--attribute-label" data-model="project" data-id="some id" data-attribute="status"></macro>
          </p>
        EXPECTED
      end
    end
  end

  describe 'attribute value macros' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          # My headline

          Inline reference to WP by ID: workPackageValue:1234:subject

          Inline reference to WP by subject: workPackageValue:"Some subject":"Some custom field with spaces"

          Inline reference to project: projectValue:status

          Inline reference to project with id: projectValue:"some id":status
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <h1 class="op-uc-h1" id="my-headline">
            My headline
            <a class="op-uc-link_permalink icon-link op-uc-link" aria-hidden="true" href="#my-headline"></a>
          </h1>
          <p class="op-uc-p">
            Inline reference to WP by ID: <macro class="macro--attribute-value" data-model="workPackage" data-id="1234" data-attribute="subject"></macro>
          </p>
          <p class="op-uc-p">
            Inline reference to WP by subject: <macro class="macro--attribute-value" data-model="workPackage" data-id="Some subject" data-attribute="Some custom field with spaces"></macro>
          </p>
          <p class="op-uc-p">
            Inline reference to project: <macro class="macro--attribute-value" data-model="project" data-attribute="status"></macro>
          </p>
          <p class="op-uc-p">
            Inline reference to project with id: <macro class="macro--attribute-value" data-model="project" data-id="some id" data-attribute="status"></macro>
          </p>
        EXPECTED
      end
    end
  end
end
