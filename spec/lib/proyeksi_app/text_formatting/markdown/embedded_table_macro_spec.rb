

require 'spec_helper'
require_relative './expected_markdown'

describe ProyeksiApp::TextFormatting,
         'toc macro' do
  include_context 'expected markdown modules'

  it_behaves_like 'format_text produces' do
    let(:raw) do
      <<~RAW
        <macro class="embedded-table op-uc-placeholder"
               data-query-props="{&quot;columns[]&quot;:[&quot;id&quot;,&quot;subject&quot;,&quot;type&quot;,&quot;status&quot;,&quot;assignee&quot;,&quot;updatedAt&quot;],&quot;showSums&quot;:false,&quot;timelineVisible&quot;:false,&quot;highlightingMode&quot;:&quot;inline&quot;,&quot;highlightedAttributes[]&quot;:[&quot;/api/v3/queries/columns/status&quot;,&quot;/api/v3/queries/columns/priority&quot;,&quot;/api/v3/queries/columns/dueDate&quot;],&quot;showHierarchies&quot;:true,&quot;groupBy&quot;:&quot;&quot;,&quot;filters&quot;:&quot;[{\&quot;status\&quot;:{\&quot;operator\&quot;:\&quot;o\&quot;,\&quot;values\&quot;:[]}}]&quot;,&quot;sortBy&quot;:&quot;[[\&quot;id\&quot;,\&quot;asc\&quot;]]&quot;}">
        </macro>
      RAW
    end

    let(:expected) do
      <<~EXPECTED
        <p class="op-uc-p">
          <macro class="embedded-table"
                 data-query-props='{"columns[]":["id","subject","type","status","assignee","updatedAt"],"showSums":false,"timelineVisible":false,"highlightingMode":"inline","highlightedAttributes[]":["/api/v3/queries/columns/status","/api/v3/queries/columns/priority","/api/v3/queries/columns/dueDate"],"showHierarchies":true,"groupBy":"","filters":"[{"status":{"operator":"o","values":[]}}]","sortBy":"[["id","asc"]]"}'><br>
        </p>
      EXPECTED
    end
  end
end
