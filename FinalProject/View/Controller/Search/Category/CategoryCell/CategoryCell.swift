//
//  CategoryCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/19/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class CategoryCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - Properties
    var viewModel: CategoryCellViewModel? {
        didSet {
            updateNearCell()
        }
    }

    var isSelect: Bool = false {
        didSet {
            if isSelect {
                backgroundColor = .lightGray
            } else {
                backgroundColor = .none
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
    }

    // MARK: - Private func
    private func updateNearCell() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.category.name
    }
}
