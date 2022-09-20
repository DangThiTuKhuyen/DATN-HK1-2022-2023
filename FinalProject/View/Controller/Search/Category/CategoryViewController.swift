//
//  CategoryViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/18/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol CategoryViewControllerDelegate: AnyObject {
    func controller(_ controller: CategoryViewController, needPerformAction action: CategoryViewController.Action)
}

final class CategoryViewController: UIViewController {

    // MARK: - Enum
    enum Action {
        case passFilter(selectFilter: [String])
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    weak var delegate: CategoryViewControllerDelegate?

    // MARK: - Properties
    var viewModel = CategoryViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        configUICategory()
        getCategories()
    }

    // MARK: - Private func
    private func getCategories() {
        viewModel.getCategories { [weak self] result in
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.collectionView.reloadData()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func configUICategory() {
        collectionView.register(CategoryCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
    }

    @IBAction private func applyButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.controller(self, needPerformAction: .passFilter(selectFilter: viewModel.selectFilter))
    }

    @IBAction private func closeButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension CategoryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemInSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CategoryCell.self, forIndexPath: indexPath)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        cell.isSelect = viewModel.showSelect(at: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { return }
        cell.isSelect = !viewModel.isRemoveSelectd(at: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = viewModel.viewModelForItem(at: indexPath).category.name?.widthOfString(usingFont: UIFont.systemFont(ofSize: Config.fontSize)) ?? 0.0
        return CGSize(width: width + Config.widthItem, height: Config.heightOfItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Config.minimumLineSpacingForSection
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Config.minimumInteritemSpacingForSection
    }
}

// MARK: - Config
extension CategoryViewController {

    struct Config {
        static let minimumLineSpacingForSection: CGFloat = 30
        static let minimumInteritemSpacingForSection: CGFloat = 20
        static let fontSize: CGFloat = 17
        static let heightOfItem: CGFloat = 40
        static let widthItem: CGFloat = 20
    }
}

// MARK: - Extension String
extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

// MARK: - LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
