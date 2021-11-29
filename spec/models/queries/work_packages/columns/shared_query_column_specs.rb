

shared_examples_for 'query column' do
  describe '#groupable' do
    it 'is the name if true is provided' do
      instance.groupable = true

      expect(instance.groupable).to eql(instance.name.to_s)
    end

    it 'is the value if something trueish is provided' do
      instance.groupable = 'lorem ipsum'

      expect(instance.groupable).to eql('lorem ipsum')
    end

    it 'is false if false is provided' do
      instance.groupable = false

      expect(instance.groupable).to be_falsey
    end

    it 'is false if nothing is provided' do
      instance.groupable = nil

      expect(instance.groupable).to be_falsey
    end
  end

  describe '#sortable' do
    it 'is the name if true is provided' do
      instance.sortable = true

      expect(instance.sortable).to eql(instance.name.to_s)
    end

    it 'is the value if something trueish is provided' do
      instance.sortable = 'lorem ipsum'

      expect(instance.sortable).to eql('lorem ipsum')
    end

    it 'is false if false is provided' do
      instance.sortable = false

      expect(instance.sortable).to be_falsey
    end

    it 'is false if nothing is provided' do
      instance.sortable = nil

      expect(instance.sortable).to be_falsey
    end
  end

  describe '#groupable?' do
    it 'is false by default' do
      expect(instance.groupable?).to be_falsey
    end

    it 'is true if told so' do
      instance.groupable = true

      expect(instance.groupable?).to be_truthy
    end

    it 'is true if a value is provided (e.g. for specifying sql code)' do
      instance.groupable = 'COALESCE(null, 1)'

      expect(instance.groupable?).to be_truthy
    end
  end

  describe '#sortable?' do
    it 'is false by default' do
      expect(instance.sortable?).to be_falsey
    end

    it 'is true if told so' do
      instance.sortable = true

      expect(instance.sortable?).to be_truthy
    end

    it 'is true if a value is provided (e.g. for specifying sql code)' do
      instance.sortable = 'COALESCE(null, 1)'

      expect(instance.sortable?).to be_truthy
    end
  end
end
