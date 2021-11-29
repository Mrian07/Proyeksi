

module Components
  module Timelines
    class TimelineRow
      include Capybara::DSL
      include RSpec::Matchers

      attr_reader :container

      def initialize(container)
        @container = container
      end

      def hover!
        @container.find('.timeline-element').hover
      end

      def expect_hovered_labels(left:, right:)
        hover!

        unless left.nil?
          expect(container).to have_selector(".labelHoverLeft.not-empty", text: left)
        end
        unless right.nil?
          expect(container).to have_selector(".labelHoverRight.not-empty", text: right)
        end

        expect(container).to have_selector(".labelLeft", visible: false)
        expect(container).to have_selector(".labelRight", visible: false)
        expect(container).to have_selector(".labelFarRight", visible: false)
      end

      def expect_labels(left:, right:, farRight:)
        {
          labelLeft: left,
          labelRight: right,
          labelFarRight: farRight
        }.each do |className, text|
          if text.nil?
            expect(container).to have_selector(".#{className}", visible: :all)
            expect(container).to have_no_selector(".#{className}.not-empty", wait: 0)
          else
            expect(container).to have_selector(".#{className}.not-empty", text: text)
          end
        end
      end
    end
  end
end
