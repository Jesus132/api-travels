class RidersController < BaseController

  patch '/rider/payment' do
    # obtener los datos del jinete desde los parámetros de la solicitud
    body = JSON.parse request.body.read
    rider = RiderService.new.create_payment_method(body['email'])
    rider.to_json
  end

  post '/rider' do
    # obtener los datos del jinete desde los parámetros de la solicitud
    body = JSON.parse request.body.read
    rider = UserService.new.create_user(body['name'], body['email'], 0)
    json rider
  end

  post '/travels' do
    # obtener los datos de los parámetros de la solicitud
    body = JSON.parse request.body.read
    travel = RiderService.new.create_travel(body['email'], body['lat'], body['long'])
    travel.to_json
  end
end