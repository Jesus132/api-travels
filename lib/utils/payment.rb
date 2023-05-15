require 'net/http'
require 'uri'

class Payment
    def token_cards(name, email)
        authorization = ENV['key_public'] || "key_public"
        request_body = {
            "number": "4242424242424242",
            "cvc": "789",
            "exp_month": "12",
            "exp_year": "29",
            "card_holder": name
        }.to_json
        body = post("#{ENV['api'] || 'api'}tokens/cards", request_body, authorization)
        sources = payment_sources(email, body['data']['id'])
        sources
    end

    def payment_sources(email, token)
        authorization = ENV['key_private'] || "key_private"
        get_acceptance_token = get("#{ENV['api'] || 'api'}merchants/#{ENV['key'] || 'key_public'}")
        acceptance_token = get_acceptance_token['data']['presigned_acceptance']['acceptance_token']
        request_body = {
            "type": "CARD",
            "token": token,
            "customer_email": email,
            "acceptance_token": acceptance_token
          }.to_json
        body = post("#{ENV['api'] || 'api'}payment_sources", request_body, authorization)
        body['data']['id']
    end

    def pay(id_payment_sources, id_travel, email, cost)
        request_body = {
            "amount_in_cents": cost,
            "currency": "COP",
            "customer_email": email,
            "reference": id_travel,
            "payment_source_id": id_payment_sources
          }.to_json
        body = post("#{ENV['api'] || 'api'}transactions", request_body)
        body
    end

    private
  
    def get(url)
        url = URI(url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(url)
        response = http.request(request)
        JSON.parse(response.read_body)
    end
  
    def post(url, request_body, authorization)
        url = URI(url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(url)
        request["authorization"] = authorization
        request["Content-Type"] = "application/json"
        request.body = request_body
        response = http.request(request)
        JSON.parse(response.read_body)
    end
end