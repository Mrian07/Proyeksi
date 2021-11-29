

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "CostQuery::Validation", type: :model do
  class CostQuery::SomeBase
    include Report::Validation

    def engine
      CostQuery
    end
  end

  it "should be valid with no validations whatsoever" do
    obj = CostQuery::SomeBase.new
    expect(obj.validate("foo")).to be_truthy
    expect(obj.validations.size).to eq(0)
  end

  it "should allow for multiple validations" do
    obj = CostQuery::SomeBase.new
    obj.register_validations(%i[integers dates])
    expect(obj.validations.size).to eq(2)
  end

  it "should have errors set when we try to validate something invalid" do
    obj = CostQuery::SomeBase.new
    obj.register_validation(:integers)
    expect(obj.validate("this ain't a number, right?")).to be_falsey
    expect(obj.errors[:int].size).to eq(1)
  end

  it "should have no errors set when we try to validate something valid" do
    obj = CostQuery::SomeBase.new
    obj.register_validation(:integers)
    expect(obj.validate(1, 2, 3, 4)).to be_truthy
    expect(obj.errors[:int].size).to eq(0)
  end

  it "should validate integers correctly" do
    obj = CostQuery::SomeBase.new
    obj.register_validation(:integers)
    expect(obj.validate(1, 2, 3, 4)).to be_truthy
    expect(obj.errors[:int].size).to eq(0)
    expect(obj.validate("I ain't gonna work on Maggies Farm no more")).to be_falsey
    expect(obj.errors[:int].size).to eq(1)
    expect(obj.validate("You've got the touch!", "You've got the power!")).to be_falsey
    expect(obj.errors[:int].size).to eq(2)
    expect(obj.validate(1, "This is a good burger")).to be_falsey
    expect(obj.errors[:int].size).to eq(1)
  end

  it "should validate dates correctly" do
    obj = CostQuery::SomeBase.new
    obj.register_validation(:dates)
    expect(obj.validate("2010-04-15")).to be_truthy
    expect(obj.errors[:date].size).to eq(0)
    expect(obj.validate("2010-15-15")).to be_falsey
    expect(obj.errors[:date].size).to eq(1)
    expect(obj.validate("2010-04-31")).to be_falsey
    expect(obj.errors[:date].size).to eq(1)
  end
end
