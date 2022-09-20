//
//  FavoriteCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/8/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol FavoriteCellDelegate: AnyObject {
    func cell(_ cell: FavoriteCell, needPerformAction action: FavoriteCell.Action)
}

final class FavoriteCell: UITableViewCell {

    // MARK: - Enum
    enum Action {
        case deleteFavorite(id: String)
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var reviewLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: FavoriteCellViewModel? {
        didSet {
            updateFavoriteCell()
        }
    }
    weak var delegate: FavoriteCellDelegate?

    // MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height / 2
    }

    // MARK: - Private func
    private func updateFavoriteCell() {
        guard let viewModel = viewModel else { return }
        photoImageView.downloadImage(with: viewModel.favoriteVenue.photoList.first?.itemList.first?.urlImage ?? "") { image in
            self.photoImageView.image = image
        }
        nameLabel.text = viewModel.favoriteVenue.name
        addressLabel.text = viewModel.showAddress()
        reviewLabel.text = "\(viewModel.favoriteVenue.rating) ⭐️"
    }

    // MARK: - IBActions
    @IBAction private func favoriteButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, needPerformAction: .deleteFavorite(id: viewModel.favoriteVenue.id ?? ""))
    }
}
