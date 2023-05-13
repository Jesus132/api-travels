class TravelRepository < BaseRepository
    def find_by_user(user_id)
      model_class.where(user_id: user_id)
    end
  
    def find_by_driver(driver_id)
      model_class.where(driver_id: driver_id)
    end
  
    private
  
    def model_class
      Travel
    end
end
  