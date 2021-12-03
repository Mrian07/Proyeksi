#-- encoding: UTF-8

##
# Password hashing method using bcrypt
class UserPassword::Bcrypt < UserPassword
  protected

  ##
  # Determines whether the hashed value of +plain+ matches the stored password hash.
  def hash_matches?(plain)
    BCrypt::Password.new(hashed_password) == plain
  end

  def derive_password!(input)
    BCrypt::Password.create(input)
  end
end
