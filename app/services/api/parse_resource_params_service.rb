module API
  class ParseResourceParamsService
    attr_accessor :model,
                  :representer,
                  :current_user

    def initialize(user, model: nil, representer: nil)
      self.current_user = user
      self.model = model

      self.representer = if !representer && model
                           deduce_representer(model)
                         elsif representer
                           representer
                         else
                           raise 'Representer not defined'
                         end
    end

    def call(request_body)
      parsed = if request_body
                 parse_attributes(request_body)
               else
                 {}
               end

      ServiceResult.new(success: true,
                        result: parsed)
    end

    private

    def deduce_representer(_model)
      raise NotImplementedError
    end

    def parsing_representer
      representer
        .new(struct, current_user: current_user)
    end

    def parse_attributes(request_body)
      struct = parsing_representer
                 .from_hash(request_body)

      deep_to_h(struct)
    end

    def struct
      OpenStruct.new
    end

    def deep_to_h(value)
      # Does not yet factor in Arrays. There hasn't been the need to do that, yet.
      case value
      when OpenStruct, Hash
        value.to_h.transform_values do |sub_value|
          deep_to_h(sub_value)
        end
      else
        value
      end
    end
  end
end
