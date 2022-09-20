//
//  DetailCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/1/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class DetailCell: UICollectionViewCell {

    // MARK: - IBOulets
    @IBOutlet private weak var detailImageView: UIImageView!

    // MARK: - Properties
    var viewModel: DetailCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Private func
    private func updateCell() {
        detailImageView.downloadImage(with: viewModel?.photoItem?.urlImage ?? "") { image in
            if image != nil {
                self.detailImageView.image = image
            } else {
                self.detailImageView.image = #imageLiteral(resourceName: "defaultImage")
            }
        }
    }
}
