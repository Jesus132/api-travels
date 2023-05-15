class UserService < BaseService
  def create_user(name, email, role)
    user_repository = UserRepository.new
    user_repository.create_user({name: name, email: email, role: role})
  end
end