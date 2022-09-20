//
//  FavoriteViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/10/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class FavoriteViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel: FavoriteViewModel?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configFavoriteTableViewCell()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupData()
    }

    // MARK: - Private func
    private func setupData() {
        guard let viewModel = viewModel else { return }
        viewModel.getFavoriteVenues { [weak self] done in
            guard let this = self else { return }
            if done {
                this.tableView.reloadData()
            } else {
                this.alert(msg: Config.errorGetFromRealm, handler: nil)
            }
        }
    }

    private func deleteFavoriteVenue(id: String, at indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.deleteFavoriteVenue(id: id, at: indexPath) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                break
            case .failure(let error):
                this.alert(msg: error.localizedDescription, handler: nil)
            }
        }
    }

    private func configUI() {
        title = "Your Favorites"
    }
    
    private func configFavoriteTableViewCell() {
        tableView.register(FavoriteCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfRowInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoriteCell.self)
        cell.viewModel = viewModel?.viewModelForItem(at: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.heightItem
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel else { return }
        let detailVC = DetailViewController()
        detailVC.viewModel = DetailViewModel(id: viewModel.getId(at: indexPath))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - FavoriteCellDelegate
extension FavoriteViewController: FavoriteCellDelegate {
    func cell(_ cell: FavoriteCell, needPerformAction action: FavoriteCell.Action) {
        switch action {
        case .deleteFavorite(let id):
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            deleteFavoriteVenue(id: id, at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension FavoriteViewController {

    struct Config {
        static let heightItem: CGFloat = 100
        static let errorGetFromRealm: String = "Realm error"
    }
}
