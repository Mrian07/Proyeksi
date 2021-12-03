#-- encoding: UTF-8

module API
  module V3
    module Activities
      module ActivityPropertyFormatters
        def formatted_notes(journal)
          ::API::Decorators::Formattable.new(journal_note(journal),
                                             object: journal,
                                             plain: false)
        end

        def formatted_details(journal)
          details = render_details(journal, no_html: true)
          html_details = render_details(journal)
          formattables = details.zip(html_details)

          formattables.map { |d| { format: 'custom', raw: d[0], html: d[1] } }
        end

        private

        def render_details(journal, no_html: false)
          journal.details.map { |d| journal.render_detail(d, no_html: no_html) }
        end

        def journal_note(journal)
          if journal.noop?
            "_#{I18n.t(:'journals.changes_retracted')}_"
          else
            journal.notes
          end
        end
      end
    end
  end
end
