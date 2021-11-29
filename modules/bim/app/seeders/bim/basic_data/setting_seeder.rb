#-- encoding: UTF-8


module Bim
  module BasicData
    class SettingSeeder < ::BasicData::SettingSeeder
      def data
        super.tap do |original_data|
          unless original_data['default_projects_modules'].include? 'bim'
            original_data['default_projects_modules'] << 'bim'
          end

          original_data['attachment_max_size'] = 512 * 1024 # 512MB
        end
      end
    end
  end
end
