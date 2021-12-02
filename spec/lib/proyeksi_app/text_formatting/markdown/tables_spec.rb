

require 'spec_helper'
require_relative './expected_markdown'

describe ProyeksiApp::TextFormatting,
         'tables' do
  include_context 'expected markdown modules'

  context 'for a markdown table' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          This is a table with header cells:

          |header|header|
          |------|------|
          |cell11|cell12|
          |cell21|cell22|
          |cell31|cell32|
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <p class="op-uc-p">This is a table with header cells:</p>
          <figure class="op-uc-figure">
            <div class="op-uc-figure--content">
              <table class="op-uc-table">
                <thead class="op-uc-table--head">
                  <tr class="op-uc-table--row">
                    <th class="op-uc-table--cell op-uc-table--cell_head">header</th>
                    <th class="op-uc-table--cell op-uc-table--cell_head">header</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="op-uc-table--row">
                    <td class="op-uc-table--cell">cell11</td>
                    <td class="op-uc-table--cell">cell12</td>
                  </tr>
                  <tr class="op-uc-table--row">
                    <td class="op-uc-table--cell">cell21</td>
                    <td class="op-uc-table--cell">cell22</td>
                  </tr>
                  <tr class="op-uc-table--row">
                    <td class="op-uc-table--cell">cell31</td>
                    <td class="op-uc-table--cell">cell32</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </figure>
        EXPECTED
      end
    end
  end

  context 'for an html table' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          <table>
            <thead class="op-uc-table--head">
              <tr>
                <th>header</th>
                <th>header</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>cell11</td>
                <td>cell12</td>
              </tr>
              <tr>
                <td>cell21</td>
                <td>cell22</td>
              </tr>
              <tr>
                <td>cell31</td>
                <td>cell32</td>
              </tr>
            </tbody>
          </table>
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <figure class="op-uc-figure">
            <div class="op-uc-figure--content">
              <table class="op-uc-table">
                <thead class="op-uc-table--head">
                  <tr class="op-uc-table--row">
                    <th class="op-uc-table--cell op-uc-table--cell_head">header</th>
                    <th class="op-uc-table--cell op-uc-table--cell_head">header</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="op-uc-table--row">
                    <td class="op-uc-table--cell">cell11</td>
                    <td class="op-uc-table--cell">cell12</td>
                  </tr>
                  <tr class="op-uc-table--row">
                    <td class="op-uc-table--cell">cell21</td>
                    <td class="op-uc-table--cell">cell22</td>
                  </tr>
                  <tr class="op-uc-table--row">
                    <td class="op-uc-table--cell">cell31</td>
                    <td class="op-uc-table--cell">cell32</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </figure>
        EXPECTED
      end
    end

    context 'already having a figure parent element' do
      it_behaves_like 'format_text produces' do
        let(:raw) do
          <<~RAW
            <figure>
              <div>
                <table>
                  <tbody>
                    <tr>
                      <td>cell11</td>
                      <td>cell12</td>
                    </tr>
                    <tr>
                      <td>cell21</td>
                      <td>cell22</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </figure>
          RAW
        end

        let(:expected) do
          <<~EXPECTED
            <figure class="op-uc-figure">
              <div class="op-uc-figure--content">
                <table class="op-uc-table">
                  <tbody>
                    <tr class="op-uc-table--row">
                      <td class="op-uc-table--cell">cell11</td>
                      <td class="op-uc-table--cell">cell12</td>
                    </tr>
                    <tr class="op-uc-table--row">
                      <td class="op-uc-table--cell">cell21</td>
                      <td class="op-uc-table--cell">cell22</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </figure>
          EXPECTED
        end
      end
    end
  end
end
