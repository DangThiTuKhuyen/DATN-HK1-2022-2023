//
//  SearchCellViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/17/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class SearchCellViewModel {

    // MARK: - Properties
    private (set) var searchVenue: SearchVenue
    var isShowDeleteHistoryButton: Bool

    // MARK: - Init
    init(searchVenues: SearchVenue, isShowDeleteHistoryButton: Bool) {
        self.searchVenue = searchVenues
        self.isShowDeleteHistoryButton = isShowDeleteHistoryButton
    }
}
