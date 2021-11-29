

require 'support/pages/page'

module Pages
  module Types
    class Index < ::Pages::Page
      def path
        "/types"
      end

      def expect_listed(*types)
        rows = page.all 'td.timelines-pet-name'

        expected = types.map { |t| canonical_name(t) }

        expect(rows.map(&:text)).to eq(expected)
      end

      def expect_successful_create
        expect_toast message: I18n.t(:notice_successful_create)
      end

      def expect_successful_update
        expect_toast message: I18n.t(:notice_successful_update)
      end

      def click_new
        within '.toolbar-items' do
          click_link 'Type'
        end
      end

      def click_edit(type)
        within_row(type) do
          click_link canonical_name(type)
        end
      end

      def delete(type)
        within_row(type) do
          find('.icon-delete').click
        end

        accept_alert_dialog!
      end

      private

      def within_row(type)
        row = page.find('table tr', text: canonical_name(type))

        within row do
          yield row
        end
      end

      def canonical_name(type)
        type.respond_to?(:name) ? type.name : type
      end

      def toast_type
        :rails
      end
    end
  end
end
