require 'rspec'

require_relative '../../lib/services/base_service'
require_relative '../../lib/services/rider_service'
require_relative '../../lib/services/driver_service'

require_relative '../../lib/utils/payment'
require_relative '../../lib/utils/geolocation'

require_relative '../../lib/repositories/base_repository'
require_relative '../../lib/repositories/user_repository'
require_relative '../../lib/repositories/travel_repository'
# require_relative '../../lib/services/driver_service'

describe DriverService do
  let(:travel_id) { 1 }
  let(:lat_end) { 40.7128 }
  let(:long_end) { -74.0060 }
  let(:driver_service) { DriverService.new }

  describe '#end_travel' do
    context 'when driver is valid' do
      let(:travel_repository) { double('TravelRepository') }
      let(:user_repository) { double('UserRepository') }
      let(:travel) { { travel_id: travel_id, rider_id: 1, driver_id: 2, long_start: -73.9352, lat_end: 40.7128 } }
      let(:rider) { { pay: 100, email: 'rider@gmail.com' } }
      let(:driver) { { status: 1 } }
      let(:geolocation) { double('Geolocation') }
      let(:payment) { double('Payment') }
      let(:cost) { 13500 } # Costo ficticio para el caso de prueba
      let(:updated_travel) { { lat_end: lat_end, long_end: long_end, status: 2, cost: cost } }

      before do
        allow(TravelRepository).to receive(:new).and_return(travel_repository)
        allow(UserRepository).to receive(:new).and_return(user_repository)
        allow(travel_repository).to receive(:find_by).with(travel_id).and_return(travel)
        allow(user_repository).to receive(:find_by).with(travel[:rider_id]).and_return(rider)
        allow(user_repository).to receive(:find_by).with(travel[:driver_id]).and_return(driver)
        allow(Geolocation).to receive(:new).and_return(geolocation)
        allow(Payment).to receive(:new).and_return(payment)
        allow(payment).to receive(:pay)
        allow(travel).to receive(:update)
        allow(rider).to receive(:update)
        allow(driver).to receive(:update)
        allow(geolocation).to receive(:distance_between).and_return(10) # Asumiendo una distancia de 10 km
      end

      it 'returns the cost of the travel' do
        expect(driver_service.end_travel(travel_id, lat_end, long_end)).to eq(cost)
      end

      it 'updates the travel, rider, and driver status' do
        expect(travel).to receive(:update).with(updated_travel)
        expect(rider).to receive(:update).with(status: 0)
        expect(driver).to receive(:update).with(status: 0)
        driver_service.end_travel(travel_id, lat_end, long_end)
      end

      it 'pays the rider' do
        expect(payment).to receive(:pay).with(rider[:pay], travel_id, rider[:email], updated_travel[:cost])
        driver_service.end_travel(travel_id, lat_end, long_end)
      end
    end
  end
end
