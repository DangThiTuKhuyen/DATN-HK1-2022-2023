//
//  CategoryViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/18/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class CategoryViewModel {

    // MARK: - Properties
    private var categories: [Category] = []
    var selectFilter: [String] = []

    // MARK: - Public func
    func getCategories(completion: @escaping APICompletion) {
        SearchService.shared().getCategories { [weak self] result in
            guard let this = self else { return completion(.failure(Api.Error.json)) }
            switch result {
            case .success(let categories):
                this.categories = categories
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func showSelect(at indexPath: IndexPath) -> Bool {
        let category = categories[indexPath.row]
        for id in selectFilter where category.id == id {
            category.isSelected = true
        }
        return category.isSelected
    }

    func numberOfItemInSection() -> Int {
        return categories.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> CategoryCellViewModel {
        return CategoryCellViewModel(category: categories[indexPath.row])
    }

    func isSelected(at indexPath: IndexPath) -> Bool {
        return categories[indexPath.row].isSelected
    }

    func isRemoveSelectd(at indexPath: IndexPath) -> Bool {
        if isSelected(at: indexPath) {
            guard let index = selectFilter.firstIndex(of: categories[indexPath.row].id ?? "") else { return false }
            selectFilter.remove(at: index)
            categories[indexPath.row].isSelected = false
            return true
        } else {
            selectFilter.append(categories[indexPath.row].id ?? "")
            categories[indexPath.row].isSelected = true
            return false
        }
    }
}
