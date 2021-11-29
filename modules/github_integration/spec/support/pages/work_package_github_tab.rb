

require 'rbconfig'
require 'support/pages/page'

module Pages
  class GitHubTab < Page
    attr_reader :work_package_id

    def initialize(work_package_id)
      super()
      @work_package_id = work_package_id
    end

    def path
      "/work_packages/#{work_package_id}/tabs/github"
    end

    def git_actions_menu_button
      find('.github-git-copy:not([disabled])', text: 'Git')
    end

    def git_actions_copy_branch_name_button
      find('.git-actions-menu .copy-button:not([disabled])', match: :first)
    end

    def paste_clipboard_content
      meta_key = osx? ? :command : :control
      page.send_keys(meta_key, 'v')
    end

    def expect_tab_not_present
      expect(page).not_to have_selector('.op-tab-row--link', text: 'GITHUB')
    end

    private

    def osx?
      RbConfig::CONFIG['host_os'] =~ /darwin/
    end
  end
end
