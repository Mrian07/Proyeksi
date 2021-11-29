#-- encoding: UTF-8



class PlaceholderUser < Principal
  alias_attribute(:name, :lastname)

  validates_presence_of(:name)
  validates_uniqueness_of(:name)
  validates_length_of :name, maximum: 256

  include ::Associations::Groupable

  scopes :visible

  def to_s
    lastname
  end
end
