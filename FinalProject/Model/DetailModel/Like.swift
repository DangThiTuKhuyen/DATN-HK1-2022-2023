//
//  Like.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Like: Object, Mappable {

    @objc dynamic var summary: String = ""

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        summary <- map["summary"]
    }
}
