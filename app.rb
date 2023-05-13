require 'sinatra/activerecord'
require 'sinatra/base'
require 'sinatra/json'
require 'pundit'
require 'pg'

#models
require_relative 'lib/models/travel'
require_relative 'lib/models/user'
#repositories
require_relative 'lib/repositories/travel_repository'
require_relative 'lib/repositories/user_repository'
require_relative 'lib/repositories/base_repository'


class MyApp < Sinatra::Base

  # Init DB
  configure do
    set :database_file, 'config/database.yml'
  end

  before do
    content_type :json
  end

  helpers do
    def current_user
      @current_user ||= UserRepository.find_by_email(params[:email])
    end

    def authorize(policy_class)
      policy_class.new(current_user).authorize!(params)
    end
  end

  get '/' do
    json message: 'Hola Mundo'
  end


  run! if app_file == $0
end