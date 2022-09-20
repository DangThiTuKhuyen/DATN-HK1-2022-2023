//
//  Photo.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Photo: Object, Mappable {

    var itemList = List<PhotoItem>()
    var items: [PhotoItem] = []

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        items <- map["items"]
    }
}
