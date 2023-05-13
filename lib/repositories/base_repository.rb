class BaseRepository
    def find(id)
      model_class.find_by(id: id)
    end
  
    def create(params)
      model_class.create(params)
    end
  
    def update(record, params)
      record.update(params)
    end
  
    def delete(record)
      record.destroy
    end
  
    def all
      model_class.all
    end
  
    private
  
    def model_class
      raise NotImplementedError, 'Subclass must implement this method'
    end
end
  