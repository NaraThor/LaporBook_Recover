//
//  LocationManager.swift
//  TestLaporBook
//
//  Created by Muhammad Rakha' Naufal on 03/01/24.
//

import Foundation
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate, ObservableObject {
  @Published var authorizationStatus: CLAuthorizationStatus?
  var locationManager = CLLocationManager() // Singleton
  
  override init() {
    super.init()
    locationManager.delegate = self
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedWhenInUse:  // Location services are available.
      // Insert code here of what should happen when Location services are authorized
      authorizationStatus = .authorizedWhenInUse
      locationManager.requestLocation()
      break
      
    case .restricted:  // Location services currently unavailable.
      // Insert code here of what should happen when Location services are NOT authorized
      authorizationStatus = .restricted
      break
      
    case .denied:  // Location services currently unavailable.
      // Insert code here of what should happen when Location services are NOT authorized
      authorizationStatus = .denied
      break
      
    case .notDetermined:        // Authorization not determined yet.
      authorizationStatus = .notDetermined
      manager.requestWhenInUseAuthorization()
      break
      
    default:
      break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Insert code to handle location updates
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error: \(error.localizedDescription)")
  }

}
