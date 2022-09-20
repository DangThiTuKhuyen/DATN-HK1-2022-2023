//
//  SearchService.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/17/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Alamofire
import ObjectMapper

class SearchService {

    struct Param {

        var query: String
        var ll: String
        var categoryId: String

        init(query: String, ll: String, categoryId: String) {
            self.query = query
            self.ll = ll
            self.categoryId = categoryId
        }

        func toJSON() -> [String: Any] {
            var json: [String: Any] = Api.Params.defaultJSON
            json["ll"] = ll
            json["query"] = query
            json["categoryId"] = categoryId
            return json
        }
    }

    // MARK: - Properties
    static var shareInstance: SearchService = {
        let shareSearchService = SearchService()
        return shareSearchService
    }()

    // MARK: - Private init()
    private init() { }

    // MARK: - Class func
    class func shared() -> SearchService {
        return shareInstance
    }

    // MARK: - Public func
    func getVenues(params: Param, completion: @escaping Completion<[SearchVenue]>) {
        let urlString = Api.Path.searchURL
        api.request(method: .get, urlString: urlString, parameters: params.toJSON()) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSObject,
                   let response = data["response"] as? JSObject,
                   let venues = response["venues"] as? JSArray {
                    var searchVenues: [SearchVenue] = []
                    searchVenues = Mapper<SearchVenue>().mapArray(JSONArray: venues)
                    completion(.success(searchVenues))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCategories(completion: @escaping Completion<[Category]>) {
        let urlString = Api.Path.categoryURL
        api.request(method: .get, urlString: urlString, parameters: Api.Params.defaultJSON) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSObject,
                   let response = data["response"] as? JSObject,
                   let category = response["categories"] as? JSArray {
                    var categories: [Category] = []
                    categories = Mapper<Category>().mapArray(JSONArray: category)
                    completion(.success(categories))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
