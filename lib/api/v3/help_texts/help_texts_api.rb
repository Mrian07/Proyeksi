

require_dependency 'api/v3/help_texts/help_text_representer'
require_dependency 'api/v3/help_texts/help_text_collection_representer'

module API
  module V3
    module HelpTexts
      class HelpTextsAPI < ::API::OpenProjectAPI
        resources :help_texts do
          get do
            @entries = AttributeHelpText.visible(current_user)
            HelpTextCollectionRepresenter.new(@entries, self_link: api_v3_paths.help_texts, current_user: current_user)
          end

          route_param :id, type: Integer, desc: 'Help text ID' do
            after_validation do
              @help_text = AttributeHelpText.visible(current_user).find(params[:id])
            end

            get do
              HelpTextRepresenter.new(@help_text, current_user: current_user)
            end

            mount ::API::V3::Attachments::AttachmentsByHelpTextAPI
          end
        end
      end
    end
  end
end
