#-- encoding: UTF-8

module Projects::Copy
  class Dependency < ::Copy::Dependency
    delegate :should_copy?, to: :class

    ##
    # Allow to count the source dependency count
    # if applicable
    def source_count
      nil
    end

    ##
    # Check whether this dependency should be copied
    # as it was selected
    def self.should_copy?(params, check)
      return true unless params[:only].present?

      params[:only].any? { |key| key.to_sym == check }
    end
  end
end
