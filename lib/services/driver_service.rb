class DriverService < BaseService
  def end_travel(travel_id, lat_end, long_end)
    travel_repository = TravelRepository.new
    user_repository = UserRepository.new

    travel = travel_repository.find_by(travel_id)
    driver = user_repository.find_by(travel[:driver_id])
    return add_error('Invalid driver') unless driver.present?
    rider = user_repository.find_by(travel[:rider_id])

    cost = 10
    travel.update( lat_end: lat_end, long_end: long_end, status: 2, amount: cost )
    rider.update(status: 0)
    driver.update(status: 0)

    cost
  end
end