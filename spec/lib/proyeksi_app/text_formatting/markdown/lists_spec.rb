

require 'spec_helper'
require_relative './expected_markdown'

describe ProyeksiApp::TextFormatting,
         'lists' do
  include_context 'expected markdown modules'

  context 'ordered lists' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          1. First item
          2. Second item
          3. Third item
          5. Item out of line
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <ol class="op-uc-list">
            <li class="op-uc-list--item">First item</li>
            <li class="op-uc-list--item">Second item</li>
            <li class="op-uc-list--item">Third item</li>
            <li class="op-uc-list--item">Item out of line</li>
          </ol>
        EXPECTED
      end
    end
  end

  context 'unordered lists' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          * First item
          * Second item
            * First subitem of second item
          * Third item
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <ul class="op-uc-list">
            <li class="op-uc-list--item">First item</li>
            <li class="op-uc-list--item">Second item
            <ul class="op-uc-list">
              <li class="op-uc-list--item">First subitem of second item</li>
            </ul>
            </li>
            <li class="op-uc-list--item">Third item</li>
          </ul>
        EXPECTED
      end
    end
  end

  context 'todo list' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          *   [ ] First ToDo
          *   [ ] Second ToDo
          *   [ ] Third ToDo
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <ul class="op-uc-list_task-list op-uc-list">
            <li class="op-uc-list--item">
                <input type="checkbox" class="op-uc-list--task-checkbox" disabled>
                First ToDo
            </li>
            <li class="op-uc-list--item">
                <input type="checkbox" class="op-uc-list--task-checkbox" disabled>
                Second ToDo
            </li>
            <li class="op-uc-list--item">
                <input type="checkbox" class="op-uc-list--task-checkbox" disabled>
                Third ToDo
            </li>
          </ul>
        EXPECTED
      end
    end

    context 'in a table' do
      it_behaves_like 'format_text produces' do
        let(:raw) do
          <<~RAW
            <table>
              <tbody>
                <tr>
                  <td>
                    <ul class="op-uc-list_task-list op-uc-list">
                      <li>
                        <code class='op-uc-code'>
                          <label class="op-uc-list__label"><input type="checkbox" disabled="disabled">
                            <span class="op-uc-list__label__description">asdf</span>
                          </label>
                        </code>
                      </li>
                    </ul>
                  </td>
                  <td>
                    <ul class="op-uc-list_task-list op-uc-list">
                      <li>
                        <a class="op-uc-link" href="https://example.com/">
                          <label class="op-uc-list__label">
                            <input type="checkbox" disabled="disabled">
                            <span class="op-uc-list__label__description">asdfasd</span>
                          </label>
                          <span class="op-uc-list__label__description"> asdf</span>
                        </a>
                      </li>
                    </ul>
                  </td>
                  <td>
                    <ul class="op-uc-list_task-list op-uc-list">
                      <li>
                        <label class="op-uc-list__label">
                          <input type="checkbox" disabled="disabled">
                          <span
                            class="op-uc-list__label__description">asdfasdf</span>
                          </label>
                        </li>
                    </ul>
                  </td>
                </tr>
                <tr>
                  <td>
                    <ul class="op-uc-list_task-list op-uc-list">
                      <li>
                        <label class="op-uc-list__label">
                          <input type="checkbox" disabled="disabled">
                        </label>
                      </li>
                    </ul>
                  </td>
                  <td>
                    <ul class="op-uc-list_task-list op-uc-list">
                      <li>
                        <label class="op-uc-list__label">
                          <strong>
                            <input type="checkbox" disabled="disabled">
                          </strong>
                          <span
                            class="op-uc-list__label__description">
                            <strong>asdf</strong>
                          </span>
                        </label>
                      </li>
                    </ul>
                  </td>
                  <td>
                    <ul class="op-uc-list_task-list op-uc-list">
                      <li>
                        <label class="op-uc-list__label">
                          <input type="checkbox" disabled="disabled"></label>
                        </li>
                    </ul>
                  </td>
                </tr>
              </tbody>
            </table>
          RAW
        end

        let(:expected) do
          <<~EXPECTED
            <figure class="op-uc-figure">#{' '}
              <div class="op-uc-figure--content">
                <table class="op-uc-table">
                  <tbody>
                    <tr class="op-uc-table--row">
                      <td class="op-uc-table--cell">
                        <ul class="op-uc-list_task-list op-uc-list">
                          <li class="op-uc-list--item">
                            <input type="checkbox" class="op-uc-list--task-checkbox" disabled>
                            <code class='op-uc-code'>
                              <span>asdf</span>
                            </code>
                          </li>
                        </ul>
                      </td>
                      <td class="op-uc-table--cell">
                        <ul class="op-uc-list_task-list op-uc-list">
                          <li class="op-uc-list--item">
                            <input type="checkbox" class="op-uc-list--task-checkbox" disabled>
                            <a class="op-uc-link" href="https://example.com/" rel="noopener noreferrer">
                              <span>asdfasd</span>
                              <span> asdf</span>
                            </a>
                          </li>
                        </ul>
                      </td>
                      <td class="op-uc-table--cell">
                        <ul class="op-uc-list_task-list op-uc-list" >
                          <li class="op-uc-list--item">
                            <input type="checkbox" class="op-uc-list--task-checkbox" disabled>
                            <span>asdfasdf</span>
                          </li>
                        </ul>
                      </td>
                    </tr>
                    <tr class="op-uc-table--row">
                      <td class="op-uc-table--cell">
                        <ul class="op-uc-list_task-list op-uc-list">
                          <li class="op-uc-list--item">
                            <input type="checkbox" class="op-uc-list--task-checkbox" disabled>
                          </li>
                        </ul>
                      </td>
                      <td class="op-uc-table--cell">
                        <ul class="op-uc-list_task-list op-uc-list">
                          <li class="op-uc-list--item">
                            <input type="checkbox" class="op-uc-list--task-checkbox" disabled>
                            <strong></strong>
                            <span><strong>asdf</strong></span>
                          </li>
                        </ul>
                      </td>
                      <td class="op-uc-table--cell">
                        <ul class="op-uc-list_task-list op-uc-list">
                          <li class="op-uc-list--item">
                            <input type="checkbox" class="op-uc-list--task-checkbox" disabled>
                          </li>
                        </ul>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </figure>
          EXPECTED
        end
      end
    end

    context 'in a table and with a link on second place' do
      it_behaves_like 'format_text produces' do
        let(:raw) do
          <<~RAW
            <table>
              <tbody>
                <tr>
                  <td>asdf</td>
                  <td>asdfasdf</td>
                </tr>
                <tr>
                  <td>
                    <ul class="op-uc-list op-uc-list_task-list">
                      <li>
                        <label class="op-uc-list__label">
                          <input type="checkbox" disabled="disabled">
                          <span class="op-uc-list__label__description">asdfasdfasdf </span>
                        </label>
                        <a class="op-uc-link" href="https://example.com/">
                          <label class="op-uc-list__label">
                            <span class="op-uc-list__label__description">foobar</span>
                          </label>
                        </a>
                      </li>
                    </ul>
                  </td>
                  <td></td>
                </tr>
              </tbody>
            </table>
          RAW
        end

        let(:expected) do
          <<~EXPECTED
            <figure class="op-uc-figure">#{' '}
              <div class="op-uc-figure--content">
                <table class="op-uc-table">
                  <tbody>
                    <tr class="op-uc-table--row">
                      <td class="op-uc-table--cell">asdf</td>
                      <td class="op-uc-table--cell">asdfasdf</td>
                    </tr>
                    <tr class="op-uc-table--row">
                      <td class="op-uc-table--cell">
                        <ul class="op-uc-list_task-list op-uc-list">
                          <li class="op-uc-list--item">
                            <input type="checkbox" class="op-uc-list--task-checkbox" disabled>
                            <span>asdfasdfasdf </span>
                            <a class="op-uc-link" href="https://example.com/" rel="noopener noreferrer">
                              <span>foobar</span>
                            </a>
                          </li>
                        </ul>
                      </td>
                      <td class="op-uc-table--cell"></td>
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
