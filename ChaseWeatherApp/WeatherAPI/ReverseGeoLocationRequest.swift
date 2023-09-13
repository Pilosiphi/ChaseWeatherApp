import Foundation

struct ReverseGeoLocationRequest: WeatherAPIProtocol {
    var lat: String?
    var lon: String?
    var URL: Foundation.URL? {
        get {
            guard let lat = lat, let lon = lon else {
                return nil
            }
            let apikey = Constants.OpenWeatherKeys.APIKEY
            
            //http://api.openweathermap.org/geo/1.0/direct?q=Chicago,IL,US&limit=5&appid=d2bbe6f03b030bf85baebbd7e270fba0
            //http://api.openweathermap.org/geo/1.0/reverse?lat={lat}&lon={lon}&limit={limit}&appid={API key}
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.openweathermap.org"
            urlComponents.path = "/geo/1.0/reverse"
            urlComponents.queryItems = [
                URLQueryItem(name: "lat", value: lat),
                URLQueryItem(name: "lon", value: lon),
                URLQueryItem(name: "appid", value: apikey)
            ]
            return urlComponents.url
        }
    }
    
    init(lat: String, lon: String) {
        self.lat = lat
        self.lon = lon
    }
}
