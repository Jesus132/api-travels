class User < ActiveRecord::Base
    has_many :travels
  
    enum role: { rider: 0, driver: 1 }
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :role, presence: true
end