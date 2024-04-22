//
//  JBCPriceViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit
import Combine

protocol JBCPriceViewControllerOutputDelegate: AnyObject {

}

final class JBCPriceViewController: JobiBaseViewController {

    override var navigationTitle: String? {
        return "Fiyat Listesi"
    }
    
    override var navigationSubTitle: String? {
        return viewModel.navTitle
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IJBCPriceViewModel
    private weak var outputDelegate: JBCPriceViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Constraints Outlets
    
    // MARK: Initializer
    init(viewModel: IJBCPriceViewModel,
         outputDelegate: JBCPriceViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "JBCPriceViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        self.observeReactiveDatas()
        self.initTableView()

        DispatchQueue.delay(150) { [weak self] in
            self?.viewModel.getPrices()
        }
    }

    override func registerEvents() {

    }

    private func observeReactiveDatas() {
        observeViewState()
        listenErrorState()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showNativeProgress(let isProgress):
                self.playNativeLoading(isLoading: isProgress)

            case .reloadData:
                self.tableView.reloadData()
            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .addNavLoupe) { [unowned self] _ in
            self.viewModel.presentNewJBCPriceViewController()
        }
    }()
}

// MARK: Props
private extension JBCPriceViewController {
    
    func initTableView() {
        tableView.registerCell(JBCPriceItemCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        
        tableViewReload()
    }

    func tableViewReload() {
        tableView.reloadData()
        tableView.animatedAlpha(from: 0, to: 1, withDuration: 1)
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension JBCPriceViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInRow()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(JBCPriceItemCell.self, indexPath: indexPath)
        cell.configureCell(with: viewModel.getItemCellUIModel(indexPath: indexPath))
        cell.outputDelegate = self.viewModel
        return cell
    }
}

