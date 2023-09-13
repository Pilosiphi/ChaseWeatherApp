import Foundation

struct WeatherImageRequest: WeatherAPIProtocol {
    var icon: String?
    var URL: Foundation.URL? {
        get {
            guard let iconString = icon else {
                return nil
            }

            //"https://openweathermap.org/img/wn/\(iconName)@2x.png"
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "openweathermap.org"
            urlComponents.path = "/img/wn/\(iconString)@2x.png"
            return urlComponents.url
        }
    }
    
    init(icon: String) {
        self.icon = icon
    }
}
