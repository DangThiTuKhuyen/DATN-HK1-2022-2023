//
//  Category.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/18/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

class Category: Mappable {

    var id: String?
    var name: String?
    var isSelected: Bool = false

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
