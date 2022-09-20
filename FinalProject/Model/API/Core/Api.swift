//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import Foundation
import Alamofire

final class Api {

    struct Path {
        static let baseURL = "https://api.foursquare.com/v2/venues/explore"
        static let detailURL = "https://api.foursquare.com/v2/venues/"
        static let searchURL = "https://api.foursquare.com/v2/venues/search"
        static let categoryURL = "https://api.foursquare.com/v2/venues/categories"
        static let similarURL = "/similar"
    }

    struct Params {
        static let clientID = "PQXVYOXN4R55FNHKV05EUIF5OR4GZU4F2ITMOGIW3ZA1CKCZ"
        static let clientSecret = "JEG0HJKBHZNL4ADKBSMRVBFDDFVZWSFCTQ2P2A3UDQXAFAIK"
        static let version = "20211118"

        static var defaultJSON: [String: Any] = {
            var json: [String: Any] = [:]
            json["client_id"] = Api.Params.clientID
            json["client_secret"] = Api.Params.clientSecret
            json["v"] = Api.Params.version
            return json
        }()
    }
}

protocol URLStringConvertible {
    var urlString: String { get }
}

protocol ApiPath: URLStringConvertible {
    static var path: String { get }
}

private func / (lhs: URLStringConvertible, rhs: URLStringConvertible) -> String {
    return lhs.urlString + "/" + rhs.urlString
}

extension String: URLStringConvertible {
    var urlString: String { return self }
}

private func / (left: String, right: Int) -> String {
    return left.appending(path: "\(right)")
}
