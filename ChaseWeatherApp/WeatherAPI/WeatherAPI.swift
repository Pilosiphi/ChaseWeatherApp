import UIKit

class WeatherAPI: NSObject {
    static let sharedInstance = WeatherAPI()
    
    //MARK: Types of requests that can be created.
    public func createWeatherRequest(with lat:String, lon: String) -> WeatherAPIProtocol {
        return WeatherRequest(lat: lat, lon: lon)
    }
    
    public func createGeoLocationRequest(withCity city: String,andState state: String) -> WeatherAPIProtocol {
        return GeoLocationRequest(city: city, state: state)
    }
    
    public func createReverseGeoLocationRequest(withLat lat: String, andLon lon: String) -> WeatherAPIProtocol {
        return ReverseGeoLocationRequest(lat: lat, lon: lon)
    }
    
    public func createWeatherImageRequest(with imageName: String) -> WeatherAPIProtocol {
        return WeatherImageRequest(icon: imageName)
    }
    
    //MARK: Public facing Await/Async - Get Weather Data
    public func weatherRequestData(with request: WeatherAPIProtocol) async throws -> WeatherDataModel {
        let response = try await weatherData(with: request)
        guard let weatherData = WeatherDataModel(withJson: response) else { throw BaseError(errorTitle: "Data error", errorMessage: "Stuff went wrong") }
        return weatherData
    }
    
    public func geoRequestData(with request: WeatherAPIProtocol) async throws -> GeoLocationDataModel {
        let response = try await weatherData(with: request)
        guard let geoData = GeoLocationDataModel(withJson: response) else { throw BaseError(errorTitle: "Data error", errorMessage: "Stuff went wrong") }
        return geoData
    }
    
    //MARK: Private Async/Await
    private func weatherData(with currentRequest: WeatherAPIProtocol) async throws -> Any {
        guard let requestURL = currentRequest.URL else { throw BaseError(errorTitle: "Weather URL Failed", errorMessage: "Failed to read url, please try again.") }
        let request = URLRequest(url: requestURL)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let responseJsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { throw BaseError(errorTitle: "Error", errorMessage: "Try again") }
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw BaseError(errorTitle: "Network error", errorMessage: "Bad resposne, check connection and try again") }
        return responseJsonData
    }
}
