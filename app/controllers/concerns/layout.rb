#-- encoding: UTF-8



module Layout
  extend ActiveSupport::Concern

  included do
    def layout_non_or_no_menu
      if request.xhr?
        false
      elsif @project
        true
      else
        'no_menu'
      end
    end

    def project_or_wp_query_menu
      if @project
        :project_menu
      else
        :wp_query_menu
      end
    end
  end
end
