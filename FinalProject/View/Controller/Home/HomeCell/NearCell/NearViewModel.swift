//
//  NearViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class NearViewModel {

    // MARK: - Properties
    private var nearVenues: [Venue] = []

    // MARK: - Init
    init(nearVenues: [Venue]) {
        self.nearVenues = nearVenues
    }

    // MARK: - Public func
    func numberOfItemInSection() -> Int {
        return nearVenues.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> RecommendViewModel {
        return RecommendViewModel(recommendVenue: nearVenues[indexPath.row])
    }

    func getIdNearVenue(at indexPath: IndexPath) -> String {
        return nearVenues[indexPath.row].id ?? ""
    }
}
