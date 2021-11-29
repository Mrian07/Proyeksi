#-- encoding: UTF-8



module Sessions
  class BaseService
    class << self
      protected

      ##
      # Can we work on SQL sessions?
      def active_record_sessions?
        OpenProject::Configuration.session_store.to_s == 'active_record_store'
      end
    end
  end
end
