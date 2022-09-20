//
//  HomeService.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Alamofire
import ObjectMapper

class HomeService {

    struct Param {
        var ll: String?
        var limit: Int
        var near: String?
        var radius: Int?
        var openNow: Bool?
        var offset: Int?
        var query: String?

        init(ll: String? = nil,
             limit: Int,
             near: String? = nil,
             radius: Int? = nil,
             openNow: Bool? = nil,
             offset: Int? = nil,
             query: String) {
            self.ll = ll
            self.limit = limit
            self.near = near
            self.radius = radius
            self.openNow = openNow
            self.offset = offset
            self.query = query
        }

        func toJSON() -> [String: Any] {
            var json: [String: Any] = Api.Params.defaultJSON
            if let ll = ll {
                json["ll"] = ll
            }

            if let radius = radius {
                json["radius"] = radius
            }

            if let near = near {
                json["near"] = near
            }

            if let openNow = openNow {
                json["openNow"] = openNow
            }

            if let offset = offset {
                json["offset"] = offset
            }

            json["limit"] = limit
            json["query"] = query
            return json
        }
    }

    // MARK: - Public func
    static func getVenues(params: Param, completion: @escaping Completion<[Venue]>) {
        let urlString = Api.Path.baseURL
        api.request(method: .get, urlString: urlString, parameters: params.toJSON()) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSObject,
                   let response = data["response"] as? JSObject,
                   let groups = response["groups"] as? JSArray {
                    var recommendVenue: [Venue] = []
                    guard let items = groups.first?["items"] as? JSArray else {
                        completion(.failure(Api.Error.json))
                        return
                    }
                    recommendVenue = Mapper<Venue>().mapArray(JSONArray: items)
                    completion(.success(recommendVenue))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
