#-- encoding: UTF-8



class GithubUser < ApplicationRecord
  has_many :github_pull_requests

  validates_presence_of :github_id,
                        :github_login,
                        :github_html_url,
                        :github_avatar_url
end
