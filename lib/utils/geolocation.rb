class Geolocation
    EARTH_RADIUS = 6371 # Radio de la Tierra en kilómetros
  
    def distance_between(start_lat, start_long, end_lat, end_long)
      # Cálculo de la distancia entre dos puntos geográficos
      # utilizando la fórmula del haversine
  
      delta_lat = (end_lat - start_lat).to_radians
      delta_long = (end_long - start_long).to_radians
  
      start_lat = start_lat.to_radians
      end_lat = end_lat.to_radians
  
      a = Math.sin(delta_lat / 2)**2 + Math.cos(start_lat) * Math.cos(end_lat) * Math.sin(delta_long / 2)**2
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  
      EARTH_RADIUS * c # Distancia en kilómetros
    end
  end
  
  class Float
    def to_radians
      self * Math::PI / 180
    end
end