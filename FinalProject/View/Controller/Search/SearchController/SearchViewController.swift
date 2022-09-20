//
//  SearchViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/25/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import Speech

final class SearchViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var widthFilterButtonConstraint: NSLayoutConstraint!
    @IBOutlet private weak var noDataImageView: UIImageView!
    @IBOutlet private weak var microphoneButton: UIButton!

    // MARK: - Properties
    var viewModel: SearchViewModel?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "vi-VN"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        configSearchTableViewCell()
        configSearchBar()
        getHistoryVenue()
        configMirco()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        searchBar.resignFirstResponder()
    }

    func updateUI(isNeedReloadTableView: Bool = true) {
        let isShowTableView = viewModel?.isShowTableView() ?? false
        tableView.isHidden = !isShowTableView
        noDataImageView.isHidden = isShowTableView
        if isShowTableView && isNeedReloadTableView {
            tableView.reloadData()
        }
    }

    private func configMirco() {
        speechRecognizer?.delegate = self
    }

    private func requestAuthorizationMicro() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            default:
                print("")
            }
        }
    }

    func startRecording() {
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        recognitionRequest.shouldReportPartialResults = true  //6
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            var isFinal = false  //8
            if result != nil {
                self.searchBar.text = result?.bestTranscription.formattedString  //9
                isFinal = (result?.isFinal) ?? false
            }
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.microphoneButton.isEnabled = true
            }
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1_024, format: recordingFormat) { (buffer, _ ) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()  //12
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        searchBar.text = "Say something, I'm listening!"
    }
    // MARK: - Private func
    private func getHistoryVenue() {
        guard let viewModel = viewModel else { return }
        viewModel.getHistoryVenues { done in
            if done {
                self.updateUI()
            } else {
                self.alert(msg: Config.realmError, handler: nil)
            }
        }
    }

    private func configSearchTableViewCell() {
        tableView.register(SearchCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
    }

    private func configSearchBar() {
        widthFilterButtonConstraint.constant = 0
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }

    private func search() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getVenues { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.updateUI()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func deleteHistory(id: String, at indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.deleteHistory(id: id, at: indexPath) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                break
            case .failure(let error):
                this.alert(msg: error.localizedDescription, handler: nil)
            }
        }
    }

    private func addHistory() {
        guard let viewModel = viewModel else { return }
        viewModel.addHistory { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                break
            case .failure(let error):
                this.alert(msg: error.localizedDescription, handler: nil)
            }
        }
    }

    // MARK: - IBActions
    @IBAction private func filterButtonTouchUpInside(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        let categoryVC = CategoryViewController()
        categoryVC.delegate = self
        categoryVC.viewModel.selectFilter = viewModel.categoryId
        categoryVC.modalPresentationStyle = .fullScreen
        navigationController?.present(categoryVC, animated: true, completion: nil)
    }

    @IBAction private func searchButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        guard let searchText = searchBar.text, searchText.isNotEmpty else { return }
        searchBar.resignFirstResponder()
        viewModel.query = searchText
        search()
        widthFilterButtonConstraint.constant = Config.widthOfFilterButton
    }

    @IBAction func microphoneTouchUpInside(_ sender: Any) {
        requestAuthorizationMicro()
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        } else {
            startRecording()
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel?.numberOfRowInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeue(SearchCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.heightForRow
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        detailVC.viewModel = DetailViewModel(id: viewModel.searchVenues[indexPath.row].id)
        viewModel.searchVenue = viewModel.searchVenues[indexPath.row]
        addHistory()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isNotEmpty else {
            getHistoryVenue()
            widthFilterButtonConstraint.constant = 0
            return
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let viewModel = viewModel else { return }
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, searchText.isNotEmpty else { return }
        viewModel.query = searchText
        search()
        widthFilterButtonConstraint.constant = Config.widthOfFilterButton
    }
}

// MARK: - CategoryViewControllerDelegate
extension SearchViewController: CategoryViewControllerDelegate {

    func controller(_ controller: CategoryViewController, needPerformAction action: CategoryViewController.Action) {
        switch action {
        case .passFilter(let selectFilter):
            guard let viewModel = viewModel else { return }
            if viewModel.categoryId.isEmpty && selectFilter.isEmpty { return }
            viewModel.categoryId = selectFilter
            viewModel.query = searchBar.text ?? ""
            search()
        }
    }
}

// MARK: - SearchCellDelegate
extension SearchViewController: SearchCellDelegate {
    func cell(_ cell: SearchCell, needPerformAction action: SearchCell.Action) {
        switch action {
        case .deleteHistory(let id):
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            deleteHistory(id: id, at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateUI(isNeedReloadTableView: false)
        }
    }
}

extension SearchViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
}

// MARK: - Config
extension SearchViewController {

    struct Config {
        static let heightForRow: CGFloat = 100
        static let widthOfFilterButton: CGFloat = 25
        static let realmError: String = "Realm error!"
    }
}
