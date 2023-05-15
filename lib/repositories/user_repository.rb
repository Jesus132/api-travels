class UserRepository < BaseRepository
  def find_by(id)
    model_class.find_by(id: id)
  end

  def find_by_email(email, role)
    model_class.find_by(email: email, role: role)
  end

  def find_by_role(role, status)
    model_class.find_by(role: role, status: status)
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
  