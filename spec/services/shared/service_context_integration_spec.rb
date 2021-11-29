#-- encoding: UTF-8



require 'spec_helper'

describe Shared::ServiceContext, 'integration', type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }

  let(:instance) do
    Class.new do
      include Shared::ServiceContext

      attr_accessor :user

      def initialize(user)
        self.user = user
      end

      def test_method_failure(model)
        in_context model, true do
          Setting.connection.execute <<~SQL
            INSERT INTO settings (name, value)
            VALUES ('test_setting', 'abc')
          SQL

          ServiceResult.new success: false
        end
      end

      def test_method_success(model)
        in_context model, true do
          Setting.connection.execute <<~SQL
            INSERT INTO settings (name, value)
            VALUES ('test_setting', 'abc')
          SQL

          ServiceResult.new success: true
        end
      end
    end.new(user)
  end

  describe '#in_context' do
    context 'with a model' do
      let(:model) { User.new } # model implementation is irrelevant

      context 'with a failure result' do
        it 'reverts all database changes' do
          expect { instance.test_method_failure(model) }
            .not_to change { Setting.count }
        end
      end

      context 'with a success result' do
        it 'keeps database changes' do
          expect { instance.test_method_success(model) }
            .to change { Setting.count }
        end
      end
    end

    context 'without a model' do
      let(:model) { nil }

      context 'with a failure result' do
        it 'reverts all database changes' do
          expect { instance.test_method_failure(model) }
            .not_to change { Setting.count }
        end
      end

      context 'with a success result' do
        it 'keeps database changes' do
          expect { instance.test_method_success(model) }
            .to change { Setting.count }
        end
      end
    end
  end
end
