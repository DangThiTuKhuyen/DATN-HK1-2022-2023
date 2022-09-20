//
//  RecommandTableViewViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class RecommendTableViewViewModel {

    // MARK: - Properties
    private var recommendVenues: [Venue] = []

    // MARK: - Init
    init(recommendVenues: [Venue]) {
        self.recommendVenues = recommendVenues
    }

    // MARK: Public func
    func numberOfItemInSection() -> Int {
        return recommendVenues.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> RecommendViewModel {
        return RecommendViewModel(recommendVenue: recommendVenues[indexPath.row])
    }

    func getIdRecommendVenue(at indexPath: IndexPath) -> String {
        return recommendVenues[indexPath.row].id ?? ""
    }
}
