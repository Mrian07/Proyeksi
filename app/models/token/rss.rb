#-- encoding: UTF-8



module Token
  class RSS < Base
    after_initialize do
      unless value.present?
        self.value = self.class.generate_token_value
      end
    end

    def plain_value
      value
    end
  end
end
