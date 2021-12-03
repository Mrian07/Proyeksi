#-- encoding: UTF-8

module Tasks
  module Shared
    module UserFeedback
      def ask_for_confirmation(questions)
        questions.all? do |question|
          ask_confirmation_question(question)
        end
      end

      def ask_confirmation_question(question)
        puts "\n\n"
        puts question
        puts "\nDo you want to continue? [y/N]"

        STDIN.gets.chomp == 'y'
      end
    end
  end
end
