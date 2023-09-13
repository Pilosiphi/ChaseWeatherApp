import Foundation

//Weather data model to convert data from network call/json into usable form. 
class WeatherDataModel: Codable {
    
    var temperature: Temperature
    var feelsLikeTemp: Temperature
    var tempMin: Temperature
    var tempMax: Temperature
    var humidity: Int
    var weatherType: String
    var weatherTypeDescription: String
    var weatherIconName: String
    
    init?(withJson jsonData: Any?) {
        
        guard let jsonDictionary = jsonData as? [String: Any],
              let weatherArray = jsonDictionary["weather"] as? [[String: Any]],
              let primaryWeather = weatherArray.first,
              let mainDictionary = jsonDictionary["main"] as? [String: Any] else {
            return nil
        }
        
        guard let mainTemp = mainDictionary["temp"] as? Double,
              let mainFeelsLike = mainDictionary["feels_like"] as? Double,
              let mainTempMin = mainDictionary["temp_min"] as? Double,
              let mainTempMax = mainDictionary["temp_max"] as? Double,
              let mainHumidity = mainDictionary["humidity"] as? Int,
              let type = primaryWeather["main"] as? String,
              let typeDescription = primaryWeather["description"] as? String,
              let iconName = primaryWeather["icon"] as? String else {
            return nil
        }
        
        guard let tempStruct = Temperature(fahrenheit: Float(mainTemp)),
              let feelsLikeStruct = Temperature(fahrenheit: Float(mainFeelsLike)),
              let minTempStruct = Temperature(fahrenheit: Float(mainTempMin)),
              let maxTempStruct = Temperature(fahrenheit: Float(mainTempMax)) else {
            return nil
        }
        
        temperature = tempStruct
        feelsLikeTemp = feelsLikeStruct
        tempMin = minTempStruct
        tempMax = maxTempStruct
        humidity = mainHumidity
        weatherType = type
        weatherTypeDescription = typeDescription
        weatherIconName = iconName
    }
    
    
}
