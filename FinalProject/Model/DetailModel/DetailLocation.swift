//
//  DetailLocation.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper
import RealmSwift
import CoreLocation

final class DetailLocation: Object, Mappable {

    var formattedAddressList = List<String>()
    var formattedAddress: [String] = []
    @objc dynamic var lat: CLLocationDegrees = 0.0
    @objc dynamic var long: CLLocationDegrees = 0.0

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        formattedAddress <- map["formattedAddress"]
        lat <- map["lat"]
        long <- map["lng"]
    }
}
