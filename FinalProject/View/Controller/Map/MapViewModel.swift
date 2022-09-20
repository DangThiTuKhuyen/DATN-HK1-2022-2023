//
//  MapViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/16/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import CoreLocation

final class MapViewModel {

    var latCurrent: CLLocationDegrees {
        return LocationManager.shared().currentLocation?.coordinate.latitude ?? 0.0
    }
    var longCurrent: CLLocationDegrees {
        return LocationManager.shared().currentLocation?.coordinate.longitude ?? 0.0
    }
    var venue: DetailVenue

    init(venue: DetailVenue) {
        self.venue = venue
    }

    func titleForVenue() -> String {
        if let count = venue.location?.formattedAddress.count, count >= 3 {
            guard let address = venue.location?.formattedAddress[2] else { return "" }
            return address
        }
        return ""
    }
}
