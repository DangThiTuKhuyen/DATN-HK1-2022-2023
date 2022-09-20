//
//  DetailViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/1/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import RealmSwift

final class DetailViewModel {

    // MARK: - Properties
    var id: String
    private (set) var detailVenue: DetailVenue?
    private var similarVenues: [SimilarVenue] = []

    // MARK: - Init func
    init(id: String) {
        self.id = id
    }

    // MARK: - Private func
    private func randomImage() -> String {
        let index = Int.random(min: 1, max: 13)
        return "coffee\(index)"
    }

    // MARK: - Public func
    func convertArraytoList() {
        detailVenue?.location?.formattedAddress.forEach { address in
            detailVenue?.location?.formattedAddressList.append(address)
        }
        detailVenue?.photos.forEach { photo in
            detailVenue?.photoList.append(photo)
        }
        detailVenue?.photos.first?.items.forEach { item in
            detailVenue?.photos.first?.itemList.append(item)
        }
    }

    func showAddress() -> String {
        var address: String = ""
        guard let formattedAddress = detailVenue?.location?.formattedAddress else {
            return ""
        }
        for index in 0..<formattedAddress.count {
            address += formattedAddress[index] + " "
        }
        return address + Config.seeMap
    }

    func numberOfRating() -> Int {
        return Int(round((detailVenue?.rating ?? 0) / 2))
    }

    func numberOfItemsInSection() -> Int {
        let numberItem = detailVenue?.photos.first?.items.count ?? 0
        if numberItem == 0 {
            return 1
        } else {
            return numberItem
        }
    }

    func viewModelForItem(at indexPath: IndexPath) -> DetailCellViewModel {
        if numberOfItemsInSection() == 1 {
            return DetailCellViewModel(photoItem: nil)
        } else {
            let photoItem = detailVenue?.photos.first?.items ?? []
            return DetailCellViewModel(photoItem: photoItem[indexPath.row])
        }
    }

    func viewModelForItemSimilarVenue(at indexPath: IndexPath) -> SimilarCellViewModel {
        return SimilarCellViewModel(similarVenue: similarVenues[indexPath.row])
    }

    func numberOfRowInSectionSimilarVenue() -> Int {
        return similarVenues.count
    }

    func getIdSimilarVenue(at indexPath: IndexPath) -> String {
        return similarVenues[indexPath.row].id
    }
}

// MARK: - Reaml
extension DetailViewModel {

    func isFavorite() -> Bool {
        do {
            let realm = try Realm()
            let result = realm.objects(DetailVenue.self).first(where: { $0.id == id })
            return result != nil
        } catch {
            return false
        }
    }

    func addFavoriteVenue(completion: APICompletion) {
        guard let detailVenue = detailVenue else { return }
        do {
            let realm = try Realm()
            try realm.write {
                convertArraytoList()
                realm.create(DetailVenue.self, value: detailVenue, update: .all)
            }
            completion(.success)
        } catch {
            completion(.failure(error))
        }
    }

    func deleteFavoriteVenue(completion: APICompletion) {
        do {
            let realm = try Realm()
            let result = realm.objects(DetailVenue.self).first(where: { $0.id == id })
            if let object = result {
                try realm.write {
                    realm.delete(object)
                }
            }
            completion(.success)
        } catch {
            completion(.failure(error))
        }
    }
}

// MARK: - API
extension DetailViewModel {

    func getSimilarVenue(completion: @escaping APICompletion) {
        DetailService.getSimilarVenues(id: id) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let similarVenues):
                for venue in similarVenues {
                    venue.image = this.randomImage()
                }
                this.similarVenues = similarVenues
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getDetailById(completion: @escaping APICompletion) {
        DetailService.getDetailVenueById(id: id) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let detailVenue):
                this.detailVenue = detailVenue
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Config
extension DetailViewModel {

    struct Config {
        static let seeMap: String = " (See map...)"
    }
}
