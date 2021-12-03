module Design
  class UpdateDesignService
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      CustomStyle.transaction do
        set_logo
        set_colors
        set_theme

        custom_style.save!

        ServiceResult.new success: true, result: custom_style
      end
    rescue StandardError => e
      ServiceResult.new success: false, message: e.message
    end

    private

    def set_logo
      custom_style.theme_logo = params[:logo].presence
    end

    def set_colors
      return unless params[:colors]

      # reset all colors if a new theme is set
      if params[:theme].present?
        DesignColor.delete_all
      end

      params[:colors].each do |param_variable, param_hexcode|
        if design_color = DesignColor.find_by(variable: param_variable)
          if param_hexcode.blank?
            design_color.destroy
          elsif design_color.hexcode != param_hexcode
            design_color.hexcode = param_hexcode
            design_color.save
          end
        else
          # create that design_color
          design_color = DesignColor.new variable: param_variable, hexcode: param_hexcode
          design_color.save
        end
      end
    end

    def set_theme
      custom_style.theme = params[:theme].presence
    end

    def custom_style
      @custom_style ||= (CustomStyle.current || CustomStyle.create!)
    end
  end
end
