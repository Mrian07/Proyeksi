

FactoryBot.define do
  factory :bcf_comment, class: '::Bim::Bcf::Comment' do
    transient do
      author { nil }
    end

    after(:create) do |bcf_comment, evaluator|
      bcf_comment.journal = if evaluator.author == nil
                              create(:work_package_journal)
                            else
                              create(:work_package_journal, user: evaluator.author)
                            end
      bcf_comment.journal.update_attribute(:notes, 'Some BCF comment.')
      bcf_comment.journal.save
      bcf_comment.save
    end
  end
end
