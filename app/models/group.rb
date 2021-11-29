#-- encoding: UTF-8



class Group < Principal
  include ::Scopes::Scoped

  has_many :group_users,
           autosave: true,
           dependent: :destroy

  has_many :users,
           through: :group_users,
           before_add: :fail_add

  acts_as_customizable

  alias_attribute(:name, :lastname)
  validates_presence_of :name
  validate :uniqueness_of_name
  validates_length_of :name, maximum: 256

  # HACK: We want to have the :preference association on the Principal to allow
  # for eager loading preferences.
  # However, the preferences are currently very user specific.  We therefore
  # remove the methods added by
  #   has_one :preference
  # to avoid accidental assignment and usage of preferences on groups.
  undef_method :preference,
               :preference=,
               :build_preference,
               :create_preference,
               :create_preference!

  scopes :visible

  def to_s
    lastname
  end

  private

  def uniqueness_of_name
    groups_with_name = Group.where('lastname = ? AND id <> ?', name, id || 0).count
    if groups_with_name > 0
      errors.add :name, :taken
    end
  end

  def fail_add
    fail "Do not add users through association, use `group.add_members!` instead."
  end
end
