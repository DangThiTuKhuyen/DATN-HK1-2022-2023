//
//  LocationManager.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/15/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import CoreLocation
import Contacts

typealias LocationCompletion = (CLLocation) -> Void

class LocationManager: NSObject {

    // MARK: - Properties
    private static var sharedLocationManager: LocationManager = {
        let locationManager = LocationManager()
        return locationManager
    }()
    private let locationManager = CLLocationManager()
    private(set) var currentLocation: CLLocation?
    private var currentCompletion: LocationCompletion?
    private var locationCompletion: LocationCompletion?
    private var isUpdatingLocation = false

    // MARK: - Class func
    class func shared() -> LocationManager {
        return sharedLocationManager
    }

    // MARK: - Private init
    private override init() {
        super.init()
        configLocationManager()
    }

    // MARK: - Private Methods
    func configLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }

    // MARK: - Public func
    func request() {
        let status = CLLocationManager.authorizationStatus()
        if status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled() { return }
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        locationManager.requestLocation()
    }

    func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }

    func getCurrentLocation(completion: @escaping LocationCompletion) {
        currentCompletion = completion
        locationManager.requestLocation()
    }

    func startUpdating(completion: @escaping LocationCompletion) {
        locationCompletion = completion
        isUpdatingLocation = true
        locationManager.startUpdatingLocation()
    }

    func stopUpdating() {
        locationManager.stopUpdatingLocation()
        isUpdatingLocation = false
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
            manager.requestLocation()
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
            manager.requestLocation()
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            print("parental control setting disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        default:
            print("default")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
            if let current = currentCompletion {
                current(location)
            }
            if isUpdatingLocation, let updating = locationCompletion {
                updating(location)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

extension CLPlacemark {

    var city: String? { locality }
}

extension CLLocation {

    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
