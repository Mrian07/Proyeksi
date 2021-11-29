

require 'support/pages/page'

module Pages
  module Reminders
    class Settings < ::Pages::Page
      attr_reader :user

      def initialize(user)
        super()
        @user = user
      end

      def path
        edit_user_path(user, tab: :reminders)
      end

      def add_time
        click_button 'Add time'
      end

      def set_time(label, time)
        select time, from: label
      end

      def deactivate_time(label)
        find("[data-qa-selector='op-settings-daily-time--active-#{label.split[1]}']").click
      end

      def remove_time(label)
        find("[data-qa-selector='op-settings-daily-time--remove-#{label.split[1]}']").click
      end

      def expect_active_daily_times(*times)
        times.each_with_index do |time, index|
          expect(page)
            .to have_css("input[data-qa-selector='op-settings-daily-time--active-#{index + 1}']:checked")

          expect(page)
            .to have_field("Time #{index + 1}", text: time)
        end
      end

      def expect_immediate_reminder(name, enabled)
        if enabled
          expect(page).to have_selector("input[data-qa-immediate-reminder='#{name}']:checked")
        else
          expect(page).to have_selector("input[data-qa-immediate-reminder='#{name}']:not(:checked)")
        end
      end

      def set_immediate_reminder(name, enabled)
        field = page.find("input[data-qa-immediate-reminder='#{name}']")

        if enabled
          field.check
        else
          field.uncheck
        end
      end

      def expect_workdays(days)
        days.each do |name|
          expect(page).to have_checked_field(name)
        end
      end

      def expect_non_workdays(days)
        days.each do |name|
          expect(page).to have_unchecked_field(name)
        end
      end

      def set_workdays(days)
        days.each do |name, enabled|
          if enabled
            page.check name
          else
            page.uncheck name
          end
        end
      end

      def expect_paused(paused, first: nil, last: nil)
        if paused
          expect(page).to have_checked_field 'Temporarily pause daily email reminders'
        else
          expect(page).to have_no_checked_field 'Temporarily pause daily email reminders'
        end

        if first && last
          expect(page).to have_selector('.flatpickr-input') do |node|
            expect(node.value).to eq "#{first.iso8601} - #{last.iso8601}"
          end
        end
      end

      def set_paused(paused, first: nil, last: nil)
        if paused
          check 'Temporarily pause daily email reminders'
          page.find('.flatpickr-input').click
          page.find('.flatpickr-day:not(.nextMonthDay)', text: first.day, exact_text: true).click
          page.find('.flatpickr-day:not(.nextMonthDay)', text: last.day, exact_text: true).click

          expect(page).to have_selector('.flatpickr-input') do |node|
            expect(node.value).to eq "#{first.iso8601} - #{last.iso8601}"
          end
        else
          uncheck 'Temporarily pause daily email reminders'
        end
      end

      def save
        click_button I18n.t(:button_save)
      end
    end
  end
end
