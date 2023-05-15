class TravelRepository < BaseRepository
  def find_by(travel_id)
    model_class.find_by(id: travel_id)
  end

  def find_by_user(user_id)
    model_class.where(user_id: user_id)
  end

  def find_by_driver(driver_id)
    model_class.where(driver_id: driver_id)
  end

  def create_travels(travel_data)
    travel = model_class.new(travel_data)
    travel
  end

  private

  def model_class
    Travel
  end
end
