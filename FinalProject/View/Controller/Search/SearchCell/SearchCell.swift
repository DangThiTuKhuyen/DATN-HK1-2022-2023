//
//  SearchCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/17/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol SearchCellDelegate: AnyObject {
    func cell(_ cell: SearchCell, needPerformAction action: SearchCell.Action)
}

final class SearchCell: UITableViewCell {

    // MARK: - 
    enum Action {
        case deleteHistory(id: String)
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var deleteHistoryButton: UIButton!

    // MARK: - Properties
    var viewModel: SearchCellViewModel? {
        didSet {
            updateCell()
        }
    }
    weak var delegate: SearchCellDelegate?

    // MARK: - Public func
    func updateCell() {
        guard let viewModel = viewModel else { return }
        photoImageView.image = UIImage(named: viewModel.searchVenue.image)
        nameLabel.text = viewModel.searchVenue.name
        addressLabel.text = viewModel.searchVenue.location?.address
        distanceLabel.text = String(viewModel.searchVenue.location?.distance ?? 0) + "m"
        deleteHistoryButton.isHidden = !viewModel.isShowDeleteHistoryButton
    }

    // MARK: - IBAction
    @IBAction private func deleteHistoryTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, needPerformAction: .deleteHistory(id: viewModel.searchVenue.id))
    }
}
