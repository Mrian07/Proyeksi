#-- encoding: UTF-8



shared_examples_for 'labelled' do
  it 'has a label with title' do
    is_expected.to have_selector 'label.form--label[title]'
  end
end

shared_examples_for 'not labelled' do
  it 'does not have a label with title' do
    is_expected.not_to have_selector 'label.form--label[title]'
  end
end

shared_examples_for 'labelled by default' do
  context 'by default' do
    it_behaves_like 'labelled'
  end

  context 'with no_label option' do
    let(:options) { { no_label: true, label: false } }

    it_behaves_like 'not labelled'
  end
end

shared_examples_for 'wrapped in container' do |container = 'field-container'|
  it { is_expected.to have_selector "span.form--#{container}", count: 1 }

  context 'with additional class provided' do
    let(:css_class) { 'my-additional-class' }
    let(:expected_container_count) { defined?(container_count) ? container_count : 1 }

    before do
      options[:container_class] = css_class
    end

    it 'has the class' do
      is_expected.to have_selector "span.#{css_class}", count: expected_container_count
    end
  end
end

shared_examples_for 'not wrapped in container' do |container = 'field-container'|
  it { is_expected.not_to have_selector "span.form--#{container}" }
end

shared_examples_for 'wrapped in field-container by default' do
  context 'by default' do
    it_behaves_like 'wrapped in container'
  end

  context 'with no_label option' do
    let(:options) { { no_label: true, label: false } }

    it_behaves_like 'not wrapped in container'
  end
end
