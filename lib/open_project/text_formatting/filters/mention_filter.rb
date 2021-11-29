#-- encoding: UTF-8



module OpenProject::TextFormatting
  module Filters
    class MentionFilter < HTML::Pipeline::Filter
      include ERB::Util
      include ActionView::Helpers::UrlHelper
      include OpenProject::ObjectLinking
      include OpenProject::StaticRouting::UrlHelpers

      def call
        doc.search('mention').each do |mention|
          anchor = mention_anchor(mention)
          mention.replace(anchor) if anchor
        end

        doc
      end

      private

      def mention_anchor(mention)
        mention_instance = class_from_mention(mention)

        case mention_instance
        when Group
          group_mention(mention_instance)
        when User
          user_mention(mention_instance)
        when WorkPackage
          work_package_mention(mention_instance)
        else
          mention_instance
        end
      end

      def user_mention(user)
        link_to_user(user,
                     only_path: context[:only_path],
                     class: 'user-mention')
      end

      def group_mention(group)
        link_to_group(group,
                      only_path: context[:only_path],
                      class: 'user-mention')
      end

      def work_package_mention(work_package)
        link_to("##{work_package.id}",
                work_package_path_or_url(id: work_package.id, only_path: context[:only_path]),
                class: 'issue work_package preview-trigger')
      end

      def class_from_mention(mention)
        mention_class = case mention.attributes['data-type'].value
                        when 'user'
                          User
                        when 'group'
                          Group
                        when 'work_package'
                          WorkPackage
                        else
                          raise ArgumentError
                        end

        mention_class.find_by(id: mention_id(mention)) || mention.text
      end

      # For link_to
      def controller; end

      def mention_id(mention)
        attribute_value = mention.attributes['data-id']&.value

        id_match = attribute_value&.match(/\d+/)

        id_match ? id_match[0] : nil
      end
    end
  end
end
