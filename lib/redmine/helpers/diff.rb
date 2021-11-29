#-- encoding: UTF-8



module Redmine
  module Helpers
    class Diff
      include ERB::Util
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::TextHelper
      attr_reader :diff, :words

      def initialize(content_to, content_from)
        @words = content_to.to_s.split(/(\s+)/)
        @words = @words.select { |word| word != ' ' }
        words_from = content_from.to_s.split(/(\s+)/)
        words_from = words_from.select { |word| word != ' ' }
        @diff = words_from.diff @words
      end

      def to_html
        words = self.words.map { |word| h(word) }
        words_add = 0
        words_del = 0
        dels = 0
        del_off = 0
        diff.diffs.each do |diff|
          add_at = nil
          add_to = nil
          del_at = nil
          deleted = ''
          diff.each do |change|
            pos = change[1]
            if change[0] == '+'
              add_at ||= pos + dels
              add_to = pos + dels
              words_add += 1
            else
              del_at ||= pos
              deleted << ' ' + h(change[2])
              words_del += 1
            end
          end
          if add_at
            words[add_at] =
              ('<label class="hidden-for-sighted">' + WorkPackage.human_attribute_name(:begin_insertion) + '</label><ins class="diffmod">').html_safe + words[add_at]
            words[add_to] =
              words[add_to] + ('</ins><label class="hidden-for-sighted">' + WorkPackage.human_attribute_name(:end_insertion) + '</label>').html_safe

          end
          if del_at
            words.insert del_at - del_off + dels + words_add, ('<label class="hidden-for-sighted">' +
                                                                WorkPackage.human_attribute_name(:begin_deletion) +
                                                                '</label><del class="diffmod">').html_safe + deleted +
                                                              ('</del><label class="hidden-for-sighted">' +
                                                              WorkPackage.human_attribute_name(:end_deletion) + '</label>').html_safe
            dels += 1
            del_off += words_del
            words_del = 0
          end
        end
        words.join(' ')
      end

      def additions
        added_changes = []
        if @diff.diffs.try(:first).try(:any?)
          @diff.diffs.first.each do |change|
            if change.first == "+"
              added_changes << change.third
            end
          end
        end
        added_changes
      end
    end
  end
end
