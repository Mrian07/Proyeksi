

require 'spec_helper'

describe Authorization::EnterpriseService do
  let(:token_object) do
    token = OpenProject::Token.new
    token.subscriber = 'Foobar'
    token.mail = 'foo@example.org'
    token.starts_at = Date.today
    token.expires_at = nil

    token
  end
  let(:token) { double('EnterpriseToken', token_object: token_object) }
  let(:instance) { described_class.new(token) }
  let(:result) { instance.call(action) }
  let(:action) { :an_action }

  describe '#initialize' do
    it 'has the token' do
      expect(instance.token).to eql token
    end
  end

  describe 'expiry' do
    before do
      allow(token).to receive(:expired?).and_return(expired)
    end

    context 'when expired' do
      let(:expired) { true }

      it 'returns a false result' do
        expect(result).to be_kind_of ServiceResult
        expect(result.result).to be_falsey
        expect(result.success?).to be_falsey
      end
    end

    context 'when active' do
      let(:expired) { false }

      context 'invalid action' do
        it 'returns false' do
          expect(result.result).to be_falsey
        end
      end

      %i(define_custom_style
         multiselect_custom_fields
         edit_attribute_groups
         work_package_query_relation_columns
         attribute_help_texts
         grid_widget_wp_graph).each do |guarded_action|
        context "guarded action #{guarded_action}" do
          let(:action) { guarded_action }

          it 'returns a true result' do
            expect(result).to be_kind_of ServiceResult
            expect(result.result).to be_truthy
            expect(result.success?).to be_truthy
          end
        end
      end
    end
  end
end
