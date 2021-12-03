#-- encoding: UTF-8



class Comment < ApplicationRecord
  belongs_to :commented, polymorphic: true, counter_cache: true
  belongs_to :author, class_name: 'User'

  validates :commented, :author, :comments, presence: true

  after_create :send_news_comment_added_mail

  def text
    comments
  end

  def post!
    save!
  end

  private

  def send_news_comment_added_mail
    ProyeksiApp::Notifications.send(ProyeksiApp::Events::NEWS_COMMENT_CREATED,
                                    comment: self,
                                    send_notification: true)
  end
end
