import UIKit

class PrimaryWeatherViewController: BaseViewController {
    
    //MARK: Interface outlet properties
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var highLowTemperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    
    //MARK: Data properties
    var weatherDataReference: WeatherDataModel?
    var geoDataReference: GeoLocationDataModel?
    
    //MARK: View Controller override functions.
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.requestLocationAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //If user hasn't determined location access, present the settings view controller.
        if LocationManager.sharedInstance.isLocationRequestUndetermined() {
            transitionToSettingsViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineSearchPath()
    }
    
    //MARK: Weather data related methods.
    //Logic to determine flow for performing weather data request.
    //Determines (with help of singleton) if location data or manually entered values should be used.
    func determineSearchPath() {
        
        if LocationManager.sharedInstance.isLocationRequestUndetermined() {
            //Don't attempt to perform a search without the user having made a decision on Location Services.
            return
        }
        
        switch SearchInputSingleton.sharedInstance.searchType {
        
        case .byCityState:
            //Perform search using city state request:
            guard let searchValues = SearchInputSingleton.sharedInstance.searchString else {
                let error = BaseError(errorTitle: "Error", errorMessage: "Any issue occurred while attempting to search. Please try again.")
                displayAlertErrorMessage(with: error)
                return
            }
            
            SearchInputSingleton.sharedInstance.clearSearchValues()
            executeRequest(withCity: searchValues.0, andState: searchValues.1)
            
        case .byGeoCoordinates:
            //Perform search using geo location request:
            guard let currentLocation = LocationManager.sharedInstance.retrieveLocation() else {
                let error = BaseError(errorTitle: "Error", errorMessage: "Any issue occurred while attempting to search. Please try again.")
                displayAlertErrorMessage(with: error)
                return
            }
            
            SearchInputSingleton.sharedInstance.clearSearchValues()
            executeRequest(withLat: String(currentLocation.0), andLon: String(currentLocation.1))
            
        case .inputCancelled:
            //Check to see if there is a previous search
            guard let searchKeyValue = UserDefaults.standard.data(forKey: Constants.UserDefaultKeys.previousSearchKey) else {
                transitionToSettingsViewController()
                return
            }
            
            //Attempt to decode previous search data, and perform search. Failure leads user to SettingsViewController.
            do {
                let geoDataModel = try JSONDecoder().decode(GeoLocationDataModel.self, from: searchKeyValue)
                executeRequest(withLat: String(geoDataModel.latitude), andLon: String(geoDataModel.longitude))
            } catch {
                transitionToSettingsViewController()
            }
            return
        }
    }

    //Update corresponding UI elements with proper values from retrieved weather data.
    func setCurrentWeatherData() {
        guard let weatherData = weatherDataReference,
              let geoData = geoDataReference else {
            //No data to set values.
            return
        }
        guard let weatherImageURL = WeatherAPI.sharedInstance.createWeatherImageRequest(with: weatherData.weatherIconName).URL else { return }
        cityStateLabel.text = "\(geoData.city), \(geoData.state)"
        weatherIconImageView.load(url: weatherImageURL, placeholder: UIImage())
        
        if let selectedUnitType = UserDefaults.standard.object(forKey: Constants.UserDefaultKeys.scientificSegmentControlKey) as? TemperatureUnit.RawValue {
            //Use stored value for unit type, otherwise default to Fahrenheit
            temperatureLabel.text = "Temperature: \(weatherData.temperature.temperatureString(temperatureType: selectedUnitType))"

            //High Low Temperature string build.
            let highTemp = "High: \(weatherData.tempMax.temperatureString(temperatureType: selectedUnitType))"
            let lowTemp  = "Low : \(weatherData.tempMin.temperatureString(temperatureType: selectedUnitType))"
            highLowTemperatureLabel.text = "\(highTemp) || \(lowTemp)"
            
            let feelsLike = "Feels like: \(weatherData.feelsLikeTemp.temperatureString(temperatureType: selectedUnitType))"
            feelsLikeTemperatureLabel.text = feelsLike
            
        } else {
            temperatureLabel.text = "Temperature: \(weatherData.temperature.temperatureString(temperatureType: TemperatureUnit.Fahrenheit.rawValue))"
            
            //High Low Temperature string build.
            let highTemp = "High: \(weatherData.tempMax.temperatureString(temperatureType: TemperatureUnit.Fahrenheit.rawValue))"
            let lowTemp  = "Low : \(weatherData.tempMin.temperatureString(temperatureType: TemperatureUnit.Fahrenheit.rawValue))"
            highLowTemperatureLabel.text = "\(highTemp) || \(lowTemp)"
            
            let feelsLike = "Feels like: \(weatherData.feelsLikeTemp.temperatureString(temperatureType: TemperatureUnit.Fahrenheit.rawValue))"
            feelsLikeTemperatureLabel.text = feelsLike
        }
    }
    
    
    
