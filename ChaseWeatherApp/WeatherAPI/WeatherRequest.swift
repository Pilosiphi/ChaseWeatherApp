import Foundation

struct WeatherRequest: WeatherAPIProtocol {
    var lat: String?
    var lon: String?
    var URL: Foundation.URL? {
        get {
            guard let latitude = lat, let longitude = lon else {
                return nil
            }
            let apikey = Constants.OpenWeatherKeys.APIKEY
            let unitType = Constants.OpenWeatherKeys.UNITKEY
            
            //https://api.openweathermap.org/data/2.5/weather?lat=41.977226&lon=-87.836723&units=imperial&appid=d2bbe6f03b030bf85baebbd7e270fba0
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.openweathermap.org"
            urlComponents.path = "/data/2.5/weather"
            urlComponents.queryItems = [
                URLQueryItem(name: "lat", value: latitude),
                URLQueryItem(name: "lon", value: longitude),
                URLQueryItem(name: "units", value: unitType),
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
