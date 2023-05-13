class Travel < ActiveRecord::Base
    belongs_to :rider, class_name: 'User'
    belongs_to :driver, class_name: 'User', optional: true
  
    validates :rider, presence: true
    validates :lat_start, presence: true
    validates :long_start, presence: true
    validates :status, presence: true
  
    enum status: { pending: 0, in_progress: 1, finished: 2 }
  
    def finish!
      update(status: :finished)
    end
end