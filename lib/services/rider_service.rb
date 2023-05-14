class RiderService < BaseService
  def create_travel(email, lat, long)
    user_repository = UserRepository.new
    travel_repository = TravelRepository.new

    rider = user_repository.find_by_email(email, 'rider')
    return add_error('Invalid rider') unless rider.present?
    driver = user_repository.find_by_role('driver', 'pending')

    travel = travel_repository.create_travels({rider_id: rider[:id], driver_id: driver[:id], lat_start: lat, long_start: long, amount: 0, status: 1})
    if travel.save
      rider.update(status: 1)
      driver.update(status: 1)
      travel
    else
      add_error(travel.errors.full_messages.join(', '))
      nil
    end
  end
end