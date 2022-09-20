//
//  SimilarCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/23/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class SimilarCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!

    // MARK: - Properties
    var viewModel: SimilarCellViewModel? {
        didSet {
            updateFavoriteCell()
        }
    }

    // MARK: - Private func
    private func updateFavoriteCell() {
        guard let viewModel = viewModel else { return }
        photoImageView.image = UIImage(named: viewModel.similarVenue.image)
        nameLabel.text = viewModel.similarVenue.name
        addressLabel.text = viewModel.showAddress()
    }
}
