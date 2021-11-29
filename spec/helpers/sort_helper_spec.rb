

require 'spec_helper'

describe SortHelper, type: :helper do
  describe '#sort_header_tag' do
    let(:output) do
      helper.sort_header_tag('id')
    end
    let(:sort_key) { '' }
    let(:sort_asc) { true }
    let(:sort_criteria) do
      double('sort_criteria', first_key: sort_key,
                              first_asc?: sort_asc,
                              to_param: 'sort_criteria_params').as_null_object
    end

    before do
      # helper relies on this instance var
      @sort_criteria = sort_criteria

      # fake having called '/work_packages'
      allow(helper)
        .to receive(:url_options)
        .and_return(url_options.merge(controller: 'work_packages', action: 'index'))
    end

    it 'renders a th with a sort link' do
      expect(output).to be_html_eql(%{
        <th title="Sort by &quot;Id&quot;">
          <div class="generic-table--sort-header-outer">
            <div class="generic-table--sort-header">
              <span>
                <a href="/work_packages?sort=sort_criteria_params"
                   title="Sort by &quot;Id&quot;">Id</a>
              </span>
            </div>
          </div>
        </th>
      })
    end

    context 'when sorting by the column' do
      let(:sort_key) { 'id' }

      it 'should add the sort class' do
        expect(output).to be_html_eql(%{
          <th title="Ascending sorted by &quot;Id&quot;">
            <div class="generic-table--sort-header-outer">
              <div class="generic-table--sort-header">
                <span class="sort asc">
                  <a href="/work_packages?sort=sort_criteria_params"
                     title="Ascending sorted by &quot;Id&quot;">Id</a>
                </span>
              </div>
            </div>
          </th>
        })
      end
    end

    context 'when sorting desc by the column' do
      let(:sort_key) { 'id' }
      let(:sort_asc) { false }

      it 'should add the sort class' do
        expect(output).to be_html_eql(%{
          <th title="Descending sorted by &quot;Id&quot;">
            <div class="generic-table--sort-header-outer">
              <div class="generic-table--sort-header">
                <span class="sort desc">
                  <a href="/work_packages?sort=sort_criteria_params"
                     title="Descending sorted by &quot;Id&quot;">Id</a>
                </span>
              </div>
            </div>
          </th>
        })
      end
    end
  end
end
