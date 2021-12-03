#-- encoding: UTF-8



module ProyeksiApp::TextFormatting
  module Filters
    class FigureWrappedFilter < HTML::Pipeline::Filter
      include ActionView::Context
      include ActionView::Helpers::TagHelper

      def call
        doc.search('table', 'img').each do |element|
          case element.name
          when 'img', 'table'
            wrap_element(element)
          else
            # nothing
          end
        end

        doc
      end

      private

      # Wrap img elements like this
      # <figure>
      #   <div class="op-uc-figure--content">
      #     <img></img>
      #   </div>
      # <figure>
      #
      # and
      #
      # <figure>
      #   <div class="op-uc-figure--content">
      #     <table></table>
      #   </div>
      # <figure>

      # The figure and img/table element later on get css classes applied to them so it does
      # not have to happen here.
      def wrap_element(element)
        wrap_in_div(element)
        wrap_in_figure(element.parent)
      end

      def wrap_in_figure(element)
        element.wrap('<figure>') unless element.parent&.name == 'figure'
      end

      def wrap_in_div(element)
        element.wrap('<div>') unless element.parent&.name == 'div'

        div = element.parent

        div['class'] = 'op-uc-figure--content'
      end
    end
  end
end
