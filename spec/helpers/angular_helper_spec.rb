

require 'spec_helper'

describe AngularHelper, type: :helper do
  let(:tag_name) { 'op-test' }
  let(:options) do
    {
      class: 'op-classname',
      inputs: inputs,
      data: data
    }
  end
  let(:data) do
    {
      'qa-selector': 'foo'
    }
  end

  subject { helper.angular_component_tag tag_name, options }

  describe 'inputs transformations' do
    let(:inputs) do
      {
        key: 'value',
        number: 1,
        anArray: [1, 2, 3],
        someRandomObject: { complex: true, foo: 'bar' }
      }
    end

    let(:expected) do
      <<~HTML.squish
        <op-test
          class="op-classname"
          data-key="&quot;value&quot;"
          data-number="1"
          data-an-array="[1,2,3]"
          data-some-random-object="{&quot;complex&quot;:true,&quot;foo&quot;:&quot;bar&quot;}"
          data-qa-selector="foo"
        /></op-test>
      HTML
    end

    it 'converts the inputs' do
      expect(subject).to be_html_eql(expected)
    end
  end
end
