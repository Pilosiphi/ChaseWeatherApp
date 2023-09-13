import Foundation

struct GeoLocationRequest: WeatherAPIProtocol {
    var city: String?
    var state: String?
    var URL: Foundation.URL? {
        get {
            guard let city = city, let state = state else {
                return nil
            }
            let apikey = Constants.OpenWeatherKeys.APIKEY
            let locationString = "\(city),\(state),US"
            
            //http://api.openweathermap.org/geo/1.0/direct?q=Chicago,IL,US&limit=5&appid=d2bbe6f03b030bf85baebbd7e270fba0
            //http://api.openweathermap.org/geo/1.0/direct?q=London&limit=5&appid={API key}
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.openweathermap.org"
            urlComponents.path = "/geo/1.0/direct"
            urlComponents.queryItems = [
                URLQueryItem(name: "q", value: locationString),
                URLQueryItem(name: "appid", value: apikey)
            ]
            return urlComponents.url
        }
    }
    
    init(city: String, state: String) {
        self.city = city
        self.state = state
    }
}
