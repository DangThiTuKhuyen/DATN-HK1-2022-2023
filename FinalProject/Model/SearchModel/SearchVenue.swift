//
//  SearchVenue.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/18/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class SearchVenue: Object, Mappable {

    @objc dynamic var location: Location?
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        location <- map["location"]
        id <- map["id"]
        name <- map["name"]
    }
}
