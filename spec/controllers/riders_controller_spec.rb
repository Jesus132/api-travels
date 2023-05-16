require 'json'
require 'rspec'
require 'rack/test'
require 'sinatra/base'

require_relative '../../lib/controllers/base_controller'
require_relative '../../lib/controllers/riders_controller'

require_relative '../../lib/services/base_service'
require_relative '../../lib/services/rider_service'
require_relative '../../lib/services/driver_service'
require_relative '../../lib/services/user_service'

require_relative '../../lib/utils/payment'
require_relative '../../lib/utils/geolocation'

require_relative '../../lib/repositories/base_repository'
require_relative '../../lib/repositories/user_repository'
require_relative '../../lib/repositories/travel_repository'

describe RidersController do
    include Rack::Test::Methods
  
    def app
      RidersController
    end

    describe 'POST /rider' do
      it 'creates a new rider' do
        # Preparar los datos de la solicitud
        name = 'John Doe'
        email = 'rider@example.com'
        rider_params = { name: name, email: email }.to_json
  
        # Hacer la solicitud POST al endpoint
        post '/rider', rider_params
  
        # Verificar la respuesta
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include(name, email)
      end
    end
  
    describe 'PATCH /rider/payment' do
      it 'creates a payment method for the rider' do
        # Preparar los datos de la solicitud
        email = 'rider@example.com'
        payment_method_params = { email: email }.to_json
  
        # Hacer la solicitud PATCH al endpoint
        patch '/rider/payment', payment_method_params
  
        # Verificar la respuesta
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include(email)
      end
    end
  
    describe 'POST /travels' do
      it 'creates a new travel' do
        # Preparar los datos de la solicitud
        email = 'rider@example.com'
        lat = 123.456
        long = 789.012
        travel_params = { email: email, lat: lat, long: long }.to_json
  
        # Hacer la solicitud POST al endpoint
        post '/travels', travel_params
  
        # Verificar la respuesta
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include(email, lat.to_s, long.to_s)
      end
    end
  end