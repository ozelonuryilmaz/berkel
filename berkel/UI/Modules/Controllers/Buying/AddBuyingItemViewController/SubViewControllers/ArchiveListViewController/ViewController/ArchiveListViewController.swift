//
//  ArchiveListViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import UIKit
import Combine

final class ArchiveListViewController: MainBaseViewController {

    override var navigationTitle: String? {
        return "Arşiv"
    }

    // MARK: Constants
    @IBOutlet private weak var segmentedController: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Inject
    private let viewModel: IArchiveListViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IArchiveListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ArchiveListViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()

        self.initTableView()
        self.viewModel.getArchive()
    }

    override func registerEvents() {
        segmentedController.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
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

            case .reloadTableView:
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
}

// MARK: Props
private extension ArchiveListViewController {

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.viewModel.setArchiveType(index: sender.selectedSegmentIndex)
        self.viewModel.getArchive()
    }
    
    func initTableView() {
        self.tableView.registerCell(ArchiveListTableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        self.tableView.removeTableHeaderView()
        self.tableView.removeTableFooterView()
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension ArchiveListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumberOfItemsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(ArchiveListTableViewCell.self, indexPath: indexPath)
        cell.configureCell(with: self.viewModel.getCellUIModel(at: indexPath.row))
        cell.outputDelegate = self.viewModel
        cell.visibleSeperator(isVisible: false)
        return cell
    }
}
