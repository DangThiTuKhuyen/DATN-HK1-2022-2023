//
//  SimilarVenue.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

final class SimilarVenue: Mappable {

    var address: DetailLocation?
    var id: String = ""
    var name: String = ""
    var image: String = ""

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        address <- map["location"]
    }
}
