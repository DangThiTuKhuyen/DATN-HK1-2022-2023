//
//  DetailVenues.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class DetailVenue: Object, Mappable {

    @objc dynamic var name: String?
    @objc dynamic var id: String?
    @objc dynamic var location: DetailLocation?
    @objc dynamic var price: Price?
    @objc dynamic var like: Like?
    @objc dynamic var rating: Float = 0.0
    var photoList = List<Photo>()
    var photos: [Photo] = []

    convenience required init?(map: Map) {
        self.init()
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        location <- map["location"]
        price <- map["price"]
        like <- map["likes"]
        rating <- map["rating"]
        photos <- map["photos.groups"]
    }
}
