//
//  OpenningViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
final class OpenningViewModel {

    // MARK: - Properties
    private (set) var openningVenues: [Venue] = []

    // MARK: - Init
    init(openningVenues: [Venue]) {
        self.openningVenues = openningVenues
    }

    // MARK: - Public func
    func numberOfItemInSection() -> Int {
        return openningVenues.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> RecommendViewModel {
        return RecommendViewModel(recommendVenue: openningVenues[indexPath.row])
    }

    func getIdOpenningVenue(at indexPath: IndexPath) -> String {
        return openningVenues[indexPath.row].id ?? ""
    }
}
