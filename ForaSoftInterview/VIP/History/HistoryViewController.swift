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

class HistoryViewController: UIViewController, HistoryDisplayLogic {
    
    var historyTableView: UITableView?
    
    var historyViewModel: HistoryViewModel = HistoryViewModel(terms: []) {
        didSet {
            guard let table = historyTableView else { return }
            table.reloadData()
        }
    }
    
    var interactor: HistoryBusinessLogic?
    
    var router: (NSObjectProtocol & HistoryRoutingLogic)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
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
    
    // MARK: View lifecycle
    
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
        
        interactor?.makeRequest(request: .loadHistory)
    }
    
    func displayData(viewModel: History.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayHistory(let history):
            self.historyViewModel = history
            break
        @unknown default:
            break
        }
    }
    
    private func generateTableView() -> UITableView {
        let tableView = UITableView(frame: self.view.frame, cell: UITableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyViewModel.terms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = historyViewModel.terms[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToSearchViewController(searchTerm: historyViewModel.terms[indexPath.row])
    }
}
