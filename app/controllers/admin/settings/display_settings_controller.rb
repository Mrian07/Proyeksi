#-- encoding: UTF-8



module Admin::Settings
  class DisplaySettingsController < ::Admin::SettingsController
    menu_item :settings_display

    before_action :validate_start_of_week_year, only: :update

    def show
      @options = {}
      @options[:user_format] = User::USER_FORMATS_STRUCTURE.keys.map { |f| [User.current.name(f), f.to_s] }

      respond_to :html
    end

    def default_breadcrumb
      t(:label_display)
    end

    private

    def validate_start_of_week_year
      start_of_week = params[:settings][:start_of_week]
      start_of_year = params[:settings][:first_week_of_year]

      if start_of_week.present? ^ start_of_year.present?
        flash[:error] = I18n.t(
          'settings.display.first_date_of_week_and_year_set',
          first_week_setting_name: I18n.t(:setting_first_week_of_year),
          day_of_week_setting_name: I18n.t(:setting_start_of_week)
        )
        redirect_to action: :show
      end
    end
  end
end
