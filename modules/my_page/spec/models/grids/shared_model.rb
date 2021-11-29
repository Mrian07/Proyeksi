

shared_examples_for 'grid attributes' do
  describe 'attributes' do
    it '#row_count' do
      instance.row_count = 5
      expect(instance.row_count)
        .to eql 5
    end

    it '#column_count' do
      instance.column_count = 5
      expect(instance.column_count)
        .to eql 5
    end

    it '#name' do
      instance.name = 'custom 123'
      expect(instance.name)
        .to eql 'custom 123'

      # can be empty
      instance.name = nil
      expect(instance).to be_valid
    end

    it '#options' do
      value = {
        some: 'value',
        and: {
          also: 1
        }
      }

      instance.options = value
      expect(instance.options)
        .to eql value
    end

    it '#widgets' do
      widgets = [
        Grids::Widget.new(start_row: 2),
        Grids::Widget.new(start_row: 5)
      ]

      instance.widgets = widgets
      expect(instance.widgets)
        .to match_array widgets
    end
  end
end
