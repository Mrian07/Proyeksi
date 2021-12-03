#-- encoding: UTF-8

module Projects::Copy
  class ForumsDependentService < Dependency
    def self.human_name
      I18n.t(:label_forum_plural)
    end

    def source_count
      source.forums.count
    end

    protected

    def copy_dependency(params:)
      source.forums.find_each do |forum|
        new_forum = Forum.new
        new_forum.attributes = forum.attributes.dup.except('id',
                                                           'project_id',
                                                           'topics_count',
                                                           'messages_count',
                                                           'last_message_id')
        copy_topics(forum, new_forum)

        new_forum.project = target
        target.forums << new_forum
      end
    end

    def copy_topics(board, new_forum)
      topics = board.topics.where('parent_id is NULL')
      topics.each do |topic|
        new_topic = Message.new
        new_topic.attributes = topic.attributes.dup.except('id',
                                                           'forum_id',
                                                           'author_id',
                                                           'replies_count',
                                                           'last_reply_id',
                                                           'created_at',
                                                           'updated_at')
        new_topic.forum = new_forum
        new_topic.author_id = topic.author_id
        new_forum.topics << new_topic
      end
    end
  end
end
