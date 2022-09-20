//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftUtils

// MARK: - Enum
enum TypeRow: Int, CaseIterable {
    case recommend = 0
    case near
    case openning

    var height: Float {
        switch self {
        case .recommend:
            return 210
        case .near:
            return 200
        case .openning:
            return 970
        }
    }
}

final class HomeViewModel {

    // MARK: - Properties
    private var recommendVenues: [Venue] = []
    private var nearVenues: [Venue] = []
    private (set) var openningVenues: [Venue] = []
    private var limit: Int = 10
    private var radius: Int = 1_000
    private(set) var isFull: Bool = false

    // MARK: - Public func
    func numberOfRowInSection() -> Int {
        return TypeRow.allCases.count
    }

    func heightForRow(at indexPath: IndexPath) -> Float? {
        guard let type = TypeRow(rawValue: indexPath.row) else {
            return 0.0
        }
        if type == .openning {
            guard openningVenues.count != 0 else { return 0 }
            let height = OpeningTableViewCell.Config.heightOfItem
            let numberRow: Int = openningVenues.count % 2 == 0 ? openningVenues.count / 2 : Int(openningVenues.count / 2) + 1
            let heightCell = Float(numberRow) * Float(height)
            let heightSpaceBetweenCells = Float(numberRow - 1) * Float(OpeningTableViewCell.Config.minimumLineSpacingForSection)
            return heightCell + heightSpaceBetweenCells + Config.heightOfTitle + Float(OpeningTableViewCell.Config.topContenInset) + Float(OpeningTableViewCell.Config.bottomContenInset)
        }
        return type.height
    }

    func viewModelForRecommend() -> RecommendTableViewViewModel {
        return RecommendTableViewViewModel(recommendVenues: recommendVenues)
    }

    func viewModelForNear() -> NearViewModel {
        return NearViewModel(nearVenues: nearVenues)
    }

    func viewModelForOpenning() -> OpenningViewModel {
        return OpenningViewModel(openningVenues: openningVenues)
    }

    func viewModelForDetail(at indexPath: IndexPath) -> DetailViewModel {
        return DetailViewModel(id: recommendVenues[indexPath.row].id ?? "")
    }

    func resetFlagLoadMore() {
        isFull = false
    }
}

// MARK: - API
extension HomeViewModel {

    func getNearVenues(completion: @escaping APICompletion) {
        guard let cordinate = LocationManager.shared().currentLocation?.coordinate else {
            completion(.failure(Errors.initFailure))
            return
        }
        let ll: String = "\(cordinate.latitude), \(cordinate.longitude)"
        let params = HomeService.Param(ll: ll, limit: limit, radius: radius, query: Config.query)
        HomeService.getVenues(params: params) { [weak self] result in
            guard let this = self else {
                completion(.failure(Errors.initFailure))
                return
            }
            switch result {
            case .success(let nearVenues):
                this.nearVenues = nearVenues
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getRecommendVenues(completion: @escaping Completion<String>) {
        guard let cordinate = LocationManager.shared().currentLocation?.coordinate else {
            completion(.failure(Errors.initFailure))
            return
        }
        let location = CLLocation(latitude: cordinate.latitude, longitude: cordinate.longitude)
        location.placemark { placemark, error in
            guard let placemark = placemark else {
                completion(.failure(Errors.initFailure))
                return
            }
            let params = HomeService.Param(limit: self.limit, near: placemark.city, query: Config.query)
            HomeService.getVenues(params: params) { [weak self] result in
                guard let this = self else {
                    completion(.failure(Api.Error.json))
                    return
                }
                switch result {
                case .success(let recommendVenues):
                    this.recommendVenues = recommendVenues
                    completion(.success(Config.title + (placemark.city ?? "")))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func getOpenningVenues(isLoadMore: Bool, completion: @escaping APICompletion) {
        guard let cordinate = LocationManager.shared().currentLocation?.coordinate else {
            completion(.failure(Errors.initFailure))
            return
        }
        let offset: Int = openningVenues.count
        let location = CLLocation(latitude: cordinate.latitude, longitude: cordinate.longitude)
        location.placemark { placemark, error in
            guard let placemark = placemark else {
                completion(.failure(Errors.initFailure))
                return
            }
            let params = HomeService.Param(limit: self.limit, near: placemark.city, openNow: true, offset: offset, query: Config.query)
            HomeService.getVenues(params: params) { [weak self] result in
                guard let this = self else { return }
                switch result {
                case .success(let openningVenues):
                    if isLoadMore {
                        this.openningVenues.append(contentsOf: openningVenues)
                    } else {
                        this.openningVenues = openningVenues
                    }
                    if openningVenues.count < this.limit {
                        this.isFull = true
                    }
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

extension HomeViewModel {

    struct Config {
        static let title: String = "Find the best coffee \nfor you in "
        static let query: String = "coffee"
        static let heightOfTitle: Float = 21
    }
}
