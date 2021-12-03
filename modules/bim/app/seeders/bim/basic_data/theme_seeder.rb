#-- encoding: UTF-8


module Bim
  module BasicData
    class ThemeSeeder < Seeder
      def seed_data!
        theme = ProyeksiApp::CustomStyles::ColorThemes.themes.find do |t|
          t[:theme] == ProyeksiApp::CustomStyles::ColorThemes::BIM_THEME_NAME
        end

        ::Design::UpdateDesignService
          .new(theme)
          .call
      end

      def applicable?
        DesignColor.all.empty?
      end
    end
  end
end
