require 'rspec'

require_relative '../../lib/services/base_service'
require_relative '../../lib/services/rider_service'
require_relative '../../lib/services/driver_service'
require_relative '../../lib/services/user_service'

require_relative '../../lib/utils/payment'
require_relative '../../lib/utils/geolocation'

require_relative '../../lib/repositories/base_repository'
require_relative '../../lib/repositories/user_repository'
require_relative '../../lib/repositories/travel_repository'

describe UserService do
  let(:name) { 'Pepe Rodrigoz' }
  let(:email) { 'pepe@gmail.com' }
  let(:role) { 'user' }
  let(:user_service) { UserService.new }
  let(:user_repository) { double('UserRepository') }

  describe '#create_user' do
    before do
      allow(UserRepository).to receive(:new).and_return(user_repository)
      allow(user_repository).to receive(:create_user)
    end

    it 'calls create_user on user repository with correct parameters' do
      expect(user_repository).to receive(:create_user).with({ name: name, email: email, role: role })
      user_service.create_user(name, email, role)
    end
  end
end

# 3160104201 coline rocon