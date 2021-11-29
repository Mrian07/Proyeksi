

require 'support/pages/page'

require_relative '../../../../../grids/spec/support/pages/grid'

module Pages
  module My
    class Page < ::Pages::Grid
      def path
        my_page_path
      end
    end
  end
end
