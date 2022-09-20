//
//  PhotoItem.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class PhotoItem: Object, Mappable {

    @objc dynamic var prefix: String = ""
    @objc dynamic var suffix: String = ""
    @objc dynamic var urlImage: String = ""

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        prefix <- map["prefix"]
        suffix <- map["suffix"]
        urlImage = prefix + Config.sizeOfImage + suffix
    }
}

// MARK: - Config
extension PhotoItem {

    struct Config {
        static let sizeOfImage: String = "400x400"
    }
}