    //MARK: UI Actions/Transition.
    @IBAction func settingsButtonTapped(_ sender: Any) {
        transitionToSettingsViewController()
    }
    
    func transitionToSettingsViewController() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            let storyboard = UIStoryboard.init(name: Constants.StoryboardIdentifiers.storyboardIdentifier, bundle: nil)
            guard let settingsViewController = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.settingsViewControllerIdentifier) as? SettingsViewController else { return }
            settingsViewController.modalPresentationStyle = .fullScreen
            weakSelf.present(settingsViewController, animated: true)
        }
    }
    
    
    //MARK: Network calls
    //Execute Search request using City/State input.
    func executeRequest(withCity city: String, andState state: String) {

        let geoRequest = WeatherAPI.sharedInstance.createGeoLocationRequest(withCity: city, andState: state)
        Task {
            do {
                let geoData = try await WeatherAPI.sharedInstance.geoRequestData(with: geoRequest)
                let weatherRequest = WeatherAPI.sharedInstance.createWeatherRequest(with: "\(geoData.latitude)", lon: "\(geoData.longitude)")
                weatherDataReference = try await WeatherAPI.sharedInstance.weatherRequestData(with: weatherRequest)
                geoDataReference = geoData
                let data = try JSONEncoder().encode(geoData)
                
                //Store previous search key into UserDefaults
                UserDefaults.standard.set(data, forKey: Constants.UserDefaultKeys.previousSearchKey)
                UserDefaults.standard.synchronize()
                
                //Perform UI update on main thread.
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.setCurrentWeatherData()
                }
                
            } catch let error as BaseError {
                //Handles any errors during attempt to retrieve data via network call.
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.displayAlertErrorMessage(with: error)
                }
                
            } catch {
                //Handle any error related to encode/decode.
                let error = BaseError(errorTitle: "Data Error", errorMessage: "Failed to save previous search data. Please perform a new search.")
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.displayAlertErrorMessage(with: error)
                }
            }
        }
    }
    
    //Execute Search request using Lat/Long input.
    func executeRequest(withLat lat: String, andLon lon: String) {
        
        let geoRequest = WeatherAPI.sharedInstance.createReverseGeoLocationRequest(withLat: lat, andLon: lon)
        
        Task {
            do {
                let geoData = try await WeatherAPI.sharedInstance.geoRequestData(with: geoRequest)
                let weatherRequest = WeatherAPI.sharedInstance.createWeatherRequest(with: "\(geoData.latitude)", lon: "\(geoData.longitude)")
                weatherDataReference = try await WeatherAPI.sharedInstance.weatherRequestData(with: weatherRequest)
                geoDataReference = geoData
                let data = try JSONEncoder().encode(geoData)
                UserDefaults.standard.set(data, forKey: Constants.UserDefaultKeys.previousSearchKey)
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.setCurrentWeatherData()
                }
            } catch let error as BaseError {
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.displayAlertErrorMessage(with: error)
                }
            } catch {
                let error = BaseError(errorTitle: "Data Error", errorMessage: "Failed to save previous search data. Please perform a new search.")
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.displayAlertErrorMessage(with: error)
                }
            }
        }

    }
}

//MARK: Device trait used for debugging size classes.
enum DeviceTraitStatus {
    ///IPAD and others: Width: Regular, Height: Regular
    case wRhR
    ///Any IPHONE Portrait Width: Compact, Height: Regular
    case wChR
    ///IPHONE Plus/Max Landscape Width: Regular, Height: Compact
    case wRhC
    ///IPHONE landscape Width: Compact, Height: Compact
    case wChC

    static var current:DeviceTraitStatus{

        switch (UIScreen.main.traitCollection.horizontalSizeClass, UIScreen.main.traitCollection.verticalSizeClass){

        case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular):
            print("wR hR")
            return .wRhR
        case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.regular):
            print("wC hR")
            return .wChR
        case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.compact):
            print("wR hC")
            return .wRhC
        case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.compact):
            print("wC hC")
            return .wChC
        default:
            print("wC hR")
            return .wChR

        }

    }

}
