//
//  SimilarCellViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/23/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class SimilarCellViewModel {

    // MARK: - Properties
    var similarVenue: SimilarVenue

    // MARK: - Init
    init(similarVenue: SimilarVenue) {
        self.similarVenue = similarVenue
    }

    // MARK: - Public func
    func showAddress() -> String {
        var result: String = ""
        for items in similarVenue.address?.formattedAddress ?? [] {
            result += items + " "
        }
        return result
    }
}
