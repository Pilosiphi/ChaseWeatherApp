import Foundation
import CoreLocation

//Core Location singleton to simplify requesting access from user and retriving location.
//Found base from Google search, modified by adding functions for ease of use. 
class LocationManager: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?

    public func requestLocationAuthorization() {
        self.locationManager.delegate = self
        let currentStatus = locationManager.authorizationStatus

        // Only ask authorization if it was never asked before
        guard currentStatus == .notDetermined else { return }

        // Starting on iOS 13.4.0, to get .authorizedAlways permission, you need to
        // first ask for WhenInUse permission, then ask for Always permission to
        // get to a second system alert
        if #available(iOS 13.4, *) {
            self.requestLocationAuthorizationCallback = { status in
                if status == .authorizedWhenInUse {
                    self.locationManager.requestAlwaysAuthorization()
                }
            }
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    public func isLocationRequestUndetermined() -> Bool {
        return locationManager.authorizationStatus == .notDetermined
    }
    
    public func isLocationAccessible() -> Bool {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            return true
        }
        return false
    }
    
    public func retrieveLocationAuthorization() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    public func retrieveLocation() -> (Double,Double)? {
        if isLocationAccessible() {
            guard let currentLocation = locationManager.location else { return nil }
            return (currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        }
        return nil
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationAuthorizationCallback?(status)
    }
}
