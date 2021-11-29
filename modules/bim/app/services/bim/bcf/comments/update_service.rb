

module Bim::Bcf
  module Comments
    class UpdateService < ::BaseServices::Update
      private

      def before_perform(params, service_result)
        journal_call = update_journal(params[:original_comment].journal, params[:comment])
        return journal_call if journal_call.failure?

        super params.slice(*::Bim::Bcf::Comment::UPDATE_ATTRIBUTES), service_result
      end

      def update_journal(journal, comment)
        ::Journals::UpdateService.new(user: user,
                                      model: journal,
                                      contract_class: ::EmptyContract)
                                 .call(notes: comment)
      end
    end
  end
end
