

module Bim::Bcf
  module Comments
    class CreateService < ::BaseServices::Create
      private

      def before_perform(params, service_result)
        journal_call = create_journal(params[:issue].work_package,
                                      params[:comment])
        return journal_call if journal_call.failure?

        input = { journal: journal_call.result }
                  .merge(params)
                  .slice(*::Bim::Bcf::Comment::CREATE_ATTRIBUTES)
        super input, service_result
      end

      def create_journal(work_package, comment)
        ::Journals::CreateService.new(work_package, user).call(notes: comment)
      end
    end
  end
end
