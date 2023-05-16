require 'json'
require 'rspec'
require 'rack/test'
require 'sinatra/base'

require_relative '../../lib/controllers/base_controller'
require_relative '../../lib/controllers/drivers_controller'

require_relative '../../lib/services/base_service'
require_relative '../../lib/services/rider_service'
require_relative '../../lib/services/driver_service'
require_relative '../../lib/services/user_service'

require_relative '../../lib/utils/payment'
require_relative '../../lib/utils/geolocation'

require_relative '../../lib/repositories/base_repository'
require_relative '../../lib/repositories/user_repository'
require_relative '../../lib/repositories/travel_repository'

describe DriversController do
  include Rack::Test::Methods

  def app
    DriversController.new
  end

  let(:user_service) { instance_double(UserService) }
  let(:driver_service) { instance_double(DriverService) }

  describe 'POST /driver' do
    let(:name) { 'John Doe' }
    let(:email) { 'john@example.com' }
    let(:rider) { { id: 1, name: name, email: email, role: 1 } }
    let(:request_body) { { 'name' => name, 'email' => email } }

    before do
      allow(UserService).to receive(:new).and_return(user_service)
      allow(user_service).to receive(:create_user).with(name, email, 1).and_return(rider)
    end

    it 'creates a new rider using UserService' do
      expect(user_service).to receive(:create_user).with(name, email, 1).and_return(rider)
      post '/driver', request_body.to_json
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq(rider)
    end
  end

  describe 'PATCH /travels/:id' do
    let(:travel_id) { '123' }
    let(:lat) { 37.7749 }
    let(:long) { -122.4194 }
    let(:cost) { 5000 }

    let(:request_body) { { 'lat' => lat, 'long' => long } }

    before do
      allow(DriverService).to receive(:new).and_return(driver_service)
      allow(driver_service).to receive(:end_travel).with(travel_id, lat, long).and_return(cost)
    end

    it 'ends the travel using DriverService' do
      expect(driver_service).to receive(:end_travel).with(travel_id, lat, long).and_return(cost)
      patch "/travels/#{travel_id}", request_body.to_json
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({ 'cost' => cost })
    end
  end
end
