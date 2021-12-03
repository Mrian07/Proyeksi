#-- encoding: UTF-8

class News < ApplicationRecord
  belongs_to :project
  belongs_to :author, class_name: 'User'
  has_many :comments, -> {
    order(:created_at)
  }, as: :commented, dependent: :delete_all

  validates_presence_of :title
  validates_length_of :title, maximum: 60
  validates_length_of :summary, maximum: 255

  acts_as_journalized

  acts_as_event url: Proc.new { |o| { controller: '/news', action: 'show', id: o.id } }

  acts_as_searchable columns: %W[#{table_name}.title #{table_name}.summary #{table_name}.description],
                     include: :project,
                     references: :projects,
                     date_column: "#{table_name}.created_at"

  acts_as_watchable

  after_create :add_author_as_watcher

  scope :visible, ->(*args) do
    includes(:project)
      .references(:projects)
      .merge(Project.allowed_to(args.first || User.current, :view_news))
  end

  def visible?(user = User.current)
    !user.nil? && user.allowed_to?(:view_news, project)
  end

  def description=(val)
    super val.presence || ''
  end

  # returns latest news for projects visible by user
  def self.latest(user: User.current, count: 5)
    latest_for(user, count: count)
  end

  def self.latest_for(user, count: 5)
    scope = newest_first
              .includes(:author)
              .visible(user)

    if count > 0
      scope.limit(count)
    else
      scope
    end
  end

  # table_name shouldn't be needed :(
  def self.newest_first
    order "#{table_name}.created_at DESC"
  end

  def new_comment(attributes = {})
    comments.build(attributes)
  end

  def post_comment!(attributes = {})
    new_comment(attributes).post!
  end

  def to_param
    id && "#{id} #{title}".parameterize
  end

  private

  def add_author_as_watcher
    Watcher.create(watchable: self, user: author)
  end
end
