

module OpenProject::Avatars
  module Patches
    module UserPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          acts_as_attachable

          include InstanceMethods

          class << self
            def get_local_avatar(user_id)
              Attachment.find_by(container_id: user_id, container_type: 'Principal', description: 'avatar')
            end
          end
        end
      end

      module InstanceMethods
        def reload(*args)
          reset_avatar_attachment_cache!

          super
        end

        def local_avatar_attachment
          # @local_avatar_attachment can legitimately be nil which is why the
          # typical
          # inst_var ||= calculation
          # pattern does not work for caching
          return @local_avatar_attachment if @local_avatar_attachment_calculated

          @local_avatar_attachment_calculated ||= begin
            @local_avatar_attachment = attachments.find_by_description('avatar')

            true
          end

          @local_avatar_attachment
        end

        def local_avatar_attachment=(file)
          local_avatar_attachment&.destroy
          reset_avatar_attachment_cache!

          @local_avatar_attachment = Attachments::CreateService
            .new(user: User.system, contract_class: EmptyContract)
            .call(file: file, container: self, filename: file.original_filename, description: 'avatar')
            .result
          
          touch
        end

        def reset_avatar_attachment_cache!
          @local_avatar_attachment = nil
          @local_avatar_attachment_calculated = nil
        end
      end
    end
  end
end
