class BaseService
    attr_reader :errors
  
    def initialize
      @errors = []
    end
  
    def valid?
      @errors.empty?
    end
  
    protected
  
    def add_error(error)
      @errors << error
    end
end