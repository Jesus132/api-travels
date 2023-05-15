require 'active_record'
require 'pundit'

class BaseController < Sinatra::Base
    configure do
      set :show_exceptions, :after_handler
    end
  
    error ActiveRecord::RecordNotFound do
      status 404
      { error: "Record not found" }.to_json
    end
  
    error Pundit::NotAuthorizedError do
      status 403
      { error: "You are not authorized to perform this action" }.to_json
    end
end