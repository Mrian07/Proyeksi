#-- encoding: UTF-8



require 'api/decorators/single'

module API
  module V3
    module Configuration
      class ConfigurationRepresenter < ::API::Decorators::Single
        link :self do
          {
            href: api_v3_paths.configuration
          }
        end

        link :userPreferences do
          {
            href: api_v3_paths.user_preferences(current_user.id)
          }
        end

        link :prepareAttachment do
          next unless OpenProject::Configuration.direct_uploads?

          {
            href: api_v3_paths.prepare_new_attachment_upload,
            method: :post
          }
        end

        property :maximum_attachment_file_size,
                 getter: ->(*) { attachment_max_size.to_i.kilobyte }

        property :per_page_options,
                 getter: ->(*) { per_page_options_array }

        property :date_format,
                 exec_context: :decorator,
                 render_nil: true

        property :time_format,
                 exec_context: :decorator,
                 render_nil: true

        property :start_of_week,
                 getter: ->(*) {
                   Setting.start_of_week.to_i unless Setting.start_of_week.blank?
                 },
                 render_nil: true

        property :user_preferences,
                 embedded: true,
                 exec_context: :decorator,
                 if: ->(*) {
                   embed_links
                 }

        def _type
          'Configuration'
        end

        def user_preferences
          UserPreferences::UserPreferenceRepresenter.new(current_user.pref,
                                                         current_user: current_user)
        end

        def date_format
          reformated(Setting.date_format) do |directive|
            case directive
            when '%Y'
              'YYYY'
            when '%y'
              'YY'
            when '%m'
              'MM'
            when '%B'
              'MMMM'
            when '%b', '%h'
              'MMM'
            when '%d'
              'DD'
            when '%e'
              'D'
            when '%j'
              'DDDD'
            end
          end
        end

        def time_format
          reformated(Setting.time_format) do |directive|
            case directive
            when '%H'
              'HH'
            when '%k'
              'H'
            when '%I'
              'hh'
            when '%l'
              'h'
            when '%P'
              'A'
            when '%p'
              'a'
            when '%M'
              'mm'
            end
          end
        end

        def reformated(setting, &block)
          format = setting.gsub(/%\w/, &block)

          format.blank? ? nil : format
        end
      end
    end
  end
end
