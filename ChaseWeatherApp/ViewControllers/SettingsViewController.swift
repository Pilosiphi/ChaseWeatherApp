import UIKit

class SettingsViewController: BaseViewController {
    
    //MARK: Interface outlet properties
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var statePickerView: UIPickerView!
    @IBOutlet weak var unitTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    //MARK: Data Properties
    var selectedState: String = ""
    
    //MARK: View controller overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        statePickerView.delegate = self
        statePickerView.dataSource = self
        setupSegmentControl()
    }
    
    //MARK: UI Setup methods
    func setupSegmentControl() {
        guard let selectedUnitType = UserDefaults.standard.object(forKey: Constants.UserDefaultKeys.scientificSegmentControlKey) as? TemperatureUnit.RawValue else {
            unitTypeSegmentControl.selectedSegmentIndex = TemperatureUnit.Fahrenheit.rawValue
            return
        }
        unitTypeSegmentControl.selectedSegmentIndex = TemperatureUnit(rawValue: selectedUnitType)?.rawValue ?? TemperatureUnit.Fahrenheit.rawValue
    }
    
    
    //MARK: UI interaction functions
    @IBAction func searchButtonTapped(_ sender: Any) {
        if(cityTextField.isFirstResponder) {
            cityTextField.resignFirstResponder()
        }
        guard let state = selectedState.split(separator: "-").first,
              let city = cityTextField.text  else { return } //Something better than return should be here?
        SearchInputSingleton.sharedInstance.searchString = (city, "\(state)")
        SearchInputSingleton.sharedInstance.searchType = .byCityState
        dismiss(animated: true)        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if (cityTextField.isFirstResponder) {
            cityTextField.resignFirstResponder()
        }
        
        SearchInputSingleton.sharedInstance.searchString = nil
        SearchInputSingleton.sharedInstance.searchType = .inputCancelled
        
        dismiss(animated: true)
    }
    
    @IBAction func currentLocationButtonTapped(_ sender: Any) {
        //Dismiss keyboard if textfield has focus.
        if (cityTextField.isFirstResponder) {
            cityTextField.resignFirstResponder()
        }
        
        if (LocationManager.sharedInstance.isLocationAccessible()) {
            //Location avaiable, use this for searching weather.
            SearchInputSingleton.sharedInstance.searchString = nil
            SearchInputSingleton.sharedInstance.searchType = .byGeoCoordinates
            dismiss(animated: true)
        } else {
            //Location unavailable. Alert user, and cancel the action.
            let locationError = BaseError(errorTitle: "Location Unavailable", errorMessage: "Application does not have permission to access location, please update this via Settings to use")
            displayAlertErrorMessage(with: locationError)
        }
    }
    
    
    
    @IBAction func unitTypeValueChanged(_ sender: Any) {
        switch unitTypeSegmentControl.selectedSegmentIndex {
        case TemperatureUnit.Fahrenheit.rawValue:
            UserDefaults.standard.set(TemperatureUnit.Fahrenheit.rawValue, forKey: Constants.UserDefaultKeys.scientificSegmentControlKey)
            
        case TemperatureUnit.Celsius.rawValue:
            UserDefaults.standard.set(TemperatureUnit.Celsius.rawValue, forKey: Constants.UserDefaultKeys.scientificSegmentControlKey)
            
        default:
            fatalError("Definitely should not be here.")
        }
        UserDefaults.standard.synchronize()
    }
    
}

//MARK: UIPicker Delegate/Datasource extensions into SettingsViewController
extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedState = Constants.pickerValues.usStates[row]
    }
}

extension SettingsViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.pickerValues.usStates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.pickerValues.usStates[row]
    }
    
}
