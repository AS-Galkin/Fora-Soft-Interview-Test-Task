//
//  HistoryViewController.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Foundation

protocol HistoryDisplayLogic: AnyObject {
    func displayData(viewModel: History.Model.ViewModel.ViewModelData)
}

/*
 # Class that displaying searching history
 */
class HistoryViewController: UIViewController, HistoryDisplayLogic {
    //MARK: - Variables
    /// TableView for displaying history
    var historyTableView: UITableView?
    /// Internal object to store tracks
    private var historyViewModel: HistoryViewModel = HistoryViewModel(terms: [])
    /// Interactor that interact with external services.
    var interactor: HistoryBusinessLogic?
    /// Routing between Screens, controllers, etc.
    var router: (NSObjectProtocol & HistoryRoutingLogic)?
    
    // MARK: - Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    /// Setup VIP circle
    private func setup() {
        let viewController        = self
        let interactor            = HistoryInteractor()
        let presenter             = HistoryPresenter()
        let router                = HistoryRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView = generateTableView()
        interactor?.makeRequest(request: .loadHistory)
        if historyTableView != nil {
            view.addSubview(historyTableView!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// Says interactor to download history
        interactor?.makeRequest(request: .loadHistory)
    }
    
    //MARK: - Displaying data
    /**
     Displaying viewing content depending on the *ViewModelData*.
     */
    func displayData(viewModel: History.Model.ViewModel.ViewModelData) {
        switch viewModel {
            /// Displaying history when it loaded
        case .displayHistory(let history):
            self.historyViewModel = history
            guard let table = historyTableView else { return }
            table.reloadData()
            break
        @unknown default:
            break
        }
    }
    
    //MARK: - Other methods
    /// Generate TableView with standart cell.
    private func generateTableView() -> UITableView {
        let tableView = UITableView(frame: self.view.frame, cell: UITableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    ///How many cells to show
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyViewModel.terms.count
    }
    /// Fill up fields of cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = historyViewModel.terms[indexPath.row]
        return cell
    }
    /// Selecting data from TableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Says Router that need route to SerchViewController and send him searched text.
        router?.routeToSearchViewController(searchTerm: historyViewModel.terms[indexPath.row])
    }
    /// Deleting element from history and tableView.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            historyViewModel.terms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            interactor?.makeRequest(request: .saveNewHistory(history: historyViewModel))
        }
    }
}
