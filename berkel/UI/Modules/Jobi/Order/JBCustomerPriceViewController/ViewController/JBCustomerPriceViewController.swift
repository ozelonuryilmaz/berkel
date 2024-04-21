//
//  JBCustomerPriceViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit
import Combine

protocol JBCustomerPriceViewControllerOutputDelegate: AnyObject {

}

final class JBCustomerPriceViewController: BerkelBaseViewController {
    
    override var navigationTitle: String? {
        return viewModel.customerName
    }
    
    override var navigationSubTitle: String? {
        return "Fiyat Listesi"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IJBCustomerPriceViewModel
    private weak var outputDelegate: JBCustomerPriceViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Constraints Outlets
    
    // MARK: Initializer
    init(viewModel: IJBCustomerPriceViewModel,
         outputDelegate: JBCustomerPriceViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "JBCustomerPriceViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()
        
        self.initTableView()
        self.viewModel.getStock()
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
                
            case .reloadDataWith(let indexPath):
                self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)

            case .showToastMessage(let message):
                self.showToast(message: message)
            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .closeNav) { [unowned self] _ in
            self.viewModel.dismiss()
        }
    }()
}

// MARK: Props
private extension JBCustomerPriceViewController {
    
    func initTableView() {
        tableView.registerHeaderFooterView(StockHeaderCell.self)
        tableView.registerCell(StockItemCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
    }

    func tableViewReload() {
        tableView.reloadData()
        tableView.animatedAlpha(from: 0, to: 1, withDuration: 1)
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension JBCustomerPriceViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfItemsInSection()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInRow(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(StockItemCell.self, indexPath: indexPath)
        cell.configureCell(with: viewModel.getItemCellUIModel(indexPath: indexPath))
        cell.outputDelegate = self.viewModel
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.generateReusableHeaderFooterView(StockHeaderCell.self)
        sectionView.configureCell(with: self.viewModel.getSectionUIModel(section: section))
        return sectionView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SettingsHeaderCell.defaultHeight + 32 // 32 for date
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}


