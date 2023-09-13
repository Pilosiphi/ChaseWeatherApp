import Foundation

//Temperature struct to make storing/retrieving/text formatting simpler. 
struct Temperature: Codable {
    
    var fahrenheit: Float = 0.0
    var celsius: Float
    
    init() {
        fahrenheit = 0.0
        celsius = 0.0
    }
    
    init?(fahrenheit: Float, celsius: Float) {
        
        guard fahrenheit.isFinite || celsius.isFinite else {
            //Should have both F and C for Temperature.
            return nil
        }
        
        self.fahrenheit = fahrenheit
        self.celsius = celsius
    }

    init?(fahrenheit: Float) {
        
        guard fahrenheit.isFinite else {
            return nil
        }
        
        self.fahrenheit = fahrenheit
        self.celsius = (fahrenheit - 32.0) / 1.8
    }
    
    init?(celsius: Float) {
        
        guard celsius.isFinite else {
            return nil
        }
        
        self.celsius = celsius
        self.fahrenheit = celsius * 1.8 + 32
    }
    
    func temperatureString(temperatureType: Int) -> String {
        guard let temperature = TemperatureUnit(rawValue: temperatureType) else {
            return ""
        }
        
        switch temperature {
        case .Fahrenheit:
            return "\(Int(fahrenheit.rounded()))°"
            
        case .Celsius:
            return "\(Int(celsius.rounded()))°"
        }
    }
}
