

require 'spec_helper'

describe Queries::WorkPackages::Columns::WorkPackageColumn, type: :model do
  it "allows to be constructed with attribute highlightable" do
    expect(described_class.new('foo', highlightable: true).highlightable?).to eq(true)
  end

  it "allows to be constructed without attribute highlightable" do
    expect(described_class.new('foo').highlightable?).to eq(false)
  end
end
