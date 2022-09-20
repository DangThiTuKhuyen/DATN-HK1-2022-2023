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
    @IBOutlet private weak var containerView: UIView!

    // MARK: - Properties
    var viewModel: DetailCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.makeShadowAndCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                                                   radius: 5,
                                                   shadowColor: .black,
                                                   backgroundColor: .white,
                                                   offset: CGSize(width: 0, height: 0),
                                                   opacity: 0.8)
    }

    // MARK: - Private func
    private func setupUI() {
        detailImageView.layer.cornerRadius = 20
    }

    private func updateCell() {
        detailImageView.downloadImage(with: viewModel?.photoItem?.urlImage ?? "") { image in
            self.detailImageView.image = image
        }
    }
}

// MARK: - Extension UIView
extension UIView {
     func makeShadowAndCorners(corners: UIRectCorner, radius: CGFloat, shadowColor: UIColor, backgroundColor: UIColor, offset: CGSize = CGSize(width: 0, height: 0), opacity: Float = 1.0) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = path.cgPath
        shadowLayer.fillColor = backgroundColor.cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        layer.insertSublayer(shadowLayer, at: 0)
    }
}
