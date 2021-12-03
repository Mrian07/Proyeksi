#-- encoding: UTF-8

module API
  module Utilities
    module MetaProperty
      extend ActiveSupport::Concern

      included do
        attr_accessor :meta

        property :meta,
                 as: :_meta,
                 exec_context: :decorator,
                 getter: ->(*) { meta_representer },
                 setter: ->(fragment:, **) { represented.meta = meta_representer.from_hash(fragment) }

        singleton_class.prepend MetaPropertyConstructor
      end

      module MetaPropertyConstructor
        def create(model, **args)
          meta = args.delete(:meta)

          super(model, **args).tap do |instance|
            instance.meta = meta
          end
        end
      end

      protected

      def meta_representer
        meta_representer_class.create(meta || OpenStruct.new, current_user: current_user)
      end

      def meta_representer_class
        raise NotImplementedError
      end
    end
  end
end
