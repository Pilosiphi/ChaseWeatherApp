import Foundation

//Geolocation data model to convert data from network call/json into usable form. 
class GeoLocationDataModel: Codable {
    
    var latitude: Double
    var longitude: Double
    var city: String
    var state: String
    
    init?(withJson data: Any?) {
        guard let jsonDictionary = data as? [[String: Any]],
              let firstLocation = jsonDictionary.first else {
            return nil
        }
        
        guard let responseLat = firstLocation["lat"] as? Double,
              let responseLon = firstLocation["lon"] as? Double,
              let responseCity = firstLocation["name"] as? String,
              let responseState = firstLocation["state"] as? String else {
            return nil
        }
        latitude = responseLat
        longitude = responseLon
        city = responseCity
        state = responseState
    }
}
