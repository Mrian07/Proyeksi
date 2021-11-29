

require 'spec_helper'

describe Queries::Notifications::NotificationQuery, type: :model do
  shared_let(:recipient) { FactoryBot.create :user }

  let(:instance) { described_class.new(user: recipient) }
  let(:base_scope) { Notification.recipient(recipient) }

  context 'without a filter' do
    describe '#results' do
      it 'is the same as getting all the users' do
        expect(instance.results.to_sql).to eql base_scope.order(id: :desc).to_sql
      end
    end
  end

  context 'with a read_ian filter' do
    before do
      instance.where('read_ian', '=', ['t'])
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = base_scope.where("notifications.read_ian IN ('t')").order(id: :desc)

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end

    describe '#valid?' do
      it 'is true' do
        expect(instance).to be_valid
      end

      it 'is invalid if the filter is invalid' do
        instance.where('read_ian', '=', [''])
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
        expected = Notification.where(Arel::Nodes::Equality.new(1, 0))

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
        expected = base_scope.merge(Notification.order(id: :asc))

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end
  end

  context 'with a read_ian sortation' do
    before do
      instance.order(read_ian: :desc)
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = <<~SQL.squish
          SELECT "notifications".* FROM "notifications"
          WHERE "notifications"."recipient_id" = #{recipient.id}
          ORDER BY "notifications"."read_ian" DESC, "notifications"."id" DESC
        SQL

        expect(instance.results.to_sql).to eql expected
      end
    end
  end

  context 'with a reason sortation' do
    before do
      instance.order(reason: :desc)
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = <<~SQL.squish
          SELECT "notifications".* FROM "notifications"
          WHERE "notifications"."recipient_id" = #{recipient.id}
          ORDER BY "notifications"."reason" DESC, "notifications"."id" DESC
        SQL

        expect(instance.results.to_sql).to eql expected
      end
    end
  end

  context 'with a non existing sortation' do
    before do
      instance.order(non_existing: :desc)
    end

    describe '#results' do
      it 'returns a query not returning anything' do
        expected = Notification.where(Arel::Nodes::Equality.new(1, 0))

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end

    describe 'valid?' do
      it 'is false' do
        expect(instance).to be_invalid
      end
    end
  end

  context 'with a reason group_by' do
    before do
      instance.group(:reason)
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = <<~SQL.squish
          SELECT "notifications"."reason", COUNT(*) FROM "notifications"
          WHERE "notifications"."recipient_id" = #{recipient.id}
          GROUP BY "notifications"."reason"
          ORDER BY "notifications"."reason" ASC
        SQL

        expect(instance.groups.to_sql).to eql expected
      end
    end
  end

  context 'with a project group_by' do
    before do
      instance.group(:project)
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = <<~SQL.squish
          SELECT "notifications"."project_id", COUNT(*) FROM "notifications"
          WHERE "notifications"."recipient_id" = #{recipient.id}
          GROUP BY "notifications"."project_id"
          ORDER BY "notifications"."project_id" ASC
        SQL

        expect(instance.groups.to_sql).to eql expected
      end
    end
  end

  context 'with a non existing group_by' do
    before do
      instance.group(:does_not_exist)
    end

    describe '#results' do
      it 'returns a query not returning anything' do
        expected = Notification.where(Arel::Nodes::Equality.new(1, 0))

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
