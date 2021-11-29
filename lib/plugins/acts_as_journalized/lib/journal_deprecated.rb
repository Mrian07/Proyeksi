
module JournalDeprecated
  # Shortcut from more issue-specific journals
  def attachments
    journaled.respond_to?(:attachments) ? journaled.attachments : nil
  end

  # deprecate created_on: "use #created_at"
  # deprecate journalized: "use journaled"
  # deprecate attachments: "implement it yourself"
end
