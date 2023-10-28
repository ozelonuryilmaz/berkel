//
//  WarehouseListViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//

import UIKit
import Combine

final class WarehouseListViewController: BerkelBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IWarehouseListViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IWarehouseListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "WarehouseListViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]

        self.observeReactiveDatas()
        self.initTableView()
        self.viewModel.initComponents()
    }

    override func registerEvents() {

    }

    private func observeReactiveDatas() {
        observeViewState()
        listenErrorState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewStateSetNavigationTitle()
        self.tableView.reloadData()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showNativeProgress(let isProgress):
                self.playNativeLoading(isLoading: isProgress)
                
            case .addNewWavehouseButton:
                self.navigationItem.rightBarButtonItems = [self.addBarButtonItem]
                
            case .setNavigationTitle(let title, let subTitle):
                self.navigationItem.setCustomTitle(title, subtitle: subTitle)

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

    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .addNavLoupe) { [unowned self] _ in
            self.viewModel.pushNewWarehouseViewController()
        }
    }()
}

// MARK: Props
private extension WarehouseListViewController {

    func initTableView() {
        self.tableView.registerCell(WarehouseListTableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        self.tableView.removeTableHeaderView()
        self.tableView.removeTableFooterView()
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension WarehouseListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumberOfItemsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(WarehouseListTableViewCell.self, indexPath: indexPath)
        cell.configureCell(with: self.viewModel.getCellUIModel(at: indexPath.row))
        cell.visibleSeperator(isVisible: false)
        return cell
    }

}
