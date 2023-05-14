class DriversController < BaseController

  post '/driver' do
    # obtener los datos del jinete desde los parámetros de la solicitud
    body = JSON.parse request.body.read
    rider = UserService.new.create_user(body['name'], body['email'], 1)
    json rider
  end

  patch '/travels/:id' do
    # obtener los datos del jinete desde los parámetros de la solicitud
    body = JSON.parse request.body.read
    cost = DriverService.new.end_travel(params[:id], body['lat'], body['long'])
    { cost: cost }.to_json
  end

end