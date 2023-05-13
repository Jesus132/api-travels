class UserRepository < BaseRepository
  def find_by_email(email)
    model_class.find_by(email: email)
  end

  def find_by_role(role)
    model_class.where(role: role)
  end

  def create_user(user_data)
    user = model_class.new(user_data)
    user.save
    user
  end

  private

  def model_class
    User
  end
end
  