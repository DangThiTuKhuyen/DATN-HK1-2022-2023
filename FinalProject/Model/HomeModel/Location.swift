//
//  Location.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Location: Object, Mappable {

    @objc dynamic var address: String = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var long: Double = 0.0
    @objc dynamic var distance: Int = 0

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        address <- map["address"]
        lat <- map["lat"]
        long <- map["lng"]
        distance <- map["distance"]
    }
}
