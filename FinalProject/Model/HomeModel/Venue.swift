//
//  Venues.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

final class Venue: Mappable {

    var location: Location?
    var id: String?
    var name: String?
    var image: String = ""

    required init?(map: Map) { }

    func mapping(map: Map) {
        location <- map["venue.location"]
        id <- map["venue.id"]
        name <- map["venue.name"]
        image = randomImage()
    }

    private func randomImage() -> String {
        let index = Int.random(min: 1, max: 13)
        return "coffee\(index)"
    }
}
