module WikiPages
  class CopyContract < CreateContract
    # Disable check for edit_wiki_pages permission
    def validate_user_edit_allowed; end

    # Disable check for protect_wiki_pages permission
    def validate_user_protect_permission; end
  end
end
