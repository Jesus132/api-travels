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

describe RiderService do
    let(:email) { 'rider@gmail.com' }
    let(:lat) { 40.7128 }
    let(:long) { -74.0060 }
    let(:rider_service) { RiderService.new }
    let(:user_repository) { double('UserRepository') }
    let(:travel_repository) { double('TravelRepository') }
    let(:rider) { { id: 1, name: 'John Doe', email: email, pay: 'payment_sources', status: 0 } }
    let(:driver) { { id: 2, name: 'Jane Smith', role: 'driver', status: 'pending' } }
    let(:travel) { double('Travel', save: true, errors: double('Errors', full_messages: [])) }
  
    before do
      allow(UserRepository).to receive(:new).and_return(user_repository)
      allow(TravelRepository).to receive(:new).and_return(travel_repository)
      allow(user_repository).to receive(:find_by_email).with(email, 'rider').and_return(rider)
      allow(user_repository).to receive(:find_by_role).with('driver', 'pending').and_return(driver)
      allow(travel_repository).to receive(:create_travels).and_return(travel)
      allow(rider).to receive(:update)
      allow(driver).to receive(:update)
    end
  
    describe '#create_payment_method' do
      context 'when rider is valid' do
        it 'calls find_by_email on user repository with correct parameters' do
          expect(user_repository).to receive(:find_by_email).with(email, 'rider').and_return(rider)
          rider_service.create_payment_method(email)
        end
  
        it 'calls token_cards on Payment with correct parameters' do
          expect_any_instance_of(Payment).to receive(:token_cards).with(rider[:name], email)
          rider_service.create_payment_method(email)
        end
  
        it 'calls update on rider with correct parameters' do
          expect(rider).to receive(:update).with(pay: rider[:pay])
          rider_service.create_payment_method(email)
        end
  
        it 'returns the correct response' do
          expect(rider_service.create_payment_method(email)).to eq({ "status": "CREATED" })
        end
      end
  
      context 'when rider is invalid' do
        before do
          allow(rider).to receive(:present?).and_return(false)
        end
  
        it 'adds an error' do
          expect(rider_service).to receive(:add_error).with('Invalid rider')
          rider_service.create_payment_method(email)
        end
  
        it 'returns nil' do
          expect(rider_service.create_payment_method(email)).to be_nil
        end
      end
    end
  
    describe '#create_travel' do
      context 'when rider and payment sources are valid' do
        before do
          allow(rider).to receive(:present?).and_return(true)
          allow(rider).to receive(:[]).with(:pay).and_return('payment_sources')
        end
  
        it 'calls find_by_email on user repository with correct parameters' do
          expect(user_repository).to receive(:find_by_email).with(email, 'rider')
          rider_service.create_travel(email, lat, long)
        end
  
        it 'calls find_by_role on user repository with correct parameters' do
          expect(user_repository).to receive(:find_by_role).with('driver', 'pending')
          rider_service.create_travel(email, lat, long)
        end

        it 'calls create_travels on travel repository with correct parameters' do
            expect(travel_repository).to receive(:create_travels).with({ rider_id: rider[:id], driver_id: driver[:id], lat_start: lat, long_start: long, cost: 0, status: 1 })
            rider_service.create_travel(email, lat, long)
          end
        
          it 'calls update on rider with correct parameters' do
            expect(rider).to receive(:update).with(status: 1)
            rider_service.create_travel(email, lat, long)
          end
        
          it 'calls update on driver with correct parameters' do
            expect(driver).to receive(:update).with(status: 1)
            rider_service.create_travel(email, lat, long)
          end
        
          it 'returns the created travel' do
            expect(rider_service.create_travel(email, lat, long)).to eq(travel)
          end
        end
        
        context 'when rider is invalid' do
          before do
            allow(rider).to receive(:present?).and_return(false)
          end
        
          it 'adds an error' do
            expect(rider_service).to receive(:add_error).with('Invalid rider')
            rider_service.create_travel(email, lat, long)
          end
        
          it 'returns nil' do
            expect(rider_service.create_travel(email, lat, long)).to be_nil
          end
        end
        
        context 'when rider payment sources are invalid' do
          before do
            allow(rider).to receive(:present?).and_return(true)
            allow(rider).to receive(:[]).with(:pay).and_return(nil)
          end
        
          it 'adds an error' do
            expect(rider_service).to receive(:add_error).with('Invalid payment sources')
            rider_service.create_travel(email, lat, long)
          end
        
          it 'returns nil' do
            expect(rider_service.create_travel(email, lat, long)).to be_nil
          end
        end
        
        context 'when travel fails to save' do
          let(:error_messages) { ['Invalid travel'] }
        
          before do
            allow(travel).to receive(:save).and_return(false)
            allow(travel.errors).to receive(:full_messages).and_return(error_messages)
          end
        
          it 'adds the travel errors as an error message' do
            expect(rider_service).to receive(:add_error).with(error_messages.join(', '))
            rider_service.create_travel(email, lat, long)
          end
        
          it 'returns nil' do
            expect(rider_service.create_travel(email, lat, long)).to be_nil
          end
        end
    end
end