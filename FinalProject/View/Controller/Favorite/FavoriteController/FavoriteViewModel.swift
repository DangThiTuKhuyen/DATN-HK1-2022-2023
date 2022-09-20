//
//  FavoriteViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/10/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import RealmSwift

final class FavoriteViewModel {

    // MARK: - Properties
    var favoriteVenues: [DetailVenue] = []

    // MARK: - Public func
    func getFavoriteVenues(completion: (Bool) -> Void) {
        do {
            let realm = try Realm()
            let results = realm.objects(DetailVenue.self)
            favoriteVenues = Array(results)
            completion(true)
        } catch {
            completion(false)
        }
    }

    func deleteFavoriteVenue(id: String, at indexPath: IndexPath, completion: APICompletion) {
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
        favoriteVenues.remove(at: indexPath.row )
    }

    func numberOfRowInSection() -> Int {
        return favoriteVenues.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> FavoriteCellViewModel {
        return FavoriteCellViewModel(favoriteVenue: favoriteVenues[indexPath.row])
    }

    func getId(at indexPath: IndexPath) -> String {
        return favoriteVenues[indexPath.row].id ?? ""
    }
}
