//
//  DetailPrice.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Price: Object, Mappable {

    @objc dynamic var tier: Int = 0
    @objc dynamic var currency: String?

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        tier <- map["tier"]
        currency <- map["currency"]
    }
}
