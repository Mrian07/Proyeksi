

require 'spec_helper'

describe Queries::PlaceholderUsers::PlaceholderUserQuery, type: :model do
  let(:instance) { described_class.new }
  let(:base_scope) { PlaceholderUser.order(id: :desc) }

  context 'without a filter' do
    describe '#results' do
      it 'is the same as getting all the users' do
        expect(instance.results.to_sql).to eql base_scope.to_sql
      end
    end
  end

  context 'with a name filter' do
    before do
      instance.where('name', '~', ['a user'])
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = base_scope
                     .merge(PlaceholderUser
                     .where(["LOWER(CONCAT(users.firstname, CONCAT(' ', users.lastname))) LIKE ?",
                             "%a user%"]))

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end

    describe '#valid?' do
      it 'is true' do
        expect(instance).to be_valid
      end

      it 'is invalid if the filter is invalid' do
        instance.where('name', '=', [''])
        expect(instance).to be_invalid
      end
    end
  end

  context 'with a group filter' do
    let(:group_1) { FactoryBot.build_stubbed(:group) }

    before do
      allow(Group)
        .to receive(:exists?)
        .and_return(true)

      allow(Group)
        .to receive(:all)
        .and_return([group_1])

      instance.where('group', '=', [group_1.id])
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = base_scope
                       .merge(PlaceholderUser
                                .where(["users.id IN (#{PlaceholderUser.in_group([group_1.id.to_s]).select(:id).to_sql})"]))

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end

    describe '#valid?' do
      it 'is true' do
        expect(instance).to be_valid
      end

      it 'is invalid if the filter is invalid' do
        instance.where('group', '=', [''])
        expect(instance).to be_invalid
      end
    end
  end

  context 'with a non existent filter' do
    before do
      instance.where('not_supposed_to_exist', '=', ['bogus'])
    end

    describe '#results' do
      it 'returns a query not returning anything' do
        expected = PlaceholderUser.where(Arel::Nodes::Equality.new(1, 0))

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end

    describe 'valid?' do
      it 'is false' do
        expect(instance).to be_invalid
      end

      it 'returns the error on the filter' do
        instance.valid?

        expect(instance.errors[:filters]).to eql ["Not supposed to exist does not exist."]
      end
    end
  end

  context 'with an id sortation' do
    before do
      instance.order(id: :asc)
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = PlaceholderUser.merge(PlaceholderUser.order(id: :asc))

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end
  end

  context 'with a name sortation' do
    before do
      instance.order(name: :desc)
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = "SELECT \"users\".* FROM \"users\" WHERE \"users\".\"type\" = 'PlaceholderUser' ORDER BY \"users\".\"lastname\" DESC, \"users\".\"id\" DESC"

        expect(instance.results.to_sql).to eql expected
      end
    end
  end

  context 'with a group sortation' do
    before do
      instance.order(group: :desc)
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = PlaceholderUser.merge(PlaceholderUser.joins(:groups).order("groups_users.lastname DESC")).order(id: :desc)

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end
  end

  context 'with a non existing sortation' do
    # this is a field protected from sortation
    before do
      instance.order(password: :desc)
    end

    describe '#results' do
      it 'returns a query not returning anything' do
        expected = PlaceholderUser.where(Arel::Nodes::Equality.new(1, 0))

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end

    describe 'valid?' do
      it 'is false' do
        expect(instance).to be_invalid
      end
    end
  end
end
