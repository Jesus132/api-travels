class User < ActiveRecord::Base
    has_many :travels
  
    enum role: { rider: 0, driver: 1 }
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :pay, presence: false
    validates :role, presence: true

    enum status: { pending: 0, in_progress: 1 }
end