import Foundation
import React
import CoreLocation

@objc(LocationModule)
class LocationModule: RCTEventEmitter, CLLocationManagerDelegate {
  var count = 0
  var locationManager: CLLocationManager?
  
  override init() {
    super.init()
    
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.requestAlwaysAuthorization()
    locationManager?.allowsBackgroundLocationUpdates = true
    locationManager?.pausesLocationUpdatesAutomatically = false
    
    locationManager?.startMonitoringSignificantLocationChanges()
    locationManager?.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      print("print ltd=\(location.coordinate.latitude), lng=\(location.coordinate.longitude)")
      
      sendEvent(withName: "onIncrement",
                  body: ["ltd": location.coordinate.latitude,
                         "lng": location.coordinate.longitude])
      }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways {
      sendEvent(withName: "onLocationAuthorization", body: ["status": "Authorized Always"])
    } else {
      locationManager?.requestAlwaysAuthorization()
      sendEvent(withName: "onLocationAuthorization", body: ["status": "Denied"])
    }
  }
  
  @objc
  func askAlwaysAuthorization() -> () -> () {
    return locationManager?.requestAlwaysAuthorization ?? {}
  }
  
  override func supportedEvents() -> [String]! {
    return ["onIncrement", "onLocationAuthorization"]
  }
  
  override func constantsToExport() -> [AnyHashable : Any]! {
    return["Module": "LocationModule"]
  }
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }